<a id="roadmap-top"></a>

<h1 align="center">🗺️ Roadmap</h1>

<p align="center">
  <em>What the skill library needs next: checks that catch a broken skill before anyone installs it, a showcase that stays true to the skills, and the skills still sitting in the backlog.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/now-after_public_release-F59E0B?style=for-the-badge" alt="Now: after public release">
  <img src="https://img.shields.io/badge/stage-public,_site_live_since_2026--09--16-2ea44f?style=for-the-badge" alt="Stage: public, site live since 2026-09-16">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Agent_Skills-6B7280?style=for-the-badge" alt="Back to Agent Skills"></a>
</p>

---

The Agent-Skills Weekly Roadmap routine (`agent-skills-roadmap`, Thursday 21:00) works this
file top to bottom: it takes the first open item that isn't `🔒 Needs Mike` and that it can
finish and verify, opens a `roadmap/auto-<date>` pull request, and the Sunday PR sweep merges
it. A person can take any item too. **Every item above `## After public release` is a
release gate.** The repo and its showcase are already public, so the open gates are catch-up
work, taken first. Ticking an item adds its line to the [changelog](CHANGELOG.md), tagged with
the phase in italics, and updates any doc it made stale, in the same commit.

Markers: `- [ ]` open, `- [-]` claimed by a run in progress, `- [x]` done, `- [!]` blocked
(the reason follows on the line). `small` marks an item a check verifies; `🔒 Needs Mike`
marks one only Mike can do.

The rules every item follows are in [`AGENTS.md`](../AGENTS.md): the two tiers, the
standing sync instructions, and what makes a skill portable.

## 🚦 Public release

- [x] CI green on push and PR: `validate.yml` runs the skill validator, then the link check, the showcase `--check` and the installer smoke test as they landed — done 2026-10-01: `validate.yml` on push to `main`, every PR and by hand
- [x] README usage (catalog, install commands, authoring guide) verified against the real `skills/` tree and `scripts/install-skills.ps1` from a clean clone — done 2026-10-22: every table and install command checked against a fresh clone of `main`; fixed the Media source name in `README.md` and the category case and Core authoring steps in `docs/USING-SKILLS.md`
- [x] `SECURITY.md`, and a full-history secret scan that comes back clean — done 2026-10-29: root `SECURITY.md` (private report address, skill-library scope, Domain fix path, scan command); gitleaks 8.30.1 over every commit on every branch found no leaks
- [ ] Licence chosen and `LICENSE` added. The repo is public with no license, which by default means nobody may reuse it. The org docs record this as deliberate (org roadmap P2-10). Revisit it before any promotion 🔒 Needs Mike
- [x] Live at its URL: the showcase at `https://agent-skills.ai-automation-tools.dev`, deployed by `pages.yml` — done 2026-09-16: published the same day the static showcase was added

## After public release

Nothing below blocks go-live.

### 🔨 Phase 1: catch a broken skill before it ships

There's no test runner and no CI beyond the Pages deploy. So a renamed skill, a
`name:` that no longer matches its folder, or a `references/` path that moved only shows
up once someone installs the skill and it fails.

- [x] Start `docs/CHANGELOG.md`. Newest first, seeded from the git log at the grain that's honest (one line per merged PR). Link it from the README's Docs table next to this file — done 2026-09-22: seeded per PR since #1, per change before that; linked from the README nav and "Using a skill" line, since the README has no Docs table
- [x] Write `scripts/validate-skills.py`, with no third-party dependencies. For every `SKILL.md` it checks that the frontmatter parses; `name` is kebab-case, equals its leaf folder, and is unique across both tiers; `description` exists and is 40–1,024 characters long; every relative path the body mentions (`scripts/…`, `references/…`, `prompts/…`) exists; the skill has a row in `README.md` and in its tier's README; any `resources/skill-data/` folder mirrors a real skill path. It exits non-zero on the first class of failure and prints every failure, not just the first — done 2026-09-24: all six checks, run over all three tiers. Its first run caught `repo-docs-builder`'s 1,113-character description and two cronsole skills citing another skill's `references/`; both fixed. `scripts/` and `evals/` paths are checked only when the skill ships that folder, since project skills name their target repo's scripts
- [x] Run the validator in CI. A `validate.yml` workflow on push and pull request, with `permissions: contents: read` — done 2026-10-01: runs on push to `main`, every PR and by hand, on `ubuntu-latest` with stock Python 3. The repo passed a case-sensitive dry run first
- [x] Link check. Check every relative link in the READMEs, `docs/`, and the showcase cards, so a renamed skill fails loudly instead of 404ing quietly. Add it to the same workflow — done 2026-10-08: `scripts/check-links.py`, stdlib-only, in `validate.yml`. Covers every `README.md`, `docs/*.md` and `site/index.html`, including the cards' GitHub links back into this repo, and matches case exactly. Its first run fixed nine broken back-links in Skill-Data and `site/assets/img/` READMEs
- [x] Installer smoke test. Run `install-skills.ps1` into a temporary directory under `pwsh` in CI, then assert the flat layout (`<dir>/<name>/SKILL.md`) and that an induced name collision throws — done 2026-10-15: `scripts/test-install-skills.ps1`, in `validate.yml`. Also checks that a bare run is Core-only, that `-Skill` narrows and that `reports/` never ships. The collision is induced in a scratch copy of `skills/`, so the repo is never touched
- [ ] Tests for the deterministic scripts. Cover the helpers under `recipe-validator/scripts/`, `project-hub-scaffold/scripts/`, and `cronsole-windows-jobs/scripts/`, using fixture inputs and standard-library runners only
- [ ] Drift check for the one known duplicate. A script that compares `project-hub-scaffold` here with its copy in the public `ai-automation-tools/project-hub` repo and reports any difference. Run it from CI on a weekly schedule. This repo is canonical, so the check reports and never edits

### 🪟 Phase 2: a showcase that stays true

These items come from the action list in [`site/README.md`](../site/README.md). The org
landing page now sends traffic to the site.

- [x] Generate the cards from frontmatter. A small script builds the card blocks in `site/index.html` from each Core skill's `name` and `description`, between marker comments, so the copy can't drift from `SKILL.md`. Run it in CI and fail if the output differs from what's committed — done 2026-10-05: `scripts/build-showcase.py`, stdlib-only. The tree decides which skills, categories and counts appear; the hand-written taglines and bullets moved to `site/showcase.json`, because a `description` is trigger text, not card copy. A Core skill with no entry still gets a card from its frontmatter. It also generates the filter chips, the Domain and Project lists and every count in the page. `validate.yml` runs `--check`
- [x] Showcase card for `automated-dev-pipeline`. Core has eight skills since 2026-09-23 but the site shows seven. Add its card (category `automation`, glyph 🏭) with a diagram image in `site/assets/diagrams/` drawn from the loop in its `SKILL.md`, like `task-router`'s, and change "seven" to "eight" in the intro and the install block — done 2026-10-05: copy in `showcase.json`, diagram `site/assets/diagrams/automated-dev-pipeline.html` rendered to `assets/img/automated-dev-pipeline.webp`; the counts are generated now
- [ ] `og:image` + `twitter:card`. A 1200×630 crop of the hero, so a shared link previews properly (org roadmap P2-8)
- [ ] Compress the remaining PNGs. The seeded `repo-docs-builder` images run up to 274 KB, so convert them to WebP like the rest
- [ ] Filter chips announce their state with `aria-pressed`
- [ ] Lightbox focus. Trap focus while the lightbox is open, and hand it back to the card that opened it
- [ ] Screenshot `alt` text that describes the image, not the skill's name
- [ ] Raise `--text-faint` to at least 4.5:1 against the card background. It measures about 4:1 today
- [ ] No-JS fallback for the hero panel, so it isn't blank when the script fails
- [ ] Homepage on the About panel. Run `gh repo edit ai-automation-tools/agent-skills --homepage https://agent-skills.ai-automation-tools.dev`
- [ ] Decide whether the four seeded `repo-docs-builder` images stay 🔒 Needs Mike
- [ ] Check the layout on a real phone 🔒 Needs Mike

### 🧩 Phase 3: skills from the backlog

Pulled from [`SKILL-IDEAS.md`](SKILL-IDEAS.md). Each one ships with its `SKILL.md` and an
`evals/` folder of at least three cases, a README row and a tier-README row, a showcase card
if it's Core, and its idea row struck from the backlog. It's one skill per run. Each should
be portable Core unless it names a single repo.

- [ ] commit-msg-writer: writes imperative commit messages that match a repo's existing log style (Conventional or plain), reading `git log` before it writes
- [ ] changelog-keeper: maintains a `CHANGELOG.md` from a commit range, and ticks matching roadmap items. It must agree with `repo-docs-builder` §2.5 and not contradict it
- [ ] pr-describer: a structured PR body (summary, changes, test plan, what to review first) built from a diff
- [ ] env-doctor: finds env vars the code reads that are missing from `.env.example`, and example entries nothing reads
- [ ] api-reference-writer: endpoint reference docs from route definitions, using one consistent response envelope
- [ ] Retire the `repo-doc-structure` idea. `repo-docs-builder` already covers it, so strike the row with a note saying so
- [ ] obsidian-note-author: decide whether it's portable Core or too tied to one vault to publish 🔒 Needs Mike

### 📏 Phase 4: make every skill measurable

Only `recipe-validator` has evals today.

- [ ] Evals for `task-router`. Include requests that should route inline, to one agent, and to a fan-out, with the expected tier for each
- [ ] Evals for `html-email-templates`
- [ ] Evals for `repo-docs-builder`
- [ ] Evals for `business-plan-builder`. Cover at least one idea that should come back NO_GO
- [ ] Evals for `project-hub-scaffold` and `news-images`
- [ ] Audit description triggers. For each Core skill, write two requests that should auto-load it and one that shouldn't. Tighten any description that fails, and record the method in `USING-SKILLS.md`
- [ ] Cross-agent install table in `USING-SKILLS.md`. The directory each CLI that `-AllAgents` targets reads from, and what differs between them

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="CHANGELOG.md">Changelog →</a> ·
  <a href="USING-SKILLS.md">Using skills</a> ·
  <a href="SKILL-IDEAS.md">Skill ideas</a> ·
  <a href="#roadmap-top">↑ Back to top</a>
</p>
