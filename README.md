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
| [**🍳 recipe-validator**](./Skills/Cooking/recipe-validator/SKILL.md) | Cooking | Validates recipes for food safety, nutrition, quantities, and allergens — a deterministic scanner plus agent judgment. |
| [**📝 readme-builder-mfs**](./Skills/Documentation/readme-builder-mfs/SKILL.md) | Documentation | Builds README files that render flawlessly in both GitHub and Obsidian using pure native markdown. |
| [**🎯 readme-header-mfs**](./Skills/Documentation/readme-header-mfs/SKILL.md) | Documentation | Builds the centered hero-header block (logo, tagline, nav row, badges) at the top of a repo's root README, matching the Live-Apps house style. |
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

### 📝 readme-builder-mfs · _Documentation_

Build professional README files that render flawlessly in both GitHub and Obsidian, using pure native markdown. Favors clean, text-first layouts and adds a diagram only when it genuinely clarifies — never by default.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Documentation/readme-builder-mfs/SKILL.md) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Documentation/readme-builder-mfs/`](./Resources/Skill-Data/Documentation/readme-builder-mfs/README.md) |
| 🖼️ **Screenshots** | [`Images/Screenshots/`](./Resources/Skill-Data/Documentation/readme-builder-mfs/Images/Screenshots/README.md) |
| 🎞️ **GIFs** | [`Images/GIFs/`](./Resources/Skill-Data/Documentation/readme-builder-mfs/Images/GIFs) |

### 🎯 readme-header-mfs · _Documentation_

Build just the hero header at the top of a repo's root README — top anchor, centered logo, two-line tagline, "Explore the docs" link, a nav row, hero badges (`for-the-badge`), and inline tech badges (`flat-square`), closed by a `---`. A narrow companion to `readme-builder-mfs` that keeps every repo opening on the same house style.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Documentation/readme-header-mfs/SKILL.md) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Documentation/readme-header-mfs/`](./Resources/Skill-Data/Documentation/readme-header-mfs/README.md) |
| 📐 **Examples** | [`Examples/`](./Resources/Skill-Data/Documentation/readme-header-mfs/Examples/README.md) — real headers from TaskHub, Agent-Chat, AI-Automation-Library |

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
