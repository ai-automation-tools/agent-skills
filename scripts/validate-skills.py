#!/usr/bin/env python3
"""Validate every SKILL.md under Skills/ against the rules in CLAUDE.md.

Standard library only, so it runs the same on Windows and in CI:

    python scripts/validate-skills.py

Checks, for every leaf skill (a folder that directly holds a SKILL.md):
  - the YAML frontmatter parses (hand-parsed: it's a small, known shape)
  - `name` is kebab-case, equals its leaf folder, and is unique across all tiers
  - `description` exists and is 40-1,024 characters long
  - every skill-relative path the body names (scripts/..., references/...,
    prompts/..., evals/...) exists inside the skill
  - the skill has a table row in README.md and in its tier's README
And once for the repo:
  - every folder under Resources/Skill-Data/ mirrors a real Skills/ path

Prints every failure, then exits 1 if there were any, 0 otherwise.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "Skills"
SKILL_DATA = ROOT / "Resources" / "Skill-Data"
TIERS = ("Core", "Domain", "Projects")

KEBAB = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
TOP_KEY = re.compile(r"^([A-Za-z_][\w-]*):\s*(.*)$")
# A skill-relative file path: not glued to a preceding path segment (so
# `site/scripts/x.ts` is someone else's file), and ending in a file extension.
BODY_PATH = re.compile(
    r"(?<![\w./-])((scripts|references|prompts|evals)/[\w./-]*\.[A-Za-z0-9]+)"
)
# The target repo's own scripts/ and evals/ are fair game for a project skill to
# name, so those two are only checked when the skill ships that folder itself.
# references/ and prompts/ are always skill-local by convention.
ALWAYS_LOCAL = ("references", "prompts")


def parse_frontmatter(text):
    """Return (fields, body) or raise ValueError. Handles `key: value`,
    quoted values, and `>`/`>-`/`|`/`|-` block scalars."""
    lines = text.lstrip("﻿").splitlines()
    if not lines or lines[0].strip() != "---":
        raise ValueError("file does not start with a '---' frontmatter fence")
    try:
        end = next(i for i in range(1, len(lines)) if lines[i].strip() == "---")
    except StopIteration:
        raise ValueError("frontmatter has no closing '---' fence")

    fields, i = {}, 1
    while i < end:
        line = lines[i]
        if not line.strip() or line.lstrip().startswith("#"):
            i += 1
            continue
        m = TOP_KEY.match(line)
        if not m:
            raise ValueError(f"frontmatter line {i + 1} is not 'key: value': {line.strip()!r}")
        key, value = m.group(1), m.group(2).strip()
        if key in fields:
            raise ValueError(f"frontmatter key {key!r} appears twice")
        i += 1
        if value in (">", ">-", "|", "|-"):
            block = []
            while i < end and (not lines[i].strip() or lines[i][:1] in " \t"):
                block.append(lines[i].strip())
                i += 1
            if value.startswith(">"):
                value = " ".join(b for b in block if b)
            else:
                value = "\n".join(block).strip("\n")
        elif value[:1] in "\"'":
            if len(value) < 2 or value[-1] != value[0]:
                raise ValueError(f"frontmatter key {key!r} has an unterminated quoted value")
            value = value[1:-1]
        fields[key] = value
    return fields, "\n".join(lines[end + 1:])


def table_rows(path):
    if not path.is_file():
        return None
    return [l for l in path.read_text(encoding="utf-8").splitlines() if l.lstrip().startswith("|")]


def mentions(rows, token):
    pat = re.compile(r"(?<![\w-])" + re.escape(token) + r"(?![\w-])")
    return any(pat.search(r) for r in rows)


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    failures = []
    fail = lambda where, msg: failures.append(f"{where}: {msg}")

    readme_rows = table_rows(ROOT / "README.md") or []
    seen = {}
    leaves = sorted(p.parent for p in SKILLS.rglob("SKILL.md"))

    for leaf in leaves:
        rel = leaf.relative_to(ROOT).as_posix()
        parts = leaf.relative_to(SKILLS).parts
        if len(parts) != 3 or parts[0] not in TIERS:
            fail(rel, "expected Skills/<Core|Domain|Projects>/<group>/<skill-name>/SKILL.md")
            continue
        tier, group, folder = parts

        try:
            fields, body = parse_frontmatter((leaf / "SKILL.md").read_text(encoding="utf-8"))
        except (ValueError, UnicodeDecodeError) as e:
            fail(rel, f"frontmatter does not parse: {e}")
            continue

        name = fields.get("name", "")
        if not name:
            fail(rel, "frontmatter has no `name`")
        else:
            if not KEBAB.match(name):
                fail(rel, f"name {name!r} is not kebab-case")
            if name != folder:
                fail(rel, f"name {name!r} does not match its folder {folder!r}")
            if name in seen:
                fail(rel, f"name {name!r} is already used by {seen[name]}")
            else:
                seen[name] = rel

        desc = fields.get("description", "")
        if not desc:
            fail(rel, "frontmatter has no `description`")
        elif not 40 <= len(desc) <= 1024:
            fail(rel, f"description is {len(desc)} characters; it must be 40-1,024")

        for m in sorted(set(BODY_PATH.findall(body))):
            path, top = m
            if top not in ALWAYS_LOCAL and not (leaf / top).is_dir():
                continue
            if not (leaf / path).exists():
                fail(rel, f"body names {path} but it does not exist in the skill")

        token = name or folder
        if tier == "Domain":
            # The root README lists Domain skills by domain folder, not by name.
            if not mentions(readme_rows, f"Skills/Domain/{group}"):
                fail(rel, f"README.md has no row for the Domain folder {group!r}")
        elif not mentions(readme_rows, token):
            fail(rel, f"README.md has no table row naming {token!r}")

        tier_readme = SKILLS / tier / ("README.md" if tier != "Projects" else f"{group}/README.md")
        rows = table_rows(tier_readme)
        tier_rel = tier_readme.relative_to(ROOT).as_posix()
        if rows is None:
            fail(rel, f"tier README {tier_rel} is missing")
        elif not mentions(rows, token):
            fail(rel, f"{tier_rel} has no table row naming {token!r}")

    # Resources/Skill-Data/<Tier>/<group>/<skill>/ must mirror Skills/ exactly;
    # anything deeper is the skill's own supporting data.
    if SKILL_DATA.is_dir():
        for d in sorted(p for p in SKILL_DATA.rglob("*") if p.is_dir()):
            parts = d.relative_to(SKILL_DATA).parts
            if len(parts) > 3:
                continue
            if not (SKILLS.joinpath(*parts)).is_dir() or (len(parts) == 3 and not (SKILLS.joinpath(*parts) / "SKILL.md").is_file()):
                fail(d.relative_to(ROOT).as_posix(), f"does not mirror a real path under Skills/ (no Skills/{'/'.join(parts)})")

    for f in failures:
        print(f"FAIL  {f}")
    print(f"\n{len(leaves)} skills checked, {len(failures)} failure(s).")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
