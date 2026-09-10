<a id="readme-top"></a>

<h1 align="center">🧩 Agent Skills</h1>

<p align="center">
  <em>Portable capabilities for Claude Code and compatible agents —<br>each one a single <code>SKILL.md</code> the agent loads only when it needs it.</em>
</p>

<p align="center">
  <a href="./Docs/USING-SKILLS.md"><strong>Explore the docs »</strong></a>
</p>

<p align="center">
  <a href="#-skill-catalog">Catalog</a> ·
  <a href="#-using-a-skill">Install</a> ·
  <a href="./Docs/USING-SKILLS.md">Authoring guide</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/skills-8-2ea44f?style=for-the-badge" alt="8 skills">
  <img src="https://img.shields.io/badge/format-SKILL.md-8B5CF6?style=for-the-badge" alt="SKILL.md format">
  <img src="https://img.shields.io/badge/agent-Claude%20Code-D97757?style=for-the-badge" alt="Built for Claude Code">
  <a href="https://github.com/ai-automation-tools"><img src="https://img.shields.io/badge/org-ai--automation--tools-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="ai-automation-tools"></a>
</p>

---

A **Skill** is a folder with a `SKILL.md` in it: YAML frontmatter naming the skill and saying
when it applies, then the instructions the agent reads once it decides to load it. Nothing sits
in the agent's context until that moment, so a library this size costs nothing to keep installed.

Every skill here is **self-contained**. Copy one folder into your agent's skills directory and it
works — no shared runtime, no config, nothing to register.

## 📦 Skill Catalog

Every skill lives in its own folder under a category: `Skills/<Category>/<skill-name>/`. Start here for the one-line summary, then jump to the detailed section below for links to each skill's instructions, helpers, and supporting data.

| Skill | Category | What it does |
|:---|:---|:---|
| [**📈 business-planning-mfs**](./Skills/Business/business-planning-mfs/SKILL.md) | Business | Runs a business idea through eight analysis passes — sizing, competitors, an ROI model, a decision memo, then spec/architecture/estimate/plan if the memo greenlights it — and writes the result out as a linked doc repo in the `repo-builder-mfs` style. |
| [**✉️ email-template-mfs**](./Skills/Automation/email-template-mfs/SKILL.md) | Automation | Three reusable HTML email templates — a plain inline-styled notification/footer, a dark-banner report, and an inline light-card digest — with guidance on which applies to a given automation email and how they combine. |
| [**🚦 task-router**](./Skills/Automation/task-router/SKILL.md) | Automation | Sizes a request before any work starts — answer inline, hand it to one subagent, recon-then-plan, or fan out — then picks the model to run it on under a subscription-only policy (docs and basic research are Sonnet, complex work is Opus, Fable never). |
| [**🍳 recipe-validator**](./Skills/Cooking/recipe-validator/SKILL.md) | Cooking | Validates recipes for food safety, nutrition, quantities, and allergens — a deterministic scanner plus agent judgment. |
| [**🏗️ repo-builder-mfs**](./Skills/Documentation/repo-builder-mfs/SKILL.md) | Documentation | The end-to-end repo/documentation builder — a clean layout (web-app artifacts under `src/`/`site/`, not the root), a house-style README at every level (root logo hero, folder/section headers), a navigable docs tree wired with down-links and up-links, and a built-in humanizer pass so the prose doesn't read like a chatbot wrote it. Renders in both GitHub and Obsidian using pure native markdown. |
| [**🖼️ news-images**](./Skills/Image-Gen/news-images/SKILL.md) | Image-Gen | Generates cartoon-editorial news collages and montages across daily/weekly/monthly/yearly cadences. |
| [**🌐 project-hub-scaffold-mfs**](./Skills/Web/project-hub-scaffold-mfs/SKILL.md) | Web | Scaffolds a new browsable HTML project console matching an existing "Hub" install's design — same theme, sidebar tree, and navigation — by adding a workspace to its shared server, creating a portable installation, or matching the visual design of a static page. |
| [**🎬 video-downloader**](./Skills/Media/video-downloader/SKILL.md) | Media | Downloads YouTube videos with quality/format control (mp4/webm/mkv, audio-only MP3), hardened for Windows with cookie extraction for 403-blocked downloads. |

## 🧩 Skills

### 📈 business-planning-mfs · _Business_

Hand it a business idea — a one-line hunch or a finished proposal — and it runs the whole pipeline: bottom-up market sizing, competitor teardowns with graded evidence, a runnable ROI model whose sensitivity sweep is the actual deliverable, and a decision memo that makes the call and names what would prove it wrong. **That memo is a gate.** Only if it says *build* does the skill go on to write a product spec, costed architecture ADRs, a ranged build estimate, and a sliced build plan. A no-go is a complete run.

The rule underneath all of it: every number traces to a source or carries an `[assum]` tag, because the dominant failure of an LLM doing business analysis is inventing a plausible market size that gets cited downstream until the fabrication is load-bearing. Output is a folder of linked markdown in the [`repo-builder-mfs`](./Skills/Documentation/repo-builder-mfs/SKILL.md) house style — verdict on the front page, an index in every folder, humanized prose.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Business/business-planning-mfs/SKILL.md) |
| 📚 **References** | [`analysis-passes.md`](./Skills/Business/business-planning-mfs/references/analysis-passes.md) — the eight passes · [`evidence-rules.md`](./Skills/Business/business-planning-mfs/references/evidence-rules.md) — tags, A–D grading, the research line · [`output-templates.md`](./Skills/Business/business-planning-mfs/references/output-templates.md) — every document skeleton + the humanizer pass |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Business/business-planning-mfs/`](./Resources/Skill-Data/Business/business-planning-mfs/README.md) |
| 📐 **Examples** | [Target output tree](./Resources/Skill-Data/Business/business-planning-mfs/Examples/target-output-tree.md) · [worked root README](./Resources/Skill-Data/Business/business-planning-mfs/Examples/example-root-README.md) |

> [!NOTE]
> The eight passes are condensed from a set of standard business-analysis disciplines (market sizing, competitive intelligence, ROI modeling, decision memos, product spec, technical architecture, build estimation, shipping discipline).

### ✉️ email-template-mfs · _Automation_

Three reusable HTML email templates for automations, alerts, and reports: a plain inline-styled notification body + shared footer (system alerts), a dark banner/wrapper report document (a generated analysis/report), and an inline light-card digest (a multi-item newsletter or briefing). Documents which template applies to a given email and how they combine (report as attachment/link vs. inlined digest).

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Automation/email-template-mfs/SKILL.md) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Automation/email-template-mfs/`](./Resources/Skill-Data/Automation/email-template-mfs/README.md) |
| 📐 **Examples** | [`Examples/`](./Resources/Skill-Data/Automation/email-template-mfs/Examples/README.md) — a real, live-verified Template C email body + the notes from checking the skill against it |

### 🚦 task-router · _Automation_

Decides **how much machinery a request deserves** before the work starts, then picks the model to run it on. Four shapes — answer it inline with no agent at all, hand it to one subagent, do recon or a plan first and then act, or fan out across parallel agents — chosen from six countable signals rather than a feel for how big the job sounds: do I know which files change, how many, how many independent dimensions, is it reversible, would two readings give different work, does the answer already exist.

Two rules do most of the work. **Risk overrides size** — a one-line change that deploys to production is not a Tier 0 edit. And **ambiguity is not complexity** — if two readings of the request produce different work, that is a question to ask, not a bigger fan-out to launch.

The model policy is a hard constraint, not a preference: `haiku` only for mechanical no-judgment passes, `sonnet` as the default and specifically for **documentation updates and basic research** (both read as cheap and neither is), `opus` for genuinely complex work, and **`fable` for nothing, ever** — it is the one tier that bills as direct API tokens instead of against the subscription, and the Agent tool accepts it silently.

The skill also serves as the **authorization to delegate**: the standing rule elsewhere is not to spawn subagents unless something explicitly asks, so without this skill the higher tiers are unreachable — and it only authorizes the tier it actually selects.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Automation/task-router/SKILL.md) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Automation/task-router/`](./Resources/Skill-Data/Automation/task-router/README.md) |

> [!NOTE]
> The skill's **§6 Calibration** table doubles as its test fixture — fourteen worked examples spanning every tier. Check a disputed routing decision against the nearest row before overriding it.

### 🍳 recipe-validator · _Cooking_

Validate recipes for food safety, nutrition, quantities, allergen labeling, and coherence — a hybrid of a deterministic scanner plus agent judgment, reporting findings ranked by severity with concrete fixes.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Cooking/recipe-validator/SKILL.md) |
| 🐍 **Script** | [`scripts/scan_recipes.py`](./Skills/Cooking/recipe-validator/scripts/scan_recipes.py) |
| 📚 **References** | [`food-safety.md`](./Skills/Cooking/recipe-validator/references/food-safety.md) · [`nutrition-and-quality.md`](./Skills/Cooking/recipe-validator/references/nutrition-and-quality.md) |
| 🧪 **Evals** | [`evals/evals.json`](./Skills/Cooking/recipe-validator/evals/evals.json) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Cooking/recipe-validator/`](./Resources/Skill-Data/Cooking/recipe-validator/README.md) |
| 📊 **Example output** | [Example-Report-1](./Resources/Skill-Data/Cooking/recipe-validator/Examples/Example-Report-1/recipe-validation-report_2026-07-08.md) |

### 🏗️ repo-builder-mfs · _Documentation_

The **mega** documentation skill: builds or reorganizes a whole repo, project folder, doc library, or Obsidian vault end to end. Four concerns in one file — **layout** (for a web-app repo, all web/app artifacts under `src/` for framework apps or `site/` for static sites, keeping the root to documentation + meta + required config); **docs topology** (the recursive tree of `README.md` index files — root → `docs/` hub → each sub-folder README → the final documents — wired with down-links and up-links so every folder is a two-way door, plus a 9-point navigability audit); **house style** (the logo hero atop a repo-root README, the centered emoji-title section header atop every other one, bodies, leftmost-link catalog tables, footers); and **voice** (§0, a humanizer pass over every sentence it writes — no `-ing` tails, no *comprehensive/seamless/robust*, no "serves as" where "is" works, with the emoji headers and badges explicitly exempt because they're navigation). Pure native markdown, renders in both GitHub and Obsidian; diagrams off by default.

Scale it to the job: a whole repo, one README at any level, just the top header block, or just the index/link structure.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Documentation/repo-builder-mfs/SKILL.md) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Documentation/repo-builder-mfs/`](./Resources/Skill-Data/Documentation/repo-builder-mfs/README.md) |
| 📐 **Examples** | [`Examples/`](./Resources/Skill-Data/Documentation/repo-builder-mfs/Examples/README.md) — worked headers, the annotated docs tree + a completed Tier-3 index, and the target web-app layout |
| 🖼️ **Screenshots** | [`Images/Screenshots/`](./Resources/Skill-Data/Documentation/repo-builder-mfs/Images/Screenshots/README.md) |
| 🎞️ **GIFs** | [`Images/GIFs/`](./Resources/Skill-Data/Documentation/repo-builder-mfs/Images/GIFs) |

> [!NOTE]
> Absorbed `readme-builder-mfs`, `readme-header-mfs`, and `repo-docs-mfs` on 2026-08-05 — those three are retired and their content lives here.

### 🖼️ news-images · _Image-Gen_

Generate cartoon-editorial news collages (6-panel grids) and news montages (single scenes) for daily, weekly, monthly, and yearly cadences.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Image-Gen/news-images/SKILL.md) |
| 🧾 **Prompts** | [`prompts/`](./Skills/Image-Gen/news-images/prompts) — [daily](./Skills/Image-Gen/news-images/prompts/daily-collage.md) · [weekly](./Skills/Image-Gen/news-images/prompts/weekly-collage.md) · [monthly](./Skills/Image-Gen/news-images/prompts/monthly-collage.md) · [yearly](./Skills/Image-Gen/news-images/prompts/yearly-collage.md) (collage + montage each) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Image-Gen/news-images/`](./Resources/Skill-Data/Image-Gen/news-images/README.md) |

### 🌐 project-hub-scaffold-mfs · _Web_

Scaffolds a new browsable HTML project console in the same look and behavior as an
existing "Hub" install: a dark terminal-styled theme, a sidebar file tree, header search,
hash-routed navigation with in-page Back/Forward, and live markdown rendering. Covers
three modes — add a workspace to the shared server (the default), copy the
whole engine into a project that can't depend on that engine's path, or lift just the
visual language for a static page with no live scan. The reference docs hold the extracted color tokens,
layout rules, keyboard shortcuts, and `hub.config.json` schema so scaffolding a new one
doesn't require re-reading the ~2,500-line source each time.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Web/project-hub-scaffold-mfs/SKILL.md) |
| 💻 **Script** | [`scripts/scaffold-hub.ps1`](./Skills/Web/project-hub-scaffold-mfs/scripts/scaffold-hub.ps1) |
| 📚 **References** | [`design-system.md`](./Skills/Web/project-hub-scaffold-mfs/references/design-system.md) — theme tokens, layout, keyboard shortcuts · [`config-schema.md`](./Skills/Web/project-hub-scaffold-mfs/references/config-schema.md) — server/workspace configs, endpoints, watcher, testing · [`current-features.md`](./Skills/Web/project-hub-scaffold-mfs/references/current-features.md) — current reader, search, reports, pictures, bookmarks and folder views |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Web/project-hub-scaffold-mfs/`](./Resources/Skill-Data/Web/project-hub-scaffold-mfs/README.md) |

> [!NOTE]
> Built from a live `Hub/` reference implementation. No automatic sync — if that source
> changes in a way that contradicts this skill's `references/`, fold the change in by
> hand (same convention as the other `-mfs` skills' keep-synced notes in `CLAUDE.md`).

### 🎬 video-downloader · _Media_

Download YouTube videos with control over quality (`best` down to `360p`), container
(`mp4`/`webm`/`mkv`), or audio-only MP3 extraction. Derived from the upstream
`video-downloader` skill in `awesome-claude-skills`, with Windows-specific fixes: an
output directory that actually exists locally (`~/Downloads`, instead of the sandbox-only
path upstream hardcodes), UTF-8 stdout so a status emoji doesn't crash the console,
JS-runtime auto-detection for yt-dlp's challenge solving, and cookie extraction for the
`403 Forbidden` failures a stale extractor causes.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Media/video-downloader/SKILL.md) |
| 🐍 **Script** | [`scripts/download_video.py`](./Skills/Media/video-downloader/scripts/download_video.py) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Media/video-downloader/`](./Resources/Skill-Data/Media/video-downloader/README.md) |

> [!NOTE]
> Provenance and the exact list of local fixes are in the skill's own **Provenance**
> section — re-syncing the upstream clone won't overwrite this copy, but it won't deliver
> the fixes either.

## 📖 Docs

Usage guides and the build backlog live under [`Docs/`](./Docs).

| Doc | Description |
|:---|:---|
| [**Using Skills**](./Docs/USING-SKILLS.md) | How to install, invoke, and author skills — plus what a `SKILL.md` looks like. |
| [**Skill Ideas**](./Docs/SKILL-IDEAS.md) | Running backlog of candidate skills to build. |

## 🧰 Resources

Supporting material that lives **outside** the portable skill folders, under [`Resources/`](./Resources).

| Folder | Contents |
|:---|:---|
| [**Skill-Data**](./Resources/Skill-Data) | Per-skill examples, sample outputs, and image assets. Mirrors the `Skills/` category tree (`Skill-Data/<Category>/<skill-name>/`). |
| [**Links**](./Resources/Links) | Curated external references for building Agent Skills. |

Categories group related skills. Current categories: **Automation** (job/email/notification templates), **Business** (analysis, strategy, planning), **Cooking** (recipe tooling), **Documentation** (READMEs, guides, reference docs), **Image-Gen** (image-generation workflows), **Media** (audio/video tooling), and **Web** (browsable HTML project consoles). Add a new category folder under `Skills/` whenever a skill doesn't fit an existing one.

> [!NOTE]
> A skill's own `<skill-name>/` folder is the **portable unit** — copy it into an agent's skills directory and it works standalone. Bulky examples, screenshots, and sample outputs live under [`Resources/Skill-Data/`](./Resources) instead, so the portable skill stays lean.

A `SKILL.md` starts with YAML frontmatter naming the skill and describing when to use it, followed by the instructions the agent loads on invocation:

```markdown
---
name: skill-name
description: One-line summary used to decide when the skill applies.
---

Instructions for the agent...
```

## 🚀 Using a Skill

1. Point your agent's skills directory at this repo's [`Skills/`](./Skills) folder, or copy an individual `<skill-name>/` folder into it.
2. Invoke the skill by name — in Claude Code, skills surface as `/skill-name`.
3. For install locations, invocation details, and the full authoring workflow, see [**Using Skills**](./Docs/USING-SKILLS.md).

## 🔗 Related repositories

Part of the [**ai-automation-tools**](https://github.com/ai-automation-tools) organization.

| Repo | How it relates |
|:---|:---|
| [**project-hub**](https://github.com/ai-automation-tools/project-hub) | Browsable local console for a CLI-agent workspace. Ships a travel copy of [`project-hub-scaffold-mfs`](./Skills/Web/project-hub-scaffold-mfs/SKILL.md) so the skill works without this repo present — **this repo is the canonical copy**; change it here first. |
| [**Agent-chat**](https://github.com/ai-automation-tools/Agent-chat) | MCP server that lets two CLI agents hold a structured conversation. |
| [**cronsole**](https://github.com/ai-automation-tools/cronsole) | Scheduled-task control plane across Task Scheduler, Claude Code routines and Gemini Triggers. |

---

<p align="center">
  Built for <a href="https://claude.com/claude-code">Claude Code</a> and compatible agents ·
  <a href="./Docs/USING-SKILLS.md">Using Skills</a> ·
  <a href="./CLAUDE.md">Contributor guide</a>
</p>

<p align="right"><sub><a href="#readme-top">back to top</a></sub></p>
