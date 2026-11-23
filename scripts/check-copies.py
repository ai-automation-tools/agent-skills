#!/usr/bin/env python3
"""Report drift between this repo's skills and their hand-kept copies in other repos.

Reads scripts/copies.json. For each entry it lists the git blobs under `source` at HEAD
(`git ls-tree`, so line endings and local edits don't matter) and the blobs under `path`
in `repo` at `ref` (GitHub's tree API), and reports files that are missing, extra or
different. This repo is canonical: the check reports, never edits. Standard library only.

    python scripts/check-copies.py             # every entry; exit 1 on drift
    python scripts/check-copies.py --self-check

A token in GH_TOKEN or GITHUB_TOKEN is used when set (higher rate limit); public repos
need none. Runs weekly in .github/workflows/copies.yml.
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import urllib.request
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
MANIFEST = REPO / "scripts" / "copies.json"


def local_blobs(source: str) -> dict[str, str]:
    """{path relative to source: blob sha} as committed at HEAD."""
    out = subprocess.run(["git", "-C", str(REPO), "ls-tree", "-r", "HEAD", "--", source],
                         capture_output=True, text=True, check=True).stdout
    blobs = {}
    for line in out.splitlines():
        meta, path = line.split("\t", 1)
        _, kind, sha = meta.split()
        if kind == "blob":
            blobs[path[len(source):].lstrip("/")] = sha
    return blobs


def remote_blobs(repo: str, ref: str, path: str) -> dict[str, str]:
    url = f"https://api.github.com/repos/{repo}/git/trees/{ref}?recursive=1"
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json", "User-Agent": "agent-skills-check-copies"})
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30) as r:
        data = json.load(r)
    if data.get("truncated"):
        raise RuntimeError(f"{repo}@{ref}: tree listing truncated")
    prefix = path.rstrip("/") + "/"
    return {e["path"][len(prefix):]: e["sha"] for e in data["tree"]
            if e["type"] == "blob" and e["path"].startswith(prefix)}


def diff(src: dict[str, str], copy: dict[str, str]) -> list[str]:
    out = [f"missing in copy: {p}" for p in sorted(src.keys() - copy.keys())]
    out += [f"only in copy:    {p}" for p in sorted(copy.keys() - src.keys())]
    out += [f"differs:         {p}" for p in sorted(src.keys() & copy.keys()) if src[p] != copy[p]]
    return out


def self_check() -> int:
    assert diff({"a": "1", "b": "2"}, {"a": "1", "b": "2"}) == []
    assert diff({"a": "1", "b": "2", "c": "3"}, {"a": "1", "b": "9", "d": "4"}) == [
        "missing in copy: c", "only in copy:    d", "differs:         b"]
    entries = json.loads(MANIFEST.read_text(encoding="utf-8"))["copies"]
    for e in entries:
        assert {"source", "repo", "path", "ref"} <= e.keys(), e
        assert (REPO / e["source"] / "SKILL.md").is_file(), f"copies.json source is not a skill: {e['source']}"
    print("self-check ok")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--self-check", action="store_true")
    if ap.parse_args().self_check:
        return self_check()
    entries = json.loads(MANIFEST.read_text(encoding="utf-8"))["copies"]
    drift = errors = 0
    for e in entries:
        where = f"{e['repo']}:{e['path']}@{e['ref']}"
        try:
            problems = diff(local_blobs(e["source"]), remote_blobs(e["repo"], e["ref"], e["path"]))
        except Exception as ex:  # network, rate limit, a renamed repo: report it, don't hide it as "clean"
            errors += 1
            print(f"ERROR {e['source']} -> {where}: {ex}")
            continue
        if problems:
            drift += 1
            print(f"DRIFT {e['source']} -> {where}")
            for p in problems:
                print(f"      {p}")
        else:
            print(f"ok    {e['source']} -> {where}")
    print(f"\n{len(entries)} copies: {drift} drifted, {errors} could not be checked.")
    return 1 if drift or errors else 0


if __name__ == "__main__":
    sys.exit(main())
