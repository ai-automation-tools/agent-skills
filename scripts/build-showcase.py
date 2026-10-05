#!/usr/bin/env python3
"""Rebuild the generated parts of site/index.html from the Skills/ tree.

The tree decides WHICH skills, categories, groups and counts the showcase shows. The
hand-written words (taglines, feature bullets, glyphs, screenshot alt text) live in
site/showcase.json, keyed by skill name. A Core skill with no entry there still gets a card,
built from its SKILL.md frontmatter, so the page can never silently miss a skill.

Everything generated sits between marker comments in index.html:

    <!-- gen:KEY -->...<!-- /gen:KEY -->

Block keys (cards, chips, domains, projects) hold whole lines; inline keys hold one value,
such as a count. Anything outside the markers is hand-edited as before.

    python scripts/build-showcase.py           # rewrite site/index.html
    python scripts/build-showcase.py --check   # exit 1 if it is out of date (CI runs this)

Stdlib only, like validate-skills.py.
"""
from __future__ import annotations

import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "Skills"
INDEX = ROOT / "site" / "index.html"
SHOWCASE = ROOT / "site" / "showcase.json"
REPO_URL = "https://github.com/ai-automation-tools/agent-skills"

WORDS = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
         "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
         "eighteen", "nineteen", "twenty"]
MARKER = re.compile(r"(<!-- gen:([\w-]+) -->)(.*?)(<!-- /gen:\2 -->)", re.S)


def frontmatter(path: Path) -> dict[str, str]:
    """`name` and `description` from a SKILL.md, including folded (`>-`) block scalars."""
    lines = path.read_text(encoding="utf-8").replace("\r\n", "\n").split("\n")
    if not lines or lines[0].strip() != "---":
        return {}
    end = next(i for i in range(1, len(lines)) if lines[i].strip() == "---")
    fields: dict[str, str] = {}
    i = 1
    while i < end:
        m = re.match(r"^([A-Za-z_][\w-]*):\s*(.*)$", lines[i])
        i += 1
        if not m:
            continue
        key, value = m.group(1), m.group(2).strip()
        if value in (">", ">-", "|", "|-"):
            block = []
            while i < end and (lines[i].startswith((" ", "\t")) or not lines[i].strip()):
                block.append(lines[i].strip())
                i += 1
            value = " ".join(b for b in block if b)
        elif len(value) >= 2 and value[0] == value[-1] and value[0] in "'\"":
            value = value[1:-1]
        fields[key] = value
    return fields


def tree(tier: str) -> dict[str, list[tuple[str, dict[str, str]]]]:
    """{group folder: [(skill folder, frontmatter), ...]} for one tier, both levels sorted."""
    out: dict[str, list[tuple[str, dict[str, str]]]] = {}
    for skill_md in sorted((SKILLS / tier).glob("*/*/SKILL.md")):
        group, skill = skill_md.parent.parent.name, skill_md.parent.name
        out.setdefault(group, []).append((skill, frontmatter(skill_md)))
    return out


def first_sentence(text: str) -> str:
    m = re.match(r"(.+?[.!?])(\s|$)", text)
    return (m.group(1) if m else text).strip()


def word(n: int) -> str:
    return WORDS[n] if n < len(WORDS) else str(n)


def card(idx: int, category: str, skill: str, fm: dict[str, str], copy: dict) -> str:
    glyph = copy.get("glyph", "✦")
    alt = copy.get("alt") or html.escape(f"{skill} screenshot", quote=True)
    tagline = copy.get("tagline") or html.escape(first_sentence(fm.get("description", "")))
    feats = copy.get("features", [])
    n = f"{idx:02d}"
    lines = [
        f"        <!-- {n} -->",
        f'        <article class="card reveal" data-category="{category.lower()}" data-skill="{skill}">',
        '          <div class="card-media">',
        f'            <img class="shot" data-name="{skill}" alt="{alt}" loading="lazy" decoding="async">',
        '            <div class="shot-fallback" aria-hidden="true">',
        f'              <span class="glyph">{glyph}</span>',
        f"              <b>{skill}.png</b>",
        "              <small>drop a screenshot into site/assets/img/</small>",
        "            </div>",
        f'            <span class="idx">{n}</span>',
        "          </div>",
        '          <div class="card-body">',
        f'            <span class="cat" data-cat="{category.lower()}"><i aria-hidden="true"></i>{category}</span>',
        f'            <h3 class="card-title"><span class="glyph" aria-hidden="true">{glyph}</span><code>{skill}</code></h3>',
        f'            <p class="tagline">{tagline}</p>',
    ]
    if feats:
        lines.append('            <ul class="feat">')
        lines += [f"              <li>{f}</li>" for f in feats]
        lines.append("            </ul>")
    lines += [
        '            <div class="card-foot">',
        f'              <button class="cmd" data-copy="pwsh scripts/install-skills.ps1 -Core -Skill {skill}" title="Copy install command">',
        f'                <span class="cmd-text">-Skill {skill}</span>',
        '                <span class="cmd-icon" aria-hidden="true">copy</span>',
        "              </button>",
        f'              <a class="link" href="{REPO_URL}/blob/main/Skills/Core/{category}/{skill}/SKILL.md" target="_blank" rel="noopener">SKILL.md <span aria-hidden="true">↗</span></a>',
        "            </div>",
        "          </div>",
        "        </article>",
    ]
    return "\n".join(lines)


def group_list(tier: str, groups: dict, meta: list[dict]) -> str:
    glyphs = {g["name"]: g.get("glyph", "📁") for g in meta}
    order = [g["name"] for g in meta if g["name"] in groups] + sorted(g for g in groups if g not in glyphs)
    items = []
    for g in order:
        skills = "".join(f"<code>{s}</code>" for s, _ in groups[g])
        items.append("\n".join([
            "        <li>",
            f'          <a class="proj" href="{REPO_URL}/tree/main/Skills/{tier}/{g}" target="_blank" rel="noopener">',
            f'            <span class="proj-glyph" aria-hidden="true">{glyphs.get(g, "📁")}</span>',
            '            <span class="proj-main">',
            f'              <span class="proj-name">{g}</span>',
            f'              <span class="proj-skills">{skills}</span>',
            "            </span>",
            '            <span class="proj-go" aria-hidden="true">↗</span>',
            "          </a>",
            "        </li>",
        ]))
    return "\n".join(items)


def build() -> tuple[dict[str, str], list[str]]:
    """The generated value for every marker key, plus any problems worth failing on."""
    data = json.loads(SHOWCASE.read_text(encoding="utf-8"))
    core = tree("Core")
    copy = {c["name"]: c for c in data.get("core", [])}
    by_skill = {s: (cat, fm) for cat, skills in core.items() for s, fm in skills}

    problems = [f"showcase.json has copy for '{n}', which is not a Core skill" for n in copy if n not in by_skill]
    order = [n for n in copy if n in by_skill] + sorted(s for s in by_skill if s not in copy)
    cards = [card(i, by_skill[s][0], s, by_skill[s][1], copy.get(s, {})) for i, s in enumerate(order, 1)]

    total = len(by_skill)
    chips = [f'        <button class="chip is-active" data-filter="all">All <span>{total}</span></button>']
    chips += [f'        <button class="chip" data-filter="{c.lower()}">{c} <span>{len(core[c])}</span></button>' for c in sorted(core)]

    return {
        "cards": "\n\n".join(cards),
        "chips": "\n".join(chips),
        "domains": group_list("Domain", tree("Domain"), data.get("domains", [])),
        "projects": group_list("Projects", tree("Projects"), data.get("projects", [])),
        "core-count": f"{total:02d}",
        "core-count-word": word(total),
        "core-count-Word": word(total).capitalize(),
        "category-count": f"{len(core):02d}",
        "category-count-word": word(len(core)),
    }, problems


def render(page: str, values: dict[str, str]) -> tuple[str, list[str]]:
    unknown: list[str] = []

    def sub(m: re.Match) -> str:
        key = m.group(2)
        if key not in values:
            unknown.append(key)
            return m.group(0)
        value = values[key]
        if "\n" in value or m.group(3).startswith("\n"):  # block region: keep the marker's indent
            line_start = page.rfind("\n", 0, m.start()) + 1
            indent = page[line_start:m.start()]
            value = "\n" + value + "\n" + indent
        return m.group(1) + value + m.group(4)

    return MARKER.sub(sub, page), unknown


def main() -> int:
    check = "--check" in sys.argv[1:]
    raw = INDEX.read_bytes().decode("utf-8")
    crlf = "\r\n" in raw
    page = raw.replace("\r\n", "\n")
    values, problems = build()
    new, unknown = render(page, values)
    problems += [f"index.html has a marker for unknown key '{k}'" for k in unknown]
    problems += [f"index.html is missing the marker '{k}'" for k in values if f"<!-- gen:{k} -->" not in page]
    for p in problems:
        print(f"ERROR: {p}")
    if check:
        if new != page:
            print("site/index.html is out of date with the Skills/ tree or site/showcase.json.")
            print("Run `python scripts/build-showcase.py` and commit the result.")
            return 1
        if problems:
            return 1
        print(f"site/index.html is current ({values['core-count']} Core skills, {values['category-count']} categories).")
        return 0
    if new != page:
        INDEX.write_bytes((new.replace("\n", "\r\n") if crlf else new).encode("utf-8"))
        print("site/index.html updated.")
    else:
        print("site/index.html already current.")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
