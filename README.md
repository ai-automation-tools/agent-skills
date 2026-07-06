# My Custom Skills

<p align="center">
  <img src="https://img.shields.io/badge/Type-Agent%20Skills-8B5CF6?style=for-the-badge" alt="Agent Skills">
  <img src="https://img.shields.io/badge/Owner-michaelschecht-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="Owner">
  <img src="https://img.shields.io/badge/Visibility-Private-6B7280?style=for-the-badge" alt="Private">
</p>

A personal collection of custom **Agent Skills** — reusable, model-invocable capabilities packaged as `SKILL.md` files with YAML frontmatter. Each skill teaches an agent (Claude Code and compatible CLIs) how to perform a specific task well.

## 📦 Skills

Skills are grouped by **category** under [`Skills/`](./Skills); each skill lives in its own folder inside its category (`Skills/<Category>/<skill-name>/`).

### 📝 Documentation

| Skill | Description |
|:---|:---|
| [**readme-builder-mfs**](./Skills/Documentation/readme-builder-mfs/SKILL.md) | Build professional README files that render flawlessly in both GitHub and Obsidian, using pure native markdown (no diagrams). |

### 🖼️ Image-Gen

| Skill | Description |
|:---|:---|
| [**News-Images**](./Skills/Image-Gen/News-Images/SKILL.md) | Generate cartoon-editorial news collages (6-panel grids) and news montages (single scenes) for daily, weekly, monthly, and yearly cadences. |

## 📖 Docs

Usage guides and skill ideas live under [`Docs/`](./Docs).

| Doc | Description |
|:---|:---|
| [**Using Skills**](./Docs/USING-SKILLS.md) | How to install, invoke, and author skills — plus what a `SKILL.md` looks like. |
| [**Skill Ideas**](./Docs/SKILL-IDEAS.md) | Running backlog of candidate skills to build. |

## 🗂️ Structure

```
My-Custom-Skills/
├── README.md
├── Skills/
│   └── <Category>/            # e.g. Documentation, Image-Gen
│       └── <skill-name>/
│           └── SKILL.md       # frontmatter (name, description) + instructions
└── Docs/
    ├── USING-SKILLS.md
    └── SKILL-IDEAS.md
```

Categories group related skills. Current categories: **Documentation** (READMEs, guides, reference docs) and **Image-Gen** (image-generation workflows). Add a new category folder under `Skills/` whenever a skill doesn't fit an existing one.

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
