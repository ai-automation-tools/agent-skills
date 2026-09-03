# My Custom Skills

<p align="center">
  <img src="https://img.shields.io/badge/Type-Agent%20Skills-8B5CF6?style=for-the-badge" alt="Agent Skills">
  <img src="https://img.shields.io/badge/Skills-4-2ea44f?style=for-the-badge" alt="4 Skills">
  <img src="https://img.shields.io/badge/Owner-michaelschecht-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="Owner">
  <img src="https://img.shields.io/badge/Visibility-Private-6B7280?style=for-the-badge" alt="Private">
</p>

## 📦 Skill Catalog

Every skill lives in its own folder under a category: `Skills/<Category>/<skill-name>/`. Start here for the one-line summary, then jump to the detailed section below for links to each skill's instructions, helpers, and supporting data.

| Skill | Category | What it does |
|:---|:---|:---|
| [**📈 business-planning-mfs**](./Skills/Business/business-planning-mfs/SKILL.md) | Business | Runs a business idea through eight analysis passes — sizing, competitors, an ROI model, a decision memo, then spec/architecture/estimate/plan if the memo greenlights it — and writes the result out as a linked doc repo in the `repo-builder-mfs` style. |
| [**✉️ email-template-mfs**](./Skills/Automation/email-template-mfs/SKILL.md) | Automation | House email templates for Mike's AI Lab automations — a plain inline-styled notification/footer template, a dark-banner report template, and an inline light-card digest template — with guidance on which applies and how they combine. |
| [**🍳 recipe-validator**](./Skills/Cooking/recipe-validator/SKILL.md) | Cooking | Validates recipes for food safety, nutrition, quantities, and allergens — a deterministic scanner plus agent judgment. |
| [**🏗️ repo-builder-mfs**](./Skills/Documentation/repo-builder-mfs/SKILL.md) | Documentation | The end-to-end repo/documentation builder — a clean layout (web-app artifacts under `src/`/`site/`, not the root), a house-style README at every level (root logo hero, folder/section headers), a navigable docs tree wired with down-links and up-links, and a built-in humanizer pass so the prose doesn't read like a chatbot wrote it. Renders in both GitHub and Obsidian using pure native markdown. |
| [**🖼️ news-images**](./Skills/Image-Gen/news-images/SKILL.md) | Image-Gen | Generates cartoon-editorial news collages and montages across daily/weekly/monthly/yearly cadences. |

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
> The eight passes are condensed from the `Mike_Business` Claude Code project template (`Agent-Resources/Templates/CLI_Projects/Claude_Code/Mike_Business/.claude/skills/`). No automatic sync — see the note in [`CLAUDE.md`](./CLAUDE.md).

### ✉️ email-template-mfs · _Automation_

House email templates for Mike's AI Lab automations, alerts, and reports: a plain inline-styled notification body + shared footer (the AI-Automation-Library fleet's IAM/artifact emails), a dark banner/wrapper report document (Portfolio Pilot), and an inline light-card digest (the n8n newsletter workflows — IAM, Cybersecurity, Energy, Geopolitics briefings). Documents which template applies to a given email, how they combine (report as attachment/link vs. inlined digest), and the exact source files each was reverse-engineered from.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Automation/email-template-mfs/SKILL.md) |

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
| 📐 **Examples** | [`Examples/`](./Resources/Skill-Data/Documentation/repo-builder-mfs/Examples/README.md) — real headers (TaskHub, Agent-Chat, AI-Automation-Library), the annotated docs tree + a completed Tier-3 index, and the target web-app layout |
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

Categories group related skills. Current categories: **Automation** (job/email/notification templates), **Business** (analysis, strategy, planning), **Cooking** (recipe tooling), **Documentation** (READMEs, guides, reference docs), and **Image-Gen** (image-generation workflows). Add a new category folder under `Skills/` whenever a skill doesn't fit an existing one.

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

<p align="center">
  Maintained by <a href="https://github.com/michaelschecht">michaelschecht</a> · Built for <a href="https://claude.com/claude-code">Claude Code</a> &amp; compatible agents · See <a href="./CLAUDE.md">CLAUDE.md</a> for contributor guidance
</p>
