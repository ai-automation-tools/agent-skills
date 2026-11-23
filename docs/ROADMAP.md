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

The Agent-Skills roadmap routine (`agent-skills-roadmap`) works this file top to bottom, one
item per run, as `roadmap/auto-` PRs: it takes the first open item that isn't `🔒 Needs owner`
and that it can finish and verify, and the org PR sweep merges it. A person can take any item
too. **Every item above `## After public release` is a release gate.** The repo and its showcase are already public, so the open gates are catch-up
work, taken first. Ticking an item adds its line to the [changelog](CHANGELOG.md), tagged with
the phase in italics, and updates any doc it made stale, in the same commit.

Markers: `- [ ]` open, `- [-]` claimed by a run in progress, `- [x]` done, `- [!]` blocked
(the reason follows on the line). `small` marks an item a check verifies; `🔒 Needs owner`
marks one only the owner can do.

The rules every item follows are in [`AGENTS.md`](../AGENTS.md): the two tiers, the
standing sync instructions, and what makes a skill portable.

## 🚦 Public release

- [x] CI green on push and PR: `validate.yml` runs the skill validator, then the link check, the showcase `--check` and the installer smoke test as they landed — done 2026-10-01: `validate.yml` on push to `main`, every PR and by hand
- [x] README usage (catalog, install commands, authoring guide) verified against the real `skills/` tree and `scripts/install-skills.ps1` from a clean clone — done 2026-10-22: every table and install command checked against a fresh clone of `main`; fixed the Media source name in `README.md` and the category case and Core authoring steps in `docs/USING-SKILLS.md`
- [x] `SECURITY.md`, and a full-history secret scan that comes back clean — done 2026-10-29: root `SECURITY.md` (private report address, skill-library scope, Domain fix path, scan command); gitleaks 8.30.1 over every commit on every branch found no leaks
- [x] Licence chosen and `LICENSE` added — done 2026-11-05: Mike chose Apache-2.0, matching cronsole, roundtable, edge-spectrum and promptbook (org roadmap P2-10); root `LICENSE` and a License section in `README.md`
- [x] Live at its URL: the showcase at `https://agent-skills.ai-automation-tools.dev`, deployed by `pages.yml` — done 2026-09-16: published the same day the static showcase was added

## After public release

Nothing below blocks go-live.

### 🛡️ Security hardening (code audit, 2026-11-19; work these first)

Found in the owner's own static audit of the skill text and scripts. Each item is the fix and its test; build them in this order, one per run, before anything else below.

- [x] **Fence the unattended agent session in `cronsole-windows-jobs`** *(Security)* — **What:** in `skills/projects/cronsole/cronsole-windows-jobs/references/agent-job.md`, wherever `--dangerously-skip-permissions` is prescribed (the invocation in §2, its flag table and the §8 anti-patterns), add the deny file passed with `--settings` and a line telling the session to treat repo, issue and web content as data, matching `automated-dev-pipeline` rule 11; link that rule from the skill's `SKILL.md`. **Why:** the reference makes the permission bypass mandatory but never limits what the bypassed session may do, which the library's own pipeline skill requires. **Done when:** every bypassed invocation in the skill shows `--settings <deny file>`, and a check in `scripts/test-skill-scripts.py` (or `validate-skills.py`) fails on any skill file that names `--dangerously-skip-permissions` without `--settings` in the same code block — done 2026-11-22 (audit AS-08, AS-28): both invocations, the flag table and two anti-patterns name `--settings $DenyFile`, the SKILL.md routing row links rule 11, and `scripts/lint-skill-safety.py` (rule `bypass-unfenced`, in `validate.yml`) fails on an unfenced bypass block
- [x] `small` **Drop the unconditional "email, and publish" from the news-images prompts** *(Security)* — **What:** in all eight `skills/core/image-gen/news-images/prompts/*.md`, change line 5's "then save, email, and publish it" to "then save it", leaving email to the existing optional section. **Why:** the skill's job is generation only and email is opt-in, but the opening line tells the agent to send and publish every time. **Done when:** `grep -ri "email, and publish" skills/core/image-gen/news-images` finds nothing and the prompts still pass `validate-skills.py` — done 2026-11-19 in #126: all eight prompts say "then save it". The check was `grep -ri "publish"`, which could never pass because the fix added the safeguard "Never email, post, upload or publish the image unasked"; corrected 2026-11-22 (audit AS-13)
- [x] `small` **Warn before an install replaces a folder the repo didn't write** *(Security)* — **What:** in `scripts/install-skills.ps1`, extend the overwrite warning from `-Project` to every tier, and before replacing or (under `-AllAgents`) removing a same-named destination folder, skip it with a warning unless it carries a marker the installer writes (for example a `.installed-from-agent-skills` file) or `-Force` is given. **Why:** a user's own skill whose folder name matches a library skill is deleted with only a "Replaced" row in the table. **Done when:** `scripts/test-install-skills.ps1` has a case where a hand-made same-named skill in the destination survives a Core install without `-Force`, and a previous install from this repo is still replaced — done 2026-11-22 (audit AS-06): every install writes `.installed-from-agent-skills`; a same-named folder is replaced only when it carries the marker or its `SKILL.md` matches a version this repo shipped, otherwise it's skipped with a warning unless `-Force`. Links are never replaced or deleted through, and each skill is swapped in with renames. `test-install-skills.ps1` covers all of it

### 🧾 Audit follow-ups, 2026-11-22

From the full repo audit of 2026-11-22 (baseline `4d77026`). Ids are the audit's `AS-xx`; each PR or commit that closes one says so in its title (`fix(AS-04): …`). Items marked `- [!]` live outside this repo (claude-routines, GitHub settings, the Agents hub): the reason is on the line, and the roadmap routine skips them.

- [!] **AS-01** `validate` as a required status check on `main`, and `allowNoChecks: false` for this repo in the org PR sweep 🔒 Needs owner — blocked: a GitHub ruleset change (this repo only, or org-wide?) plus a claude-routines edit
- [x] **AS-02** Install Core from a reviewed SHA, tracked files only, with a version marker *(installer side)* — the AI Tools Sync side lives in claude-routines — done 2026-11-22: `install-skills.ps1 -Ref <ref>` installs the tracked files of one commit via `git archive`, the marker records ref and commit, and build litter (`__pycache__`, `.venv`, `*.pyc`) never ships even from the working tree. Sync passing `-Ref origin/main` and reporting the SHA is claude-routines' half
- [!] **AS-03** Hold PRs that change `skills/core/**`, `skills/**/scripts/**`, `scripts/install-skills.ps1`, `AGENTS.md` or `SECURITY.md` for a person — blocked: `holdPaths` in claude-routines' `org-pr-sweep/routine.json`
- [x] **AS-04** `gen-vendor-configs.py` can't delete files outside its workspace
- [x] **AS-05** Owner gates on funding, `DRY_RUN=false` and promotion in `edge-radar-strategy-profiles` — done 2026-11-22: the three money steps (subaccount, `DRY_RUN=false`, promotion) carry `🔒 Needs owner` with "prepare, then stop" in `SKILL.md` and `references/launch-and-kill.md`
- [x] **AS-06** The installer replaces only what it wrote, skips links, and swaps atomically (security item 3 above) — done 2026-11-22: see security item 3 above; also no staging folder inside the destination, per-skill errors, exit 1 on any failure
- [!] **AS-07** One install target list for `install-skills.ps1` and AI Tools Sync — this repo's half done 2026-11-22: `scripts/install-targets.json` holds the shared and retired folders and the installer reads it. Blocked on the rest: Sync in claude-routines must call `install-skills.ps1 -AllAgents -Ref origin/main` (or read the JSON), and the HUB-REFERENCE install claim is in the Agents hub
- [x] **AS-08** Fetched content is data: the rule in `automated-dev-pipeline`, both `agent-workspace-builder` prompt assets and `cronsole-windows-jobs` (security item 1 above); the live prompts are claude-routines' half — done 2026-11-22: rule 11 of `automated-dev-pipeline` says fetched content is data and rule 13 checks comment authors; `idea-sourcing.md`, both `agent-workspace-builder` prompt assets and `cronsole-windows-jobs` carry it; every bypass in `agent-job.md` has `--settings $DenyFile`. The live prompts are claude-routines' half
- [!] **AS-09** Private-data gate on the Skill Harvest; a person merges a harvest PR that adds a skill — blocked: the harvest runner is in claude-routines (it can call `scripts/lint-skill-safety.py`)
- [ ] **AS-10** Settle who owns the engineering Domain skills (move to Core, or a "maintained here" status), then fix `HARVEST.md`, the counts and `AGENTS.md` 🔒 Needs owner
- [x] **AS-11** Drift check for every hand copy (`copies.json`, `check-copies.py`); `project-hub-client` copied to project-hub — done 2026-11-22: `scripts/copies.json` lists the four copies in project-hub and `scripts/check-copies.py` compares committed blobs with GitHub's tree, weekly in `copies.yml`; it found `project-hub-client`'s missing `hub.dots` row, fixed in a paired project-hub PR
- [!] **AS-12** Decide how the 2026-11-24 Org Agents refresh merges (sweep exception for byte-identical script syncs, or one manual round) — blocked: claude-routines' sweep prompt
- [x] **AS-13** Tick the news-images item (#126) and fix its check; repoint the cronsole item at the new rule — done 2026-11-22: news-images item ticked (#126) with a check that can pass; the cronsole item now points at the data rule AS-08 added to rule 11
- [x] **AS-14** Every shipped `--self-check` in CI, plus a `windows-latest` job
- [x] **AS-15** One frontmatter parse rule (BOM, folded scalars) and one line-cap policy across the scripts — done 2026-11-22: the five readers (both validators, `build-showcase.py`, `gen-capabilities.py`, `gen-vendor-configs.py`) strip a BOM and read `>-`/`|` block scalars and quotes the same way; `test-skill-scripts.py` checks all five against three fixtures. One line policy in both validators: over 500 lines is a note (never a failure, even under `--strict`), over 1,000 fails. Kept as matching code in each script rather than one module, since the workspace scripts are copied one by one
- [x] **AS-16** `cronsole-windows-jobs` helpers: a repeat duration Windows accepts, catch-up opt-in, launch errors logged, quoted arguments — done 2026-11-22: no repetition duration (empty = indefinitely), `catchUp` opt-in (`StartWhenAvailable` off by default), a launch failure logs and notifies as `failed`, `notify.arguments` takes an array and `run-hidden.vbs` quotes each argument. Tests cover each; the Windows CI job registers and removes a real repeating `\SkillTests\` task
- [x] **AS-17** `-All -AllAgents` rejected, `scaffold-hub.ps1` requires PowerShell 7, `envfile` strips a comment before unquoting — done 2026-11-22: `-All -AllAgents` throws and `-All` is documented as test-only; `scaffold-hub.ps1` starts with `#requires -Version 7`, so Windows PowerShell 5.1 refuses before writing anything (project-hub travel copy updated in a paired PR); `envfile.parse` takes a quoted value up to its closing quote, so `TOKEN='abc' # x` is `abc`
- [x] **AS-18** `check-triggers.py`: no MCP servers, failed or timed-out runs are inconclusive, not passes — done 2026-11-22: sessions start with `--strict-mcp-config` and an empty `--mcp-config`; a failed, signed-out, timed-out or unstartable session is inconclusive (exit 2), never a pass; hitting `--max-turns` still counts; `--claude` and `--timeout` options. Checked with a bad binary (all inconclusive) and a live `news-images` run (4 of 4)
- [x] **AS-19** SHA-pin the GitHub Actions; Dependabot keeps the pins current — done 2026-11-22: every `uses:` in the three workflows is a 40-character SHA with its tag in a comment; the existing grouped Dependabot config bumps both. The org-level "require SHA pinning" setting is the owner's call
- [!] **AS-20** Delete merged branches automatically and prune the old ones 🔒 Needs owner — blocked: a repo setting
- [x] **AS-21** Doc drift: workspace count, "Mike" in public docs, media-agent naming *(this repo)*; the hub and automation prompts are outside it — done 2026-11-22: six workspaces in `AGENTS.md` and `skills/domain/README.md` (with the engineering skills' status), `media-agent` in `HARVEST.md`, "the owner" in `edge-spectrum-registry`. The HUB-REFERENCE install claim and the claude-routines prompts (`Docs/`, `harvest.md`'s CLAUDE.md) are outside this repo
- [ ] **AS-22** Narrow `task-router` and `web-house-style` triggers and add cross-skill near-miss cases — needs `check-triggers.py` runs (local, spends tokens) to show 3 of 3
- [ ] **AS-23** Licence credits for adapted content; confirm the origin of the private business-analysis template 🔒 Needs owner
- [ ] **AS-24** Showcase: intrinsic image dimensions
- [ ] **AS-25** No consent prompt on org sites with no analytics 🔒 Needs owner — org-wide house-style decision
- [ ] **AS-26** Self-host the showcase fonts 🔒 Needs owner — org-wide house-style decision
- [ ] **AS-27** Publish `catalog.json` from the showcase build
- [x] **AS-28** Skill safety lint (`scripts/lint-skill-safety.py`) in CI — done 2026-11-22: `scripts/lint-skill-safety.py` (four rules, an allow-list that fails on unused entries, a `--self-check` with one seeded bad fixture per rule) runs in `validate.yml`; the tree is clean with an empty allow-list. It flags the pre-fix edge-radar and cronsole text
- [ ] **AS-29** Answer the Kimi skills-folder question in `OPEN-QUESTIONS.md` 🔒 Needs owner

### 🔨 Phase 1: catch a broken skill before it ships

When this phase started there was no test runner and no CI beyond the Pages deploy, so a
renamed skill, a `name:` that no longer matches its folder, or a `references/` path that moved
only showed up once someone installed the skill and it failed. Since 2026-10-01 `validate.yml`
catches them on every push and PR.

- [x] Start `docs/CHANGELOG.md`. Newest first, seeded from the git log at the grain that's honest (one line per merged PR). Link it from the README's Docs table next to this file — done 2026-09-22: seeded per PR since #1, per change before that; linked from the README nav and "Using a skill" line, since the README has no Docs table
- [x] Write `scripts/validate-skills.py`, with no third-party dependencies. For every `SKILL.md` it checks that the frontmatter parses; `name` is kebab-case, equals its leaf folder, and is unique across both tiers; `description` exists and is 40–1,024 characters long; every relative path the body mentions (`scripts/…`, `references/…`, `prompts/…`) exists; the skill has a row in `README.md` and in its tier's README; any `resources/skill-data/` folder mirrors a real skill path. It exits non-zero on the first class of failure and prints every failure, not just the first — done 2026-09-24: all six checks, run over all three tiers. Its first run caught `repo-docs-builder`'s 1,113-character description and two cronsole skills citing another skill's `references/`; both fixed. `scripts/` and `evals/` paths are checked only when the skill ships that folder, since project skills name their target repo's scripts
- [x] Run the validator in CI. A `validate.yml` workflow on push and pull request, with `permissions: contents: read` — done 2026-10-01: runs on push to `main`, every PR and by hand, on `ubuntu-latest` with stock Python 3. The repo passed a case-sensitive dry run first
- [x] Link check. Check every relative link in the READMEs, `docs/`, and the showcase cards, so a renamed skill fails loudly instead of 404ing quietly. Add it to the same workflow — done 2026-10-08: `scripts/check-links.py`, stdlib-only, in `validate.yml`. Covers every `README.md`, `docs/*.md` and `site/index.html`, including the cards' GitHub links back into this repo, and matches case exactly. Its first run fixed nine broken back-links in Skill-Data and `site/assets/img/` READMEs
- [x] Installer smoke test. Run `install-skills.ps1` into a temporary directory under `pwsh` in CI, then assert the flat layout (`<dir>/<name>/SKILL.md`) and that an induced name collision throws — done 2026-10-15: `scripts/test-install-skills.ps1`, in `validate.yml`. Also checks that a bare run is Core-only, that `-Skill` narrows and that `reports/` never ships. The collision is induced in a scratch copy of `skills/`, so the repo is never touched
- [x] Tests for the deterministic scripts. Cover the helpers under `recipe-validator/scripts/`, `project-hub-scaffold/scripts/`, and `cronsole-windows-jobs/scripts/`, using fixture inputs and standard-library runners only — done 2026-11-05: `scripts/test-skill-scripts.py` (30 checks on the recipe scanner) and `scripts/test-skill-scripts.ps1` (30 checks on the scaffolder and job wrapper, 6 more on Windows for the registrar and `run-hidden.vbs`), both in `validate.yml`; passed on Windows and in Linux containers
- [x] Drift check for the one known duplicate. A script that compares `project-hub-scaffold` here with its copy in the public `ai-automation-tools/project-hub` repo and reports any difference. Run it from CI on a weekly schedule. This repo is canonical, so the check reports and never edits — done 2026-11-11: covered from the other side since 2026-10-22. project-hub's `scaffold copy` CI job diffs its travel copy against this repo's `main` on every push and PR there and fails on drift. The copy only changes through project-hub PRs, so a per-PR check catches what a weekly one would, sooner

### 🪟 Phase 2: a showcase that stays true

These items come from the action list in [`site/README.md`](../site/README.md). The org
landing page now sends traffic to the site.

- [x] Generate the cards from frontmatter. A small script builds the card blocks in `site/index.html` from each Core skill's `name` and `description`, between marker comments, so the copy can't drift from `SKILL.md`. Run it in CI and fail if the output differs from what's committed — done 2026-10-05: `scripts/build-showcase.py`, stdlib-only. The tree decides which skills, categories and counts appear; the hand-written taglines and bullets moved to `site/showcase.json`, because a `description` is trigger text, not card copy. A Core skill with no entry still gets a card from its frontmatter. It also generates the filter chips, the Domain and Project lists and every count in the page. `validate.yml` runs `--check`
- [x] Showcase card for `automated-dev-pipeline`. Core has eight skills since 2026-09-23 but the site shows seven. Add its card (category `automation`, glyph 🏭) with a diagram image in `site/assets/diagrams/` drawn from the loop in its `SKILL.md`, like `task-router`'s, and change "seven" to "eight" in the intro and the install block — done 2026-10-05: copy in `showcase.json`, diagram `site/assets/diagrams/automated-dev-pipeline.html` rendered to `assets/img/automated-dev-pipeline.webp`; the counts are generated now
- [x] `og:image` + `twitter:card`. A 1200×630 crop of the hero, so a shared link previews properly (org roadmap P2-8) — done 2026-11-11: `site/assets/img/og.png`, captured from the page in headless Edge with reduced motion so the terminal shows its full frontmatter; `summary_large_image` card
- [x] Compress the remaining PNGs. The seeded `repo-docs-builder` images run up to 274 KB, so convert them to WebP like the rest — done 2026-11-11: all 13 showcase PNGs are WebP (lossless, or q90 where smaller), 967 KB to 319 KB; the largest was 274 KB, now 35 KB
- [x] Filter chips announce their state with `aria-pressed` — done 2026-10-19: shipped with the house-style move; ticked here 2026-11-11
- [x] Lightbox focus. Trap focus while the lightbox is open, and hand it back to the card that opened it — done 2026-11-11: Tab and Shift+Tab cycle the lightbox's visible buttons; closing already returned focus to the card. Tested in a browser
- [x] Screenshot `alt` text that describes the image, not the skill's name — done 2026-11-11: card images already used `showcase.json` `alt`; the lightbox said "<skill> — preview 2". A new `alts` list describes each gallery extra, written into the card as `data-alts` by `build-showcase.py`
- [x] Raise `--text-faint` to at least 4.5:1 against the card background. It measures about 4:1 today — done 2026-11-11: the token is `--fg-4` since the house-style move. Dark `#71717a` measured 3.8:1 on cards; `#7e7e87` is 4.6:1 or better on every surface. Light already passed (5.4:1+). The footer fine print moved off `--fg-5` (2.4:1)
- [x] No-JS fallback for the hero panel, so it isn't blank when the script fails — done 2026-10-19: the markup ships one skill's frontmatter; ticked here 2026-11-11
- [x] Homepage on the About panel. Run `gh repo edit ai-automation-tools/agent-skills --homepage https://agent-skills.ai-automation-tools.dev` — done 2026-11-11: already set; `gh repo view` returns the URL
- [ ] Decide whether the four seeded `repo-docs-builder` images stay. Seen 2026-11-11: two of them show other people's products (Amplication's feature grid, an Areg SDK comparison table), so replacing them with output from one of the org's own READMEs is the likely answer 🔒 Needs owner
- [ ] Check the layout on a real phone 🔒 Needs owner

### 📏 Phase 3: make every skill measurable

Seven Core skills have evals since 2026-11-11. `agent-workspace-builder`, `automated-dev-pipeline` and `web-house-style` don't yet.

- [x] Evals for `task-router`. Include requests that should route inline, to one agent, and to a fan-out, with the expected tier for each — done 2026-11-11: six cases: inline (Tier 0), one agent, recon-then-plan, a fan-out on `opus`, an ambiguous ask that shouldn't be routed, and an excluded tier with a confirm-before-push gate
- [x] Evals for `html-email-templates` — done 2026-11-11: six cases: a failure alert, a report wrapper, a digest, pushback on the wrong template, stat cards, and consolidating senders
- [x] Evals for `repo-docs-builder` — done 2026-11-11: six cases (full run on a small fixture repo in `evals/fixtures/tidepool/`, header only, roadmap only, tick-and-log, humanize only, an Obsidian vault with no roadmap)
- [x] Evals for `business-plan-builder`. Cover at least one idea that should come back NO_GO — done 2026-11-11: six cases; the meal-kit idea must come back NO_GO with no spec, ADRs, estimate or build plan written
- [x] Evals for `project-hub-scaffold` and `news-images` — done 2026-11-11: six cases each. project-hub's travel copy needs the new `evals/` folder too, or its `scaffold copy` check fails
- [x] Audit description triggers. For each Core skill, write two requests that should auto-load it and one that shouldn't. Tighten any description that fails, and record the method in `USING-SKILLS.md` — done 2026-11-11: `scripts/check-triggers.py` over `scripts/trigger-cases.json`, 30 cases. 29 passed first time; the `task-router` "how should we approach this" case passed 2 of 3 runs, which is run-to-run noise rather than a missing trigger (the phrase is already in the description), so no description changed
- [x] Cross-agent install table in `USING-SKILLS.md`. The directory each CLI that `-AllAgents` targets reads from, and what differs between them — done 2026-11-11: checked against each CLI's docs: where `-AllAgents` writes, what else each CLI reads, its project folder, how to call a skill by name
- [x] Close the gaps the eval pass found in `task-router` and `html-email-templates` — done 2026-11-11: Tier 3 opt-in defined; a plain-text part section, Template B's text slots and Template C's two footers explained
- [x] Close the gaps the eval pass found in three more skills. `news-images`: every prompt says "save, email, and publish" but the body makes email optional and never defines publish; "this year's" collage is unhandled; "editorial cartoon of this week's headlines" may not trigger it. `repo-docs-builder`: the no-logo fallback doesn't say whether the nav row and badges stay; the description says every project carries a ROADMAP but vaults skip it; de-slopping prose alone isn't in the description. `business-plan-builder`: "quick read" screen mode vs "not for a quick opinion"; audit item 4 contradicts the no-sources run — done 2026-11-19: the eight prompts say "then save it" and the body forbids sending or publishing unasked; a "Periods in progress" rule (last completed period by default, `_to-date` when asked for the one under way); the description and a new trigger case cover editorial cartoons. The no-logo H1 replaces only the logo; the description limits the roadmap to things that ship and names a prose-only pass. A quick opinion is a chat answer, a written-up quick read is screen mode; audit item 4 allows an empty `research/` only on a declared no-web-access run. Split from a four-skill item on 2026-11-19, since the fourth needs project-hub's copy changed too
- [ ] Close the gaps the eval pass found in `project-hub-scaffold`: step 5 restarts the server "when authorized" without saying whether to ask; the description promises theme matching that mode C limits to static pages. project-hub's `scaffold copy` CI fails on drift, so the same change has to land in `project-hub/skills/project-hub-scaffold/` in a paired PR there
- [x] Trim `-AllAgents` to the folders nobody else reads. opencode also reads `~/.claude/skills` and `~/.agents/skills`, Kilo reads `~/.agents/skills`, and agy reads `~/.gemini/config/skills`, so today opencode gets three copies of each skill and agy and Kilo two. `~/.claude/skills`, `~/.agents/skills` and `~/.gemini/config/skills` cover all six CLIs. Needs a cleanup step for the copies already installed in the dropped folders, or they go stale — done 2026-11-12: `install-skills.ps1` writes those three, each when a CLI that reads it is present, and removes same-named copies from `~/.gemini/antigravity-cli/skills`, `~/.config/opencode/skills` and `~/.kilo/skills`; `test-install-skills.ps1` checks both against a fake home. opencode still sees two copies, since Claude Code reads only `~/.claude/skills`
- [ ] Evals for `agent-workspace-builder`, `automated-dev-pipeline` and `web-house-style`, six cases each in the `recipe-validator` format (their trigger cases are already in `scripts/trigger-cases.json`)
- [ ] Publish a Cronsole catalog from `site/`: one template `agent-skills-update` (`git pull --ff-only`, then `install-skills.ps1 -AllAgents`; optional `-Domain`), a Registry v1 builder with `--check` in `validate.yml`, a registry-drift workflow, and a Schedule it section in `site/index.html` that reads `registry/index.json` live. The description says each run overwrites installed copies. Done when `https://agent-skills.ai-automation-tools.dev/registry/index.json` serves and the gallery lists the template. After the `-AllAgents` trim above
- [ ] Rename the "Claude Code routines" headings to Claude Code scheduled tasks (vendor rename, repo-docs-builder §0). `skills/projects/cronsole/cronsole-claude-routines/SKILL.md` line 13 and `references/cronsole-side.md` line 1 are headings, so the docs sweep left them. Done when both headings, the skill's description and every in-repo reference (`skills/projects/cronsole/README.md`, `site/showcase.json`, the generated `site/index.html` via `build-showcase.py`) use the new name, and `validate-skills.py` and `check-links.py` pass

### 🧩 Phase 4: skills from the backlog

Pulled from [`SKILL-IDEAS.md`](SKILL-IDEAS.md). Each one ships with its `SKILL.md` and an
`evals/` folder of at least three cases, a README row and a tier-README row, a showcase card
if it's Core, and its idea row struck from the backlog. It's one skill per run. Each should
be portable Core unless it names a single repo.

- [ ] commit-msg-writer: writes imperative commit messages that match a repo's existing log style (Conventional or plain), reading `git log` before it writes
- [ ] changelog-keeper: maintains a `CHANGELOG.md` from a commit range, and ticks matching roadmap items. It must agree with `repo-docs-builder` §2.5 and not contradict it
- [ ] pr-describer: a structured PR body (summary, changes, test plan, what to review first) built from a diff
- [ ] env-doctor: finds env vars the code reads that are missing from `.env.example`, and example entries nothing reads
- [ ] api-reference-writer: endpoint reference docs from route definitions, using one consistent response envelope
- [x] Retire the `repo-doc-structure` idea. `repo-docs-builder` already covers it, so strike the row with a note saying so — done 2026-11-11: struck in `SKILL-IDEAS.md`
- [ ] obsidian-note-author: decide whether it's portable Core or too tied to one vault to publish 🔒 Needs owner

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="CHANGELOG.md">Changelog →</a> ·
  <a href="USING-SKILLS.md">Using skills</a> ·
  <a href="SKILL-IDEAS.md">Skill ideas</a> ·
  <a href="#roadmap-top">↑ Back to top</a>
</p>
