#!/usr/bin/env python3
"""List every Agent Skill in the org's repos and flag copies that have drifted apart.

Walks each repo's default branch with GitHub's tree API, finds every SKILL.md, and groups
skills by name. Two folders with the same name are copies; they match when their git tree
SHAs match (every file byte-identical), so no clone is needed. Writes a Markdown catalog.

    python scripts/scan-org-skills.py                        # public repos -> docs/CATALOG.md
    python scripts/scan-org-skills.py --check                # same, exit 1 if a copy drifted
    python scripts/scan-org-skills.py --include-private --out <file outside this repo>
    python scripts/scan-org-skills.py --self-check

Public repos only by default, because this repo is public and docs/CATALOG.md must not list
what private repos contain. --include-private is for a local report kept outside the repo.
Token: GH_TOKEN or GITHUB_TOKEN, else `gh auth token`, else anonymous (60 calls/hour, too
few for a full run). Standard library only.
"""
from __future__ import annotations

import argparse
import base64
import datetime
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import urllib.request
from collections import defaultdict
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
ORG = "ai-automation-tools"
# Not org-authored skills: project-hub's demo fixtures, promptbook's third-party library,
# vendored packages. .agents/skills/ is the generated Codex/Antigravity mirror of
# .claude/skills/, so it's counted as a property of the wired skill, not a second row.
EXCLUDE = re.compile(r"(^|/)(demo|node_modules)/|^site/library/")
MIRROR = ".agents/skills/"
MARKER = ".installed-from-agent-skills"  # written by install-skills.ps1 into every copy it installs


def token() -> str | None:
    t = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if t or not shutil.which("gh"):
        return t
    out = subprocess.run(["gh", "auth", "token"], capture_output=True, text=True)
    return out.stdout.strip() or None


def api(path: str, tok: str | None):
    req = urllib.request.Request(f"https://api.github.com/{path}", headers={
        "Accept": "application/vnd.github+json", "User-Agent": "agent-skills-scan-org-skills"})
    if tok:
        req.add_header("Authorization", f"Bearer {tok}")
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def list_repos(tok: str | None, include_private: bool) -> list[dict]:
    repos, page = [], 1
    while True:
        batch = api(f"orgs/{ORG}/repos?type=all&per_page=100&page={page}", tok)
        repos += batch
        if len(batch) < 100:
            break
        page += 1
    return sorted((r for r in repos if not r["archived"] and (include_private or not r["private"])),
                  key=lambda r: r["name"])


def kind(repo: str, folder: str) -> str:
    """Where a skill folder sits, in the words docs/CATALOG.md uses."""
    if repo == "agent-skills" and folder.startswith("skills/"):
        return folder.split("/")[1].capitalize()  # Core / Domain
    if folder.startswith(".claude/skills/"):
        return "wired"
    if folder.startswith("skills/"):
        return "portable"
    return "bundled"


def description(skill_md: str) -> str:
    """The frontmatter description, cut to its first clause for a table cell."""
    fm = re.match(r"---\s*\n(.*?)\n---", skill_md, re.S)
    m = re.search(r"^description:\s*(.*?)(?=^[\w-]+:|\Z)", fm.group(1) if fm else "", re.S | re.M)
    d = " ".join((m.group(1) if m else "").split())
    d = re.sub(r"^[>|][-+]?\s*", "", d).strip("\"'").replace("|", "/")
    head = re.split(r" [—–] | because |: ", d)[0]
    d = head if len(head) >= 25 else d
    s = re.match(r"(.+?[.!?])(\s|$)", d)
    d = s.group(1) if s else d
    return d if len(d) <= 150 else d[:150].rsplit(" ", 1)[0] + "…"


def find_skills(tree: list[dict]) -> list[dict]:
    """Skill folders in one repo's tree: [{folder, sha, skill_sha, mirrored, mirror_same}].

    `sha` fingerprints the folder's files (path + blob) minus install-skills.ps1's marker, so a
    copy installed from this repo still matches its source.
    """
    blobs = [(e["path"], e["sha"]) for e in tree if e["type"] == "blob" and not e["path"].endswith("/" + MARKER)]
    trees = {e["path"] for e in tree if e["type"] == "tree"}

    def fingerprint(folder: str) -> str:
        pre = folder + "/" if folder else ""
        return hashlib.sha1(repr(sorted((p[len(pre):], s) for p, s in blobs if p.startswith(pre))).encode()).hexdigest()

    out = []
    for p, s in blobs:
        if not (p == "SKILL.md" or p.endswith("/SKILL.md")) or EXCLUDE.search(p) or p.startswith(MIRROR):
            continue
        folder = p.rsplit("/", 1)[0] if "/" in p else ""
        mirror = MIRROR + folder[len(".claude/skills/"):] if folder.startswith(".claude/skills/") else None
        out.append({"folder": folder, "sha": fingerprint(folder), "skill_sha": s, "mirrored": mirror in trees,
                    "mirror_same": mirror in trees and fingerprint(mirror) == fingerprint(folder)})
    return out


def copies(skills: list[dict]) -> dict[str, list[dict]]:
    """Skill name -> its rows, for names that appear in more than one repo."""
    by = defaultdict(list)
    for s in skills:
        by[s["name"]].append(s)
    return {n: v for n, v in by.items() if len({s["repo"] for s in v}) > 1}


# Third-party skills each repo vendors on its own, with its own README: copies may differ, so they
# never count as drift. Name -> upstream.
VENDORED = {"humanizer": "blader/humanizer"}


def drifted(group: list[dict]) -> bool:
    return group[0]["name"] not in VENDORED and len({s["sha"] for s in group}) > 1


def render(skills: list[dict], repos: list[dict], include_private: bool, today: str) -> str:
    dup = copies(skills)
    vis = {r["name"]: ("private" if r["private"] else "public") for r in repos}
    by_repo = defaultdict(list)
    for s in skills:
        by_repo[s["repo"]].append(s)
    bad = sorted(n for n, g in dup.items() if drifted(g))
    scope = "every non-archived repo" if include_private else "every public, non-archived repo"
    lines = [
        "# Org skill catalog", "",
        f"Every `SKILL.md` in {scope} of [`{ORG}`](https://github.com/{ORG}), generated "
        f"{today} by [`scripts/scan-org-skills.py`](../scripts/scan-org-skills.py). Don't edit by hand: rerun it.", "",
        "**Kinds:** `Core` / `Domain` are this repo's tiers. `portable` = a repo's `skills/` "
        "(travels; installable elsewhere). `wired` = `.claude/skills/` (loads only inside that repo; "
        "`+ .agents` = also mirrored for Codex and Antigravity). `bundled` = shipped inside app source. "
        "**Copies:** `=` the other repo's folder is byte-identical, `≠` it has drifted, `≈` a third-party "
        "skill each repo vendors on its own (not drift).", "",
        f"**{len({s['name'] for s in skills})} skills** ({len(skills)} folders) in **{len(by_repo)} of "
        f"{len(repos)} repos**. Drifted copies: **{len(bad)}**" + (f" ({', '.join(f'`{n}`' for n in bad)})." if bad else "."), "",
    ]
    order = {"Core": 0, "Domain": 1, "portable": 2, "wired": 3, "bundled": 4}
    for name in sorted(by_repo, key=lambda n: (n != "agent-skills", n)):
        rows = sorted(by_repo[name], key=lambda s: (order[s["kind"]], s["folder"]))
        branch = rows[0]["branch"]
        lines += [f"## {name} ({vis[name]})", "", "| Skill | Kind | Copies | What it does |", "|:---|:---|:---|:---|"]
        for s in rows:
            k = s["kind"] + (" + `.agents`" + ("" if s["mirror_same"] else " ≠") if s["mirrored"] else "")
            other = sorted({("=" if o["sha"] == s["sha"] else "≈" if s["name"] in VENDORED else "≠") + f" `{o['repo']}`"
                            for o in dup.get(s["name"], []) if o["repo"] != name})
            link = f"https://github.com/{ORG}/{name}/tree/{branch}/{s['folder']}"
            lines.append(f"| [**{s['name']}**]({link}) | {k} | {', '.join(other) or '—'} | {s['desc']} |")
        lines.append("")
    return "\n".join(lines)


def scan(include_private: bool) -> tuple[list[dict], list[dict]]:
    tok = token()
    repos = list_repos(tok, include_private)
    skills = []
    for r in repos:
        branch = r["default_branch"]
        data = api(f"repos/{ORG}/{r['name']}/git/trees/{branch}?recursive=1", tok)
        if data.get("truncated"):
            raise RuntimeError(f"{r['name']}: tree listing truncated")
        for s in find_skills(data["tree"]):
            blob = api(f"repos/{ORG}/{r['name']}/git/blobs/{s['skill_sha']}", tok)
            text = base64.b64decode(blob["content"]).decode("utf-8", "replace")
            skills.append({**s, "repo": r["name"], "branch": branch, "kind": kind(r["name"], s["folder"]),
                           "name": s["folder"].rsplit("/", 1)[-1] or r["name"], "desc": description(text)})
    return skills, repos


def self_check() -> int:
    assert kind("agent-skills", "skills/domain/api/x") == "Domain"
    assert kind("roundtable", ".claude/skills/x") == "wired"
    assert kind("cronsole", "skills/x") == "portable"
    assert kind("cronsole", "backend/src/tools/x") == "bundled"
    md = '---\nname: x\ndescription: >-\n  Use when testing a longer thing — not other things. More.\nlicense: MIT\n---\nbody'
    assert description(md) == "Use when testing a longer thing", description(md)
    assert description("---\nname: x\ndescription: Short one. Second sentence.\n---\n") == "Short one."
    tree = [
        {"path": ".claude/skills/a", "type": "tree", "sha": "T1"},
        {"path": ".claude/skills/a/SKILL.md", "type": "blob", "sha": "B1"},
        {"path": ".agents/skills/a", "type": "tree", "sha": "T1"},
        {"path": ".agents/skills/a/SKILL.md", "type": "blob", "sha": "B1"},
        {"path": ".agents/skills/a/.installed-from-agent-skills", "type": "blob", "sha": "M1"},
        {"path": "demo/.claude/skills/b/SKILL.md", "type": "blob", "sha": "B2"},
        {"path": "site/library/3_Skills/c/SKILL.md", "type": "blob", "sha": "B3"},
        {"path": "skills/d", "type": "tree", "sha": "T4"},
        {"path": "skills/d/SKILL.md", "type": "blob", "sha": "B4"},
    ]
    found = {s["folder"]: s for s in find_skills(tree)}
    assert set(found) == {".claude/skills/a", "skills/d"}, found
    assert found[".claude/skills/a"]["mirrored"] and found[".claude/skills/a"]["mirror_same"]
    rows = [{"name": "a", "repo": "r1", "sha": "T1"}, {"name": "a", "repo": "r2", "sha": "T9"},
            {"name": "d", "repo": "r1", "sha": "T4"}, {"name": "d", "repo": "r1", "sha": "T5"}]
    dup = copies(rows)
    assert set(dup) == {"a"} and drifted(dup["a"])  # same name twice in one repo isn't a cross-repo copy
    assert not drifted([{"name": "humanizer", "repo": "r1", "sha": "T1"}, {"name": "humanizer", "repo": "r2", "sha": "T2"}])  # vendored
    print("self-check ok")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--out", type=Path, default=REPO / "docs" / "CATALOG.md")
    ap.add_argument("--include-private", action="store_true", help="also scan private repos (never write the result into this repo)")
    ap.add_argument("--check", action="store_true", help="exit 1 when a copy has drifted")
    ap.add_argument("--self-check", action="store_true")
    a = ap.parse_args()
    if a.self_check:
        return self_check()
    out = a.out.resolve()
    if a.include_private and out.is_relative_to(REPO):
        ap.error("--include-private output must live outside this public repo")
    skills, repos = scan(a.include_private)
    out.write_text(render(skills, repos, a.include_private, datetime.date.today().isoformat()) + "\n",
                   encoding="utf-8", newline="\n")
    bad = sorted(n for n, g in copies(skills).items() if drifted(g))
    print(f"{len(skills)} skill folders in {len({s['repo'] for s in skills})} of {len(repos)} repos -> {out}")
    for n in bad:
        print("DRIFT " + n + ": " + ", ".join(f"{s['repo']}:{s['folder']}" for s in copies(skills)[n]))
    return 1 if a.check and bad else 0


if __name__ == "__main__":
    sys.exit(main())
