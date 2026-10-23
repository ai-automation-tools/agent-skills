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

## 2026-10-22

**Changed**
- README usage checked against a clean clone of `main`: the Core, Domain and Projects tables match the `skills/` tree (10, 17 and 13 skills), and every install command in `README.md`, `docs/USING-SKILLS.md` and the tier READMEs ran as documented (`-List`, bare, `-Core -Skill`, `-WhatIf`, `-Domain`, `-Project`, `-AllAgents -WhatIf`). Fixed what had drifted: the Media domain is from `media-agent` (was `media-studio`), the guide's category example is lowercase, and its authoring steps name a Core skill's overview page, `showcase.json` card and showcase rebuild. *Public release*
- `repo-docs-builder`: a repo that ships an MCP server links `docs/mcp-server.md` from its root README (the MCP feature row or section, and the docs table), and that page gives the install line for each client: Claude Code, Codex, opencode, Antigravity. `check-org-layout.py` flags a README without the link, with a self-check case. Gemini CLI, deprecated, is dropped from the layout reference.
- `project-hub-scaffold` and the three `project-hub-*` project skills follow project-hub's lowercase folders (`hub/`, `project-hub/`, `projects/`, `demo/`). The project skills also pick up two changes that had reached only project-hub's installed copies: per-workspace `maxDepth` and bookmark groups.
- `agent-workspace-builder`: Gemini CLI, deprecated, is no longer a target. `gen-vendor-configs.py` stops writing `.gemini/settings.json`, `.gemini/commands/`, `.geminiignore` and the Gemini section of `OTHER-CLIS.md`, and keeps `.gemini/` and `.geminiignore` as owned paths so the next regen deletes what an older version wrote (`--check` flags them until then); Codex and Antigravity output is unchanged. The self-check pins that no `.gemini*` file is produced; SKILL.md, the references and assets drop Gemini CLI, and the hook fallback is now just the working directory. `install-skills.ps1`'s help shows agy's real path, `~/.gemini/antigravity-cli/skills`.

**Added**
- `AGENTS.md` (the rules, moved from `CLAUDE.md` with its history) and a new `CLAUDE.md` that imports it and keeps only Claude-only notes; `docs/README.md`, an index of `docs/`. Org layout P2-21.
- `repo-docs-builder`: `scripts/check-org-layout.py`, the org layout check. It reads each clone's tracked files and prints one `ISSUE:` line per drift from `org-repo-layout.md`; Org Upkeep runs it weekly across every org clone, and CI runs its `--self-check`. First run: 25 repos, 14 drifting, 53 issues, all on the 2026-10-22 migration list.
- `repo-docs-builder`: `references/org-repo-layout.md`, the org repo layout standard: lowercase-kebab folders, and one home each for docs, diagrams, code, front end, MCP servers (`mcp-server/` or `docs/mcp-server.md`), skills, prompts, scripts, tests and images, with `AGENTS.md` canonical. §1 points to it; `agent-workspace-builder` step 6 follows it. Closes the convention half of org ROADMAP P2-15.

**Changed**
- Renamed every folder under `Skills/` and `Resources/` to lowercase-kebab, per the org layout standard (org ROADMAP P2-21): `skills/<tier>/<category>/<name>/` and `resources/skill-data/…`. Skill folder names and files are unchanged, and installs stay flat, so installed copies don't move. The scripts, CI, READMEs, docs and showcase links follow; the showcase still shows `Automation`, `API` and so on as labels. `check-org-layout.py --repo` now reports 0 issues. Entries below this one keep the old spelling.
- `edge-spectrum-dataset`: `gen:edges` writes three artifacts now, not four (the Streamlit `data.py` output is gone); `Data/` and `docs/Ideas/` are lowercase in that repo, and the edge-spectrum skills point at its `AGENTS.md`. The Roundtable skills (`agent-chat-conv-types`, `agent-chat-delivery`) use its lowercase `docs/app/` and `docs/guides/`.
- `project-hub-scaffold`: `references/current-features.md` takes the bookmark-groups text that landed only in `project-hub`'s travel copy (its #25), so the two copies match again. `project-hub`'s CI now fails if they drift.
- Branch workflow: this repo now follows the lab-wide `mike_desktop` → PR → `main` flow, and jobs open PRs from their own branches. `CLAUDE.md` said `main` only, which had stopped being true.
- Renamed the top-level `Docs/` folder to `docs/`, per the org layout standard. GitHub is case-sensitive, so `docs/...` links into this repo 404'd. Every link, the showcase's GitHub links, `check-links.py` and the CI comment now use `docs/`. The `edge-spectrum` project skills and `project-hub-scaffold` references now point at `docs/` too, since those repos are renamed the same day. Entries below this one keep the old spelling.

## 2026-10-20

**Added**
- `agent-workspace-builder` (Core, Automation): creates, adopts or audits a specialized agent workspace repo and sets up its weekly roadmap and upkeep jobs. The standard: `AGENTS.md` canonical with `CLAUDE.md` importing it, only README, ROADMAP and CHANGELOG at the `docs/` root, `docs/reference/` for the generated `CAPABILITIES.md` and a link-verified `RESOURCES.md`, portable `skills/` apart from `.claude/skills/`. Ships four stdlib checks for CI (`check-structure.py` new; `validate-skills.py` now also covers the portable `skills/`; `gen-capabilities.py` writes to `docs/reference/` and lists portable skills; `check-links.py`), templates for every frame file, and both job prompts. Written to standardize the org's five agent workspaces.

**Changed**
- `agent-workspace-builder`: the *Ready for a stranger* release gate includes a README line saying the workspace works with Codex, Gemini CLI and Antigravity, linking `docs/reference/OTHER-CLIS.md`, so public users of those CLIs find what they get and which guardrails don't apply.
- `agent-workspace-builder`: one setup, every CLI (principle 10). New `scripts/gen-vendor-configs.py` derives Codex, Gemini CLI and Antigravity config from `.claude/` and `.mcp.json`: a shared `.agents/skills/`, Antigravity rules and MCP, Codex command rules (`prefix_rule` from the Bash allow/ask/deny list), hooks, MCP and reviewer agents, Gemini settings (AGENTS.md as context, `.env` kept out of its environment, MCP, `tools.allowed`/`exclude`, hooks), commands and `.geminiignore`. Whatever a CLI's format can't express is written into a generated `docs/reference/OTHER-CLIS.md`, which AGENTS.md points to. `check-structure.py` requires both; CI runs `--check`; the generated permission files join the hold paths; both job prompt templates regenerate and check it. Rolled out to the seven Org_Agents workspaces, which also turned up a hook that failed open outside Claude (it found the project via `$CLAUDE_PROJECT_DIR`).
- `agent-workspace-builder`: going public. The roadmap's split heading is the visibility intent (`## After public release` headed public, `## After go-live` stays private), and `automations.md` gains *Going public: an optional release job*: release-prep gates in the `## 🚦 Public release` phase, then a release job where a script runs the hard gates, the owner approves on an issue, the script flips visibility and re-applies the security controls, and only then a session does topics, dependency updates, the site listing and records.
- `agent-workspace-builder`: autonomy (Mike: too many asks). Principle 9, *proceed unless vetoed*: only five decisions wait for the owner (money, credentials, going public, outward actions, widening permissions); everything else is a proposal in `docs/operations/OPEN-QUESTIONS.md` with `- Default:` and `- Proceeds:` (seven days out), applied automatically unless vetoed. New `scripts/usage.py` turns "the owner says it's in daily use" into `--check --min-days 10` (active days in 30, from local Claude Code logs; job worktrees excluded); `check-structure.py` requires it. AGENTS.md gains a *Standing defaults* section; the roadmap and upkeep prompt templates and `automations.md` (*Autonomy*) follow.
- `agent-workspace-builder`: secrets standard (Mike's call): real values in a gitignored `.env`, names in a committed `.env.example`, not user environment variables, so a published or cloned workspace says what it needs. New `scripts/envfile.py` loads `.env` for scripts (`load_env()`) and launches MCP servers with it (`envfile.py -- <cmd>`), because `${VAR}` in `.mcp.json` only reads the process environment. `check-structure.py` now requires `.env.example` and `envfile.py` and fails when `.env` isn't gitignored, `.env.example` is ignored or carries a secret value, or `.mcp.json` uses a `${VAR}` the example doesn't name. New `assets/env.example`; `SKILL.md` principle 8, the standard, and the `AGENTS.md`/`SECURITY.md` templates updated.
- `agent-workspace-builder`: `envfile.py` launches without a shell (an argument like `mcp<2` was a cmd.exe redirect) and treats an empty or unexpanded `${VAR}` as unset, so a client passing `.mcp.json` env entries through can't mask `.env`. Tested live: the security `github` and media `serper` servers start through it.

**Fixed**
- `agent-workspace-builder`: `gen-capabilities.py` took the page title from the checkout folder when a workspace had no `.claude-plugin/plugin.json`, so `--check` failed in CI, which clones under the repo name. It now falls back to `AGENTS.md`'s first heading. Found creating `science-agent`; the five existing workspaces have a `plugin.json` and are unaffected.

## 2026-10-19

**Added**
- `automated-dev-pipeline`: rule 13 gains a weekly fleet improver, a stage that proposes one change a week to the fleet itself (enhance a job, add one, or smooth idea-to-public) as a PR on the config repo the owner merges, merged by the owner at first and later, optionally, by the runner behind scripted gates that hold any PR touching a guard file (the deny list, merge gates, register scripts, the improver's own runner and prompt), with the next run rebuilding the fleet diagram and leaving a `Follow-through:` comment as its ledger. The workflow diagram (source, interactive HTML and `pipeline-flow.svg`) shows it in the keep-current and owner lanes.
- Site: the `automated-dev-pipeline` card links to its interactive Archify diagram (a `diagram` key in `site/showcase.json`, rendered by `build-showcase.py`). The skill's overview README no longer embeds the diagram; it points at the homepage. `pipeline-flow.svg` stays in the skill folder for agents.
- `repo-docs-builder`: `references/roadmap-standard.md`, the one `docs/ROADMAP.md` format for every project in the lab: phases, the four checkbox markers, `— done YYYY-MM-DD` notes with a changelog line in the same commit, one go-live heading (`## After public release` or `## After go-live`) with the gates above it and post-go-live groups below, a copyable skeleton, and the checks the Road Map Sweep runs. Modelled on the Collector and AI Command Center roadmaps.

**Changed**
- `automated-dev-pipeline`: projects graduate at their MVP. The release gates are the smallest slice that delivers the core promise (at most three features) plus the publish checks, the rest builds in public after release, and incubate ships the boilerplate gates itself. Rule 6 and the architecture contract add three roadmap runs a week while incubating, a daily sweep for incubating repos (`fullSweepDays` + `everyDay`), batches of up to six `small` items, an ideate threshold of 5 with ideate twice a week, and auto-park after 14 days. The workflow diagram reads "MVP gates ticked".
- `repo-docs-builder` §2.5, build step 6 and audit item 5 now point at the roadmap standard instead of carrying their own phase table.
- `automated-dev-pipeline`: the architecture contract, the roadmap-routine prompt contract and the add-a-stage procedure name the roadmap standard as the format every stage writes and every routine reads.
- `business-plan-builder`: the build-plan template says how its slices map onto a repo's roadmap in the standard format.

**Docs**
- `Docs/ROADMAP.md` moved onto the lab roadmap standard: a `## 🚦 Public release` gate phase (CI and the live showcase ticked; README check, `SECURITY.md` with a secret scan, and the licence open) above `## After public release`, with Phases 1 to 4 as groups below it, every item a one-line checkbox, done notes as `— done YYYY-MM-DD`, and `🔒 Needs Mike` at the end of the line. The licence item moved from "Needs a decision" into the gates. No items dropped; the README and `SECURITY.md` gates are new.

**Site**
- The showcase moved onto the org house style (`web-house-style`), matching ai-automation-tools.dev and the Edge-Radar page: `#060606` ground with the dot grid and zinc surfaces in place of the ink, grid, grain and three glows; Inter + JetBrains Mono in place of Instrument Serif and Geist; the shared token blocks for both themes (light is now zinc `#fafafa`, not warm paper); a full-width source bar; a 56px top bar with the app icon, sans nav, a phone menu sheet and the Light | Dark switch last; house buttons (amber primary, black GitHub, ghost), cards, chips with `aria-pressed`, terminal blocks and footer. Amber stays the accent. The footer now links ai-automation-tools.dev, the cookie notice and Cookie settings; a new Resources section links the repo, README, guide, Core index, changelog, roadmap and skill ideas. `favicon.svg` is the shared icon file. At 390px the page no longer scrolls sideways (it overflowed by 319px) and the nav is reachable.
- `scripts/build-showcase.py` writes each card's screenshot paths into the page (`src` plus `data-shots`), so the browser no longer probes extensions and the console is free of 404s. Adding an image now means re-running the generator, which `--check` enforces.

## 2026-10-15

**Added**
- `scripts/test-install-skills.ps1` smoke-tests the installer: it installs every tier into a temp directory and checks the flat `<dir>/<name>/SKILL.md` layout, that a bare run installs Core only, that `-Skill` narrows and `reports/` never ships, and that a duplicated skill name throws and installs nothing. `validate.yml` runs it under `pwsh`. *Phase 1*

**Changed**
- Core skill names in the root README and `Skills/Core/README.md` now open each skill's overview page, the `Resources/Skill-Data/` README, which leads with what the skill does and its diagram or screenshots, then links to `SKILL.md`. Every overview gets a standard header; `web-house-style` gets its first one. The convention is written into `CLAUDE.md` and `Resources/README.md`.
- `automated-dev-pipeline`: the roadmap routine takes one feature or up to four `small` items per run. Incubate tags docs, config and asset gates `small` when it writes the ROADMAP, so a PR can close several of them at once (`stage-contracts.md`, `architecture.md`, SKILL rule 6, the diagram).
- `automated-dev-pipeline`: documentation pass so the skill matches its reference implementation: plan approval (`proposed`) and the score bar, auto-park, runner-side merge (rule 1), a fleet-wide deny file on every runner (rule 11), retries only before any write (rule 12), `holdPaths` / `emailAllowList` / `extraBranchPrefixes` sweep keys, twice-weekly roadmaps chaining through APPEND MODE, runner-fed trap promotion, and a corrected runner table.
- `automated-dev-pipeline`: `pipeline-flow.svg` is replaced by a swimlane diagram generated with Archify, which follows the reader's light or dark theme. An interactive version is published at `site/assets/diagrams/automated-dev-pipeline-workflow.html`, and both come from one JSON source in Skill-Data.

## 2026-10-13

**Added**
- `web-house-style` (Core · Web): the shared look, feel and navigation of the org's sites, written from the landing page, Agent Chat, Cronsole, Edge-Radar, Edge Spectrum and Project Hub. Dark-first tokens with a light theme, the Light / Dark switch in the top-right corner with its pre-paint script, the source bar, a sticky top bar or a collapsible icon sidebar, and the 2026-10-13 phone pass. Ships two starter pages, `assets/page.html` and `assets/app-shell.html`.

## 2026-10-08

**Added**
- `scripts/check-links.py` checks every relative link in the READMEs, `Docs/` and the showcase page, case-sensitively, and `validate.yml` runs it. Its first run found nine broken back-links in the Skill-Data and `site/assets/img/` READMEs, now fixed. *Phase 1*

## 2026-10-06

**Fixed**
- Workflows pin the Node 24 majors of `checkout`, `setup-python`, `upload-pages-artifact` and `deploy-pages`; GitHub dropped Node 20 on 2026-09-23.
- The Antigravity CLI skills path is `~/.gemini/antigravity-cli/skills` in `install-skills.ps1` and `USING-SKILLS.md`.

**Changed**
- `UPSTREAMS.md` rows re-checked; the Codex docs moved to `learn.chatgpt.com`.

## 2026-10-05

**Changed**
- `project-hub-scaffold`'s design-system reference and the `project-hub-client` skill match
  the `project-hub` restyle of the same day: `obsidian` is the ninth and default scheme,
  Inter + JetBrains Mono replace IBM Plex, radii and the derived surface tokens live on
  `:root`, `--ok` is split from the accent for clean / live state, and `hub.design` records
  the one-time move onto the new default.

**Added**
- A light / dark theme toggle at the right end of the showcase's top bar, with a warm-paper light
  palette; dark stays the default and the choice is remembered per browser.
- `Docs/UPSTREAMS.md`, the worklist for the new biweekly **Agent-Skills Upstream Check**
  routine: the skill format, every install target `install-skills.ps1` writes to, Python,
  PowerShell, the CI actions, GitHub Pages, the site's fonts and the org consent gate. The
  same routine also checks that the showcase site and the indexes list every Core skill.
- `scripts/build-showcase.py` generates the showcase's cards, filter chips, Domain and Project
  lists and counts from the `Skills/` tree, with the hand-written card copy in
  `site/showcase.json`. `validate.yml` runs it with `--check`, so the site can't fall behind the
  catalog again. *Phase 2*
- The `automated-dev-pipeline` card, missing from the site since the skill landed on 2026-09-23,
  with a diagram drawn in the site's palette (`site/assets/diagrams/automated-dev-pipeline.html`).
  The page now says eight Core skills. *Phase 2*

## 2026-10-01

**Added**
- `.github/workflows/validate.yml` runs `scripts/validate-skills.py` on every push to `main`
  and every pull request, read-only, so a broken skill shows up as a red check before merge.
  `CLAUDE.md` and `Docs/USING-SKILLS.md` mention it. *Phase 1*
## 2026-10-03

**Changed**
- Monthly currency review. `task-router` names Sonnet 5.5, the current Sonnet.
- `recipe-validator` cites the 2025–2030 Dietary Guidelines for sodium and added sugars.
- `project-hub-scaffold`, `project-hub-scan` and `project-hub-client` match the current
  `project-hub` repo: five test files (83 tests), a 3,700-line `index.html`, and the search
  `root=` / `type=` params.
- `cronsole-claude-routines` notes that `untrack_task` now clears a `MISSING` OAuth-mode row.
- `edge-radar-strategy-profiles` drops the retired `NightlySettle` task and adds the
  per-category `MIN_EDGE_THRESHOLD_*` knob.
- `edge-spectrum-endpoint` names the two new `strategySchema.ts` assertions.
- `agent-chat-conv-types` fixes the `max_members` rule; `agent-chat-run-triage` covers
  auto-written seat permissions and the relative-`$AGENT_CHAT_DB` startup exit.

## 2026-09-30

**Added**
- A flow diagram for `automated-dev-pipeline`,
  `Skills/Core/Automation/automated-dev-pipeline/pipeline-flow.svg`, beside `SKILL.md`, so it installs with the skill. One
  hand-written SVG draws build, publish, keep-current and the rule 13 feedback loop, with the
  human decisions in amber. `SKILL.md` links it under "The loop", and a new Skill-Data README
  describes it.

**Changed**
- `automated-dev-pipeline` adds what an analysis of every org and 3D Lab run log taught about
  feedback. Until now, nothing a run learned or was told reached the next run.
  - Rule 12: a session that exits non-zero with no work is a failure, never a quiet week, with
    one retry on a platform error. Caps are counted from the ledger, not per run.
  - Rule 13: close the feedback loop in the runner. That means a JSONL run history with
    `start` and `end` records (a start with no end is a silent death), a shared runtime-traps
    file prepended to every prompt, and PR comments read first in APPEND MODE. Prompt changes
    still need a human's approval.
  - The Windows traps add inline quoting, `/tmp` and refused deletes.
  - The runner table gains a Feedback row, and Failure handling gains four rows.
  - The audit checklist gains section 8, Feedback.
- `automated-dev-pipeline` rule 13, second pass (`2545609` and this PR): lessons per job,
  the owner's post-merge fixes read back, parking items that wait only on the owner, prompt
  changes proposed as a PR on the prompts' own repo, one `docs/OPEN-QUESTIONS.md` per repo,
  and a weekly inbox digest of everything waiting on the owner. Audit section 8 gains six
  checks.
- `scripts/install-skills.ps1 -AllAgents` targets the paths each CLI reads today (checked
  against the CLI-Guides location table): `~/.agents/skills` for Codex and Kimi (the old
  `~/.codex/skills` is legacy and would load twice), `~/.gemini/skills` for agy,
  `~/.gemini/config/skills` for the Antigravity IDE, plus opencode and Kilo. Before this,
  agy got `~/.agents/skills`, which it doesn't read. `Docs/USING-SKILLS.md` shows
  `-AllAgents` instead of hand-picked destinations.

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
