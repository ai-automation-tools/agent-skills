#!/usr/bin/env python3
"""Check every relative link in the READMEs, Docs/ and the showcase page.

Standard library only, so it runs the same on Windows and in CI:

    python scripts/check-links.py

Scans every README.md in the repo, every Markdown file in Docs/, and
site/index.html. For each link it checks that the target file or folder exists:
  - Markdown links and images: [text](path), ![alt](path)
  - HTML attributes: href="path", src="path"
  - links back into this repo on GitHub
    (https://github.com/ai-automation-tools/agent-skills/blob|tree/main/<path>),
    which is how the showcase cards point at each SKILL.md
Other web links, mailto:, data: and #anchor-only links are skipped, and so is
anything inside a code fence or inline code. The #fragment of a file link is
dropped, so only the file is checked.

Paths are matched case-sensitively, as git and Linux CI see them, even on
Windows, so `docs/` fails where the folder is `Docs/`.

Prints every broken link, then exits 1 if there were any, 0 otherwise.
"""
import os
import re
import sys
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
SKIP_DIRS = {".git", ".claude", "node_modules", "reports"}
REPO_URL = re.compile(
    r"^https://github\.com/ai-automation-tools/agent-skills/(?:blob|tree)/main/(.*)$"
)
MD_LINK = re.compile(r"!?\[[^\]]*\]\(\s*<?([^)\s>]+)>?(?:\s+\"[^\"]*\")?\s*\)")
HTML_ATTR = re.compile(r"""\b(?:href|src)\s*=\s*["']([^"']+)["']""")
FENCE = re.compile(r"^\s*(```|~~~)")
INLINE_CODE = re.compile(r"`[^`]*`")


def files_to_check():
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for f in filenames:
            if f == "README.md":
                yield Path(dirpath) / f
    yield from sorted((ROOT / "Docs").glob("*.md"))
    yield ROOT / "site" / "index.html"


def exists_exact(path):
    """Path exists with this exact case in every component below ROOT."""
    # normpath, not resolve(): on Windows resolve() rewrites the case to match
    # the disk, which would hide exactly the mismatch this is looking for.
    try:
        rel = Path(os.path.normpath(path)).relative_to(ROOT)
    except ValueError:
        return False  # points outside the repo
    cur = ROOT
    for part in rel.parts:
        if not cur.is_dir() or part not in os.listdir(cur):
            return False
        cur = cur / part
    return True


def links(text, is_md):
    in_fence = False
    for n, line in enumerate(text.splitlines(), 1):
        if is_md and FENCE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        if is_md:
            line = INLINE_CODE.sub("", line)
        for rx in (MD_LINK, HTML_ATTR) if is_md else (HTML_ATTR,):
            for m in rx.finditer(line):
                yield n, m.group(1)


def resolve(source, target):
    """Return the local Path a link points at, or None to skip it."""
    m = REPO_URL.match(target)
    if m:
        base, target = ROOT, m.group(1)
    elif re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:|^//|^#", target):
        return None  # web link, mailto:, data:, or an in-page anchor
    else:
        base = source.parent
    target = unquote(target.split("#", 1)[0].split("?", 1)[0])
    if not target:
        return None
    return ROOT / target.lstrip("/") if target.startswith("/") else base / target


def main():
    failures, checked = [], 0
    for source in files_to_check():
        text = source.read_text(encoding="utf-8")
        for n, target in links(text, source.suffix == ".md"):
            path = resolve(source, target)
            if path is None:
                continue
            checked += 1
            if not exists_exact(path):
                rel = source.relative_to(ROOT).as_posix()
                failures.append(f"{rel}:{n}: broken link -> {target}")
    for f in failures:
        print(f)
    print(f"{checked} links checked, {len(failures)} broken.")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
