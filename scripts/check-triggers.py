"""Check that each Core skill's description makes Claude Code load it unprompted.

Runs every request in scripts/trigger-cases.json through a fresh headless session
(`claude -p`) from an empty temp folder, so no repo context helps, and records which
skills the session loaded through its Skill tool. A "load" case passes when the
expected skill loads; a "skip" case passes when it doesn't.

It tests the INSTALLED copies (~/.claude/skills), so run `install-skills.ps1` first if
you changed a description. Not in CI: it needs a signed-in `claude` and spends tokens.

    python scripts/check-triggers.py                      # every case
    python scripts/check-triggers.py --skill news-images  # one skill
    python scripts/check-triggers.py --model sonnet --workers 4
"""
import argparse
import json
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

CASES = Path(__file__).with_name("trigger-cases.json")
# Read-only: the session may load skills and read, but never change anything.
DENY = "Bash,PowerShell,Edit,Write,NotebookEdit,Agent,Workflow,WebFetch,WebSearch"


def loaded_skills(stream: str) -> set[str]:
    """Skill names the session invoked, from `--output-format stream-json` lines."""
    found = set()
    for line in stream.splitlines():
        try:
            ev = json.loads(line)
        except ValueError:
            continue
        if ev.get("type") != "assistant":
            continue
        for part in ev.get("message", {}).get("content", []):
            if part.get("type") == "tool_use" and part.get("name") == "Skill":
                name = str(part.get("input", {}).get("skill", ""))
                found.add(name.split(":")[-1].lstrip("/"))  # "plugin:skill" or "/skill"
    return found


def run(prompt: str, model: str | None, cwd: str) -> set[str]:
    cmd = ["claude", "-p", "--output-format", "stream-json", "--verbose",
           "--max-turns", "3", f"--disallowedTools={DENY}"]
    if model:
        cmd += ["--model", model]
    out = subprocess.run(cmd, input=prompt, capture_output=True, text=True,
                         encoding="utf-8", errors="replace", cwd=cwd, timeout=300)
    return loaded_skills(out.stdout)


def self_check() -> None:
    sample = "\n".join([
        json.dumps({"type": "assistant", "message": {"content": [
            {"type": "tool_use", "name": "Skill", "input": {"skill": "news-images"}}]}}),
        json.dumps({"type": "assistant", "message": {"content": [
            {"type": "tool_use", "name": "Skill", "input": {"skill": "anthropic-skills:pdf"}}]}}),
        json.dumps({"type": "assistant", "message": {"content": [
            {"type": "tool_use", "name": "Read", "input": {"file_path": "x"}}]}}),
        "not json",
    ])
    assert loaded_skills(sample) == {"news-images", "pdf"}, loaded_skills(sample)
    print("self-check passed")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--skill", help="only this skill's cases")
    ap.add_argument("--model", help="model alias for the sessions (default: your CLI default)")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--self-check", action="store_true")
    args = ap.parse_args()
    if args.self_check:
        self_check()
        return 0

    data = json.loads(CASES.read_text(encoding="utf-8"))["cases"]
    jobs = [(skill, kind, prompt)
            for skill, sets in data.items() if not args.skill or skill == args.skill
            for kind in ("load", "skip") for prompt in sets.get(kind, [])]
    if not jobs:
        print(f"no cases for {args.skill!r}")
        return 1

    # ignore_cleanup_errors: on Windows a session's MCP children can outlive it and hold the folder.
    with tempfile.TemporaryDirectory(ignore_cleanup_errors=True) as cwd, ThreadPoolExecutor(args.workers) as pool:
        results = list(pool.map(lambda j: (j, run(j[2], args.model, cwd)), jobs))

    failures = 0
    for (skill, kind, prompt), got in results:
        ok = (skill in got) == (kind == "load")
        failures += not ok
        others = ", ".join(sorted(got - {skill})) or "-"
        print(f"{'PASS' if ok else 'FAIL'}  {kind:4}  {skill:24}  also: {others:28}  {prompt[:70]}")
    print(f"\n{len(results)} cases, {failures} failed.")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
