# My Custom Skills

<p align="center">
  <img src="https://img.shields.io/badge/Type-Agent%20Skills-8B5CF6?style=for-the-badge" alt="Agent Skills">
  <img src="https://img.shields.io/badge/Skills-6-2ea44f?style=for-the-badge" alt="6 Skills">
  <img src="https://img.shields.io/badge/Owner-michaelschecht-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="Owner">
  <img src="https://img.shields.io/badge/Visibility-Private-6B7280?style=for-the-badge" alt="Private">
</p>

## 📦 Skill Catalog

Every skill lives in its own folder under a category: `Skills/<Category>/<skill-name>/`. Start here for the one-line summary, then jump to the detailed section below for links to each skill's instructions, helpers, and supporting data.

| Skill | Category | What it does |
|:---|:---|:---|
| [**🍳 recipe-validator**](./Skills/Cooking/recipe-validator/SKILL.md) | Cooking | Validates recipes for food safety, nutrition, quantities, and allergens — a deterministic scanner plus agent judgment. |
| [**🏗️ repo-builder-mfs**](./Skills/Documentation/repo-builder-mfs/SKILL.md) | Documentation | The end-to-end repo/documentation builder — a clean layout (web-app artifacts under `src/`/`site/`, not the root), a house-style README at every level (root logo hero, folder/section headers), and a navigable docs tree wired with down-links and up-links. Renders flawlessly in both GitHub and Obsidian using pure native markdown. |
| [**🖼️ News-Images**](./Skills/Image-Gen/News-Images/SKILL.md) | Image-Gen | Generates cartoon-editorial news collages and montages across daily/weekly/monthly/yearly cadences. |

## 🧩 Skills

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

The **mega** documentation skill: builds or reorganizes a whole repo, project folder, doc library, or Obsidian vault end to end. Three concerns in one file — **layout** (for a web-app repo, all web/app artifacts under `src/` for framework apps or `site/` for static sites, keeping the root to documentation + meta + required config); **docs topology** (the recursive tree of `README.md` index files — root → `docs/` hub → each sub-folder README → the final documents — wired with down-links and up-links so every folder is a two-way door, plus an 8-point navigability audit); and **house style** (the logo hero atop a repo-root README, the centered emoji-title section header atop every other one, bodies, leftmost-link catalog tables, footers). Pure native markdown, renders in both GitHub and Obsidian; diagrams off by default.

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

### 🖼️ News-Images · _Image-Gen_

Generate cartoon-editorial news collages (6-panel grids) and news montages (single scenes) for daily, weekly, monthly, and yearly cadences.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Image-Gen/News-Images/SKILL.md) |
| 🧾 **Prompts** | [`prompts/`](./Skills/Image-Gen/News-Images/prompts) — [daily](./Skills/Image-Gen/News-Images/prompts/daily-collage.md) · [weekly](./Skills/Image-Gen/News-Images/prompts/weekly-collage.md) · [monthly](./Skills/Image-Gen/News-Images/prompts/monthly-collage.md) · [yearly](./Skills/Image-Gen/News-Images/prompts/yearly-collage.md) (collage + montage each) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Image-Gen/News-Images/`](./Resources/Skill-Data/Image-Gen/News-Images/README.md) |

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

Categories group related skills. Current categories: **Cooking** (recipe tooling), **Documentation** (READMEs, guides, reference docs), and **Image-Gen** (image-generation workflows). Add a new category folder under `Skills/` whenever a skill doesn't fit an existing one.

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
