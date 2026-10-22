# Resources

Supporting material for the skills in this repo that should **not** ship inside the portable skill folders. Keeping it here lets each `skills/<category>/<skill-name>/` folder stay lean and copyable while example runs, screenshots, and reference material live separately.

## Contents

| Folder | What it holds |
|:---|:---|
| [`skill-data/`](./skill-data) | Per-skill examples, sample outputs, and image assets. **Mirrors the `skills/` tree** — `skill-data/<category>/<skill-name>/`. |
| [`links/`](./links) | Curated external references for building Agent Skills (specs, docs, inspiration). |

## Skill-Data convention

For a skill at `skills/<category>/<skill-name>/`, its supporting data lives at the matching path `resources/skill-data/<category>/<skill-name>/`. Each such folder carries a `README.md` that doubles as the skill's **overview page**: the Core skill tables in the root README link straight to it, so it opens with what the skill does, any diagram or screenshot, and a link to the skill's `SKILL.md`.

Put here: example/expected outputs, before/after screenshots, sample reports, demo GIFs, and design notes — anything that documents or demonstrates a skill but that the skill itself doesn't need loaded at runtime.

Do **not** put here: files the skill reads when it runs (those belong in the skill's own `references/`, `scripts/`, or `prompts/`), or local run output (that belongs in the skill's gitignored `reports/`).
