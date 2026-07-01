# My Custom Skills

<p align="center">
  <img src="https://img.shields.io/badge/Type-Agent%20Skills-8B5CF6?style=for-the-badge" alt="Agent Skills">
  <img src="https://img.shields.io/badge/Owner-michaelschecht-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="Owner">
  <img src="https://img.shields.io/badge/Visibility-Private-6B7280?style=for-the-badge" alt="Private">
</p>

A personal collection of custom **Agent Skills** — reusable, model-invocable capabilities packaged as `SKILL.md` files with YAML frontmatter. Each skill teaches an agent (Claude Code and compatible CLIs) how to perform a specific task well.

## 📦 Skills

| Skill | Description |
|:---|:---|
| [**readme-builder-mfs**](./Documentation/readme-builder-mfs/SKILL.md) | Build professional README files that render flawlessly in both GitHub and Obsidian, using pure native markdown (no diagrams). |

## 🗂️ Structure

Each skill lives in its own folder containing a `SKILL.md` file:

```
My-Custom-Skills/
└── <skill-name>/
    └── SKILL.md   # frontmatter (name, description) + instructions
```

A `SKILL.md` starts with YAML frontmatter naming the skill and describing when to use it, followed by the instructions the agent loads on invocation:

```markdown
---
name: skill-name
description: One-line summary used to decide when the skill applies.
---

Instructions for the agent...
```

## 🚀 Using a Skill

Point your agent's skills directory at this repo (or copy an individual skill folder into it), then invoke by name. In Claude Code, skills surface as `/skill-name`.
