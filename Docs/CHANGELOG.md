<a id="changelog-top"></a>

<h1 align="center">📜 Agent Skills Changelog</h1>

<p align="center">
  <em>Everything that has changed in the skill library, newest first, including each roadmap item as it's finished.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/started-2026--09--22-0078D4?style=for-the-badge" alt="Started 2026-09-22">
  <a href="ROADMAP.md"><img src="https://img.shields.io/badge/roadmap-what's_next-8B5CF6?style=for-the-badge" alt="Roadmap"></a>
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Agent_Skills-6B7280?style=for-the-badge" alt="Back to Agent Skills"></a>
</p>

---

The repo isn't versioned, so entries sit under date headings. Since pull requests began on
2026-09-11 there's one line per merged PR, plus any commit that landed on `main` directly.
Earlier history was committed straight to `main` and is summarized one line per meaningful
change. Lines that finish a [roadmap](ROADMAP.md) item carry its phase in italics.

Skills named here keep the name they had at the time. The four `-mfs` skills were renamed on
2026-09-11: `repo-builder-mfs` → `repo-docs-builder`, `business-planning-mfs` →
`business-plan-builder`, `email-template-mfs` → `html-email-templates`,
`project-hub-scaffold-mfs` → `project-hub-scaffold`.

## 2026-09-24

**Added**
- `scripts/validate-skills.py`, a standard-library check of every `SKILL.md`: frontmatter,
  kebab-case name that matches its folder and is unique, a 40–1,024 character description,
  the paths the body cites, the README and tier-README rows, and the `Resources/Skill-Data/`
  mirror. It prints every failure and exits non-zero. *(Phase 1)*

**Fixed**
- `repo-docs-builder`'s description was 1,113 characters, over the 1,024 limit. The sentence
  about GitHub/Obsidian rendering came out; the body still says it. Found by the validator.
- `cronsole-windows-jobs` and `cronsole-claude-routines` cited `references/task-authoring.md`,
  which lives in the cronsole repo's own `cronsole` skill, not theirs. Now written
  `cronsole/references/task-authoring.md`.

## 2026-09-23

**Added**
- `automated-dev-pipeline` skill in the Automation category. It sets up scheduled AI agents
  that build projects (ideate, incubate, a weekly roadmap routine per repo, one PR sweep),
  publish them to a GitHub account or organization behind scripted gates plus a human
  approval, and keep every repo current through sourced refresh and upkeep jobs. References
  cover architecture, stage contracts, idea sourcing, keeping repos current, and auditing.
  Written from the live `ai-automation-tools` pipeline. Its machine-specific operator notes
  stay beside that pipeline's code, not in this repo. The showcase card is a Phase 2 roadmap
  item.

**Changed**
- `automated-dev-pipeline` covers what building a second pipeline with it taught: the 3D Lab
  design pipeline, whose stages are folders in one repo and whose publish step is a site
  deploy. New in SKILL.md:
  - the single-repo variant, pointed to from the jobs table
  - rule 2 extended to deploy-on-merge sites
  - an exception to rule 4, for stages that chain on one shared branch prefix
  - rule 11, a worktree `deny` list for MCP tools that act on hardware or a live desktop session
  - "Hold paths" and "Notification routing" parameters (mail labels stack)
  - a corrected dry-run step, plus a first-real-run step
  - the Windows shell traps, moved up from a reference because they were hit three times
  - two anti-patterns
- `architecture.md` gains a runner comparison and a "single-repo variant" mapping, and its
  failure table gains changelog-only conflicts, stale adopted branches, kept worktrees and
  locked run folders. The runner comparison shows that the roadmap-style runner has no
  pre-check, no date injection and no RUN SUMMARY parsing.
- `stage-contracts.md` documents the sweep runner's per-target `branchPrefixes` and
  `holdPaths` hard gate. `audit-checklist.md` gains five items, `idea-sourcing.md` covers
  pre-researched sources and web research as a fallback, and the description stays under
  1024 characters.

## 2026-09-22

**Added**
- A third tier, `Skills/Domain/`, for field skills mirrored from the org's five agent
  workspaces. It installs only with `install-skills.ps1 -Domain`, so a bare run stays
  Core-only. The README lists domain folders, not each skill.
- Mirrored `debugging-methodology`, `performance-optimization` and `testing-strategy`
  (Engineering, from `fullstack-agent`), then `api-client-resilience`,
  `api-integration-testing` and `public-api-evaluation` (API, from `api-agent`), by the
  weekly Skill Harvest. (PRs #13, #14)
- `Docs/HARVEST.md`, the ledger of every mirrored skill and its source commit.

**Changed**
- The three Engineering skills moved from `Skills/Core/` to `Skills/Domain/`, and the Core
  catalog, README and showcase counts went back to seven skills in six categories. The
  showcase site gained a Domains section.
- `repo-docs-builder` now requires a `ROADMAP.md` and a `CHANGELOG.md` in every docs tree
  it builds, and `install-skills.ps1` installs into every agent CLI with one `-AllAgents`
  run. (PR #11)
- Monthly skill review: `task-router`'s flagship tier now names Opus 5.5, not Opus 5.
- Monthly skill review: `html-email-templates` no longer blames `backdrop-filter` for
  Template B being unsafe to inline — Gmail and modern Outlook have supported it since
  January 2024. CSS custom properties remain the real blocker.
- Monthly skill review: `project-hub-scaffold`'s `references/design-system.md` theme table
  grew from four schemes to the eight the live Hub actually ships (`plum`, `nord`, `sepia`,
  `mono` were missing).
- Monthly skill review: `edge-spectrum-dataset`'s guard table now lists `check:market`,
  the CI step the live repo added between `gen:edges --check` and `check:edges`.

**Docs**
- Started this changelog, seeded from the git log. *(roadmap: Phase 1)*
- Added the roadmap that the weekly roadmap routine works from.
- Repointed local clone paths after the `Repos/` owner-bucket reorg.

## 2026-09-21

**Changed**
- Moved the showcase site's source link into a bar across the top of the page. (PR #10)

## 2026-09-18

**Added**
- Loaded the shared consent banner on the showcase site. (PR #9)

## 2026-09-16

**Added**
- Published a static showcase site for the Core catalog at
  `agent-skills.ai-automation-tools.dev`, with Project Hub screenshots and a showcase
  action list.

**Removed**
- Removed the `video-downloader` skill.

## 2026-09-15

**Added**
- Three `project-hub` maintainer skills in the project tier. (PR #8)
- Three `edge-spectrum` skills in the project tier. (PR #7)
- Three `agent-chat` skills in the project tier. (PR #6)

## 2026-09-14

**Added**
- Two `edge-radar` strategy skills in the project tier. (PR #5)

## 2026-09-11

**Added**
- Two `cronsole` job-authoring skills in the project tier. (PR #3)

**Changed**
- Split `Skills/` into a portable Core tier and a per-repo Projects tier, with the project
  tier installed on top of each repo's own skills. (PR #2)
- Renamed four skills to drop the `-mfs` suffix and stripped personal references for the
  public repo. (PR #1)

**Docs**
- Simplified the README skill catalogs and navigation. (PR #4)

## 2026-09-10

**Changed**
- Renamed the repo from `My-Custom-Skills` to `agent-skills` and prepared it for a public
  audience.

## 2026-09-09

**Added**
- `task-router` skill in the Automation category.

**Changed**
- Moved the repo to the `ai-automation-tools` org and repointed references.
- Updated `project-hub-scaffold-mfs` for shared workspaces and portable installs.

## 2026-09-08

**Docs**
- Documented how `email-template-mfs` sends its email.

## 2026-09-03

**Added**
- `email-template-mfs` skill in the Automation category, with its Skill-Data.
- `project-hub-scaffold-mfs` skill.

**Changed**
- Generalized skills so they work outside this repo.

## 2026-08-26

**Added**
- `video-downloader` skill, with Windows and robustness fixes.

## 2026-08-17

**Added**
- `business-planning-mfs` skill.

**Changed**
- Renamed `News-Images` to `news-images`, the last PascalCase skill name.

## 2026-08-05

**Changed**
- Merged the four documentation skills into one `repo-builder-mfs` and retired its three
  sources.
- Embedded the humanizer voice rules into `repo-builder-mfs` as an always-on §0.

## 2026-07-17

**Added**
- `repo-docs-mfs` skill for repo documentation structure, with Skill-Data examples.
- `repo-builder-mfs`, a composite of the three documentation skills.

## 2026-07-13

**Added**
- `install-skills.ps1` for mirroring skills into a skills directory.

**Changed**
- Extended `readme-header-mfs` and `readme-builder-mfs` to cover folder and section
  READMEs.

## 2026-07-09

**Added**
- `readme-header-mfs` skill for README hero headers, folded into `readme-builder-mfs`.

## 2026-07-08

**Added**
- `recipe-validator` skill, the `Resources/` tree, and a per-skill README index.

**Changed**
- Redesigned the README around a skill catalog table.
- Relaxed the diagram ban in `readme-builder-mfs` to a sparing opt-in.

## 2026-07-06

**Changed**
- Restructured the repo into `Skills/` and `Docs/`, with skills grouped into category
  folders.

## 2026-07-01

**Added**
- Initial repo with the `readme-builder-mfs` skill.

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="ROADMAP.md">Roadmap</a> ·
  <a href="USING-SKILLS.md">Using skills</a> ·
  <a href="#changelog-top">↑ Back to top</a>
</p>
