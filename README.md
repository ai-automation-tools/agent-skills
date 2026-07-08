# My Custom Skills

<p align="center">
  <img src="https://img.shields.io/badge/Type-Agent%20Skills-8B5CF6?style=for-the-badge" alt="Agent Skills">
  <img src="https://img.shields.io/badge/Owner-michaelschecht-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="Owner">
  <img src="https://img.shields.io/badge/Visibility-Private-6B7280?style=for-the-badge" alt="Private">
</p>

A personal collection of custom **Agent Skills** — reusable, model-invocable capabilities packaged as `SKILL.md` files with YAML frontmatter. Each skill teaches an agent (Claude Code and compatible CLIs) how to perform a specific task well.

## 📦 Skills

Skills are grouped by **category** under [`Skills/`](./Skills); each lives in its own folder (`Skills/<Category>/<skill-name>/`). Each skill below has its own table linking every part of it in the repo — the skill instructions, its helpers, and its supporting data.

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

Build professional README files that render flawlessly in both GitHub and Obsidian, using pure native markdown (no diagrams).

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Documentation/readme-builder-mfs/SKILL.md) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Documentation/readme-builder-mfs/`](./Resources/Skill-Data/Documentation/readme-builder-mfs/README.md) |
| 🖼️ **Screenshots** | [`Images/Screenshots/`](./Resources/Skill-Data/Documentation/readme-builder-mfs/Images/Screenshots/README.md) |
| 🎞️ **GIFs** | [`Images/GIFs/`](./Resources/Skill-Data/Documentation/readme-builder-mfs/Images/GIFs) |

### 🖼️ News-Images · _Image-Gen_

Generate cartoon-editorial news collages (6-panel grids) and news montages (single scenes) for daily, weekly, monthly, and yearly cadences.

| Part | Link |
|:---|:---|
| 📄 **Skill** | [`SKILL.md`](./Skills/Image-Gen/News-Images/SKILL.md) |
| 🧾 **Prompts** | [`prompts/`](./Skills/Image-Gen/News-Images/prompts) — [daily](./Skills/Image-Gen/News-Images/prompts/daily-collage.md) · [weekly](./Skills/Image-Gen/News-Images/prompts/weekly-collage.md) · [monthly](./Skills/Image-Gen/News-Images/prompts/monthly-collage.md) · [yearly](./Skills/Image-Gen/News-Images/prompts/yearly-collage.md) (collage + montage each) |
| 🗂️ **Skill-Data** | [`Resources/Skill-Data/Image-Gen/News-Images/`](./Resources/Skill-Data/Image-Gen/News-Images/README.md) |

## 📖 Docs

Usage guides and skill ideas live under [`Docs/`](./Docs).

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

## 🗂️ Structure

```
My-Custom-Skills/
├── README.md                       # this index
├── CLAUDE.md                       # guidance for agents maintaining the repo
├── Skills/
│   └── <Category>/                 # e.g. Cooking, Documentation, Image-Gen
│       └── <skill-name>/
│           ├── SKILL.md            # frontmatter (name, description) + instructions
│           ├── scripts/            # optional deterministic helpers
│           ├── references/         # optional standards the SKILL cites
│           ├── prompts/            # optional prompt templates
│           └── evals/              # optional tracked test cases
├── Docs/
│   ├── USING-SKILLS.md             # install / invoke / author guide
│   └── SKILL-IDEAS.md              # backlog of candidate skills
└── Resources/                      # supporting material that lives OUTSIDE the portable skills
    ├── Skill-Data/                 # per-skill examples & assets, mirrors the Skills/ tree
    └── Links/                      # curated external references for skill-building
```

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

Point your agent's skills directory at this repo's [`Skills/`](./Skills) folder (or copy an individual skill folder into it), then invoke by name. In Claude Code, skills surface as `/skill-name`.

See [**Using Skills**](./Docs/USING-SKILLS.md) for install locations, invocation, and the full authoring workflow.
