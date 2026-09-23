<a id="roadmap-top"></a>

<h1 align="center">🗺️ Agent Skills Roadmap</h1>

<p align="center">
  <em>What the skill library needs next: checks that catch a broken skill before anyone installs it, a showcase that stays true to the skills, and the skills still sitting in the backlog.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/started-2026--09--22-0078D4?style=for-the-badge" alt="Started 2026-09-22">
  <img src="https://img.shields.io/badge/worked-weekly-8B5CF6?style=for-the-badge" alt="Worked weekly">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Agent_Skills-6B7280?style=for-the-badge" alt="Back to Agent Skills"></a>
</p>

---

A weekly roadmap routine works this list. Each Thursday night it takes the first unchecked
item it can finish and verify, then opens a pull request, and the Sunday PR sweep merges
it. A person can take any item too. Tick the box and add the changelog line in the same
commit.

How items are marked: `- [ ]` open · `- [-]` claimed by a run in progress · `- [x]` done,
with a dated note · `- [!]` blocked, with the reason. `🔒 Needs Mike` means only a person
can do it. Phases are worked top to bottom, and items within a phase in order.

The rules every item follows are in [`CLAUDE.md`](../CLAUDE.md): the two tiers, the
standing sync instructions, and what makes a skill portable.

## Phase 1: catch a broken skill before it ships

There's no test runner and no CI beyond the Pages deploy. So a renamed skill, a
`name:` that no longer matches its folder, or a `references/` path that moved only shows
up once someone installs the skill and it fails.

- [x] **Start `Docs/CHANGELOG.md`.** Newest first, seeded from the git log at the grain
  that's honest (one line per merged PR). Link it from the README's Docs table next to
  this file. *(done 2026-09-22: seeded per PR since #1, per change before that; linked
  from the README nav and "Using a skill" line, since the README has no Docs table)*
- [ ] **Write `scripts/validate-skills.py`, with no third-party dependencies.** For every
  `SKILL.md` it checks that:
  - the frontmatter parses
  - `name` is kebab-case, equals its leaf folder, and is unique across both tiers
  - `description` exists and is 40–1,024 characters long
  - every relative path the body mentions (`scripts/…`, `references/…`, `prompts/…`)
    exists
  - the skill has a row in `README.md` and in its tier's README
  - any `Resources/Skill-Data/` folder mirrors a real skill path

  It exits non-zero on the first class of failure and prints every failure, not just the
  first.
- [ ] **Run the validator in CI.** A `validate.yml` workflow on push and pull request, with
  `permissions: contents: read`.
- [ ] **Link check.** Check every relative link in the READMEs, `Docs/`, and the showcase
  cards, so a renamed skill fails loudly instead of 404ing quietly. Add it to the same
  workflow.
- [ ] **Installer smoke test.** Run `install-skills.ps1` into a temporary directory under
  `pwsh` in CI, then assert the flat layout (`<dir>/<name>/SKILL.md`) and that an
  induced name collision throws.
- [ ] **Tests for the deterministic scripts.** Cover the helpers under
  `recipe-validator/scripts/`, `project-hub-scaffold/scripts/`, and
  `cronsole-windows-jobs/scripts/`, using fixture inputs and standard-library runners
  only.
- [ ] **Drift check for the one known duplicate.** A script that compares
  `project-hub-scaffold` here with its copy in the public `ai-automation-tools/project-hub`
  repo and reports any difference. Run it from CI on a weekly schedule. This repo is
  canonical, so the check reports and never edits.

## Phase 2: a showcase that stays true

These items come from the action list in [`site/README.md`](../site/README.md). The org
landing page now sends traffic to the site.

- [ ] **Generate the cards from frontmatter.** A small script builds the card blocks in
  `site/index.html` from each Core skill's `name` and `description`, between marker
  comments, so the copy can't drift from `SKILL.md`. Run it in CI and fail if the output
  differs from what's committed.
- [ ] **`og:image` + `twitter:card`.** A 1200×630 crop of the hero, so a shared link
  previews properly (org roadmap P2-8).
- [ ] **Compress the remaining PNGs.** The seeded `repo-docs-builder` images run up to
  274 KB, so convert them to WebP like the rest.
- [ ] **Filter chips announce their state** with `aria-pressed`.
- [ ] **Lightbox focus.** Trap focus while the lightbox is open, and hand it back to the
  card that opened it.
- [ ] **Screenshot `alt` text** that describes the image, not the skill's name.
- [ ] **Raise `--text-faint` to at least 4.5:1** against the card background. It measures
  about 4:1 today.
- [ ] **No-JS fallback** for the hero panel, so it isn't blank when the script fails.
- [ ] **Homepage on the About panel.** Run
  `gh repo edit ai-automation-tools/agent-skills --homepage https://agent-skills.ai-automation-tools.dev`.
- [ ] 🔒 Needs Mike · Decide whether the four seeded `repo-docs-builder` images stay.
- [ ] 🔒 Needs Mike · Check the layout on a real phone.

## Phase 3: skills from the backlog

Pulled from [`SKILL-IDEAS.md`](SKILL-IDEAS.md). Each one ships with:
- its `SKILL.md` and an `evals/` folder of at least three cases
- a README row and a tier-README row
- a showcase card, if it's Core
- its idea row struck from the backlog

It's one skill per run. Each should be portable Core unless it names a single repo.

- [ ] **commit-msg-writer**: writes imperative commit messages that match a repo's
  existing log style (Conventional or plain), reading `git log` before it writes.
- [ ] **changelog-keeper**: maintains a `CHANGELOG.md` from a commit range, and ticks
  matching roadmap items. It must agree with `repo-docs-builder` §2.5 and not contradict
  it.
- [ ] **pr-describer**: a structured PR body (summary, changes, test plan, what to review
  first) built from a diff.
- [ ] **env-doctor**: finds env vars the code reads that are missing from `.env.example`,
  and example entries nothing reads.
- [ ] **api-reference-writer**: endpoint reference docs from route definitions, using one
  consistent response envelope.
- [ ] **Retire the `repo-doc-structure` idea.** `repo-docs-builder` already covers it, so
  strike the row with a note saying so.
- [ ] 🔒 Needs Mike · **obsidian-note-author**: decide whether it's portable Core or too
  tied to one vault to publish.

## Phase 4: make every skill measurable

Only `recipe-validator` has evals today.

- [ ] **Evals for `task-router`.** Include requests that should route inline, to one
  agent, and to a fan-out, with the expected tier for each.
- [ ] **Evals for `html-email-templates`.**
- [ ] **Evals for `repo-docs-builder`.**
- [ ] **Evals for `business-plan-builder`.** Cover at least one idea that should come back
  NO_GO.
- [ ] **Evals for `project-hub-scaffold` and `news-images`.**
- [ ] **Audit description triggers.** For each Core skill, write two requests that should
  auto-load it and one that shouldn't. Tighten any description that fails, and record the
  method in `USING-SKILLS.md`.
- [ ] **Cross-agent install table in `USING-SKILLS.md`.** The directory each CLI that
  `-AllAgents` targets reads from, and what differs between them.

## Needs a decision

- [ ] 🔒 Needs Mike · **License.** The repo is public with no license, which by default
  means nobody may reuse it. The org docs record this as deliberate (org roadmap P2-10).
  Revisit it before any promotion.

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="CHANGELOG.md">Changelog</a> ·
  <a href="USING-SKILLS.md">Using skills</a> ·
  <a href="SKILL-IDEAS.md">Skill ideas</a> ·
  <a href="#roadmap-top">↑ Back to top</a>
</p>
