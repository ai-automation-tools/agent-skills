# Using Skills

How to install, invoke, and author the custom Agent Skills in this repo.

## What a Skill is

A **Skill** is a reusable, model-invocable capability packaged as a single `SKILL.md` file. It teaches an agent (Claude Code and compatible CLIs) how to perform a specific task well. The agent loads the skill's instructions only when the skill is invoked, so skills keep specialized knowledge out of the base context until it's needed.

Skills are grouped by **category** under [`../Skills/`](../Skills); each skill lives in its own folder inside its category:

```
Skills/
└── <Category>/          # e.g. Documentation, Image-Gen
    └── <skill-name>/
        └── SKILL.md      # YAML frontmatter (name, description) + instructions
```

Categories are just folders that group related skills (e.g. `Documentation`, `Image-Gen`). Add a new category folder when a skill doesn't fit an existing one.

## Anatomy of a SKILL.md

```markdown
---
name: skill-name
description: One-line summary that tells the agent WHEN this skill applies.
---

Instructions the agent loads on invocation...
```

- **`name`** — kebab-case, unique. This is what you type to invoke it (`/skill-name` in Claude Code).
- **`description`** — the single most important line. The agent reads *only* the description to decide whether to load the skill, so it must clearly state the trigger conditions ("Use when…"). Lead with capability, then triggers.
- **Body** — the full instructions, principles, checklists, and anti-patterns. Loaded only after invocation, so it can be as detailed as needed.

## Installing / making a skill available

Skills are picked up from an agent's skills directory. Two options:

1. **Point at this repo** — configure your agent's skills path to include this repo's `Skills/` folder.
2. **Copy an individual skill** — copy a single `<skill-name>/` folder (the leaf folder, not its category) into your agent's skills directory.

> [!NOTE]
> The category folders (`Documentation/`, `Image-Gen/`) are a repo-organization convention. Most agents discover skills by the leaf `<skill-name>/` folder that contains the `SKILL.md`, so when copying a skill out, copy that leaf folder — the category level doesn't need to be preserved.

For **Claude Code**, place (or symlink) a skill folder under one of:

| Scope | Location |
|:---|:---|
| Personal (all projects) | `~/.claude/skills/<skill-name>/SKILL.md` |
| Project (shared via repo) | `<project>/.claude/skills/<skill-name>/SKILL.md` |

The folder name should match the skill's `name`. Restart or reload the agent so it re-scans the skills directory.

## Invoking a skill

- **Explicitly** — type `/<skill-name>` in Claude Code (e.g. `/readme-builder-mfs`).
- **Automatically** — the agent may load a skill on its own when your request matches the skill's `description`. This is why a precise, trigger-rich description matters.

## Authoring a new skill

1. Create `Skills/<Category>/<skill-name>/SKILL.md` — put it in the category folder that fits (e.g. `Documentation`, `Image-Gen`), or add a new category folder if none fits.
2. Write the frontmatter — a unique `name` and a description that leads with the capability and names the trigger conditions.
3. Write the body: purpose, when-to-use, principles, a concrete execution checklist, and explicit anti-patterns. Concrete examples beat abstract advice.
4. Keep it self-contained — the agent won't have your surrounding conversation when the skill loads.
5. Add a row to the matching category table in the repo [`../README.md`](../README.md) (create the category section if it's new).
6. If it's worth documenting further (design rationale, longer usage notes), add a doc here in `Docs/`.

> [!TIP]
> The [`readme-builder-mfs`](../Skills/Documentation/readme-builder-mfs/SKILL.md) skill is a good reference implementation — it shows the frontmatter + when-to-use + principles + checklist + anti-patterns structure.

## Testing a skill

- Invoke it explicitly (`/<skill-name>`) on a real task and confirm the output follows the skill's rules.
- Check auto-invocation: phrase a request that should match the `description` and see whether the agent loads the skill unprompted. If it doesn't, tighten the trigger wording in the description.
