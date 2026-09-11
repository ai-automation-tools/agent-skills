# Using Skills

How to install, invoke, and author the custom Agent Skills in this repo.

## What a Skill is

A **Skill** is a reusable, model-invocable capability packaged as a single `SKILL.md` file. It teaches an agent (Claude Code and compatible CLIs) how to perform a specific task well. The agent loads the skill's instructions only when the skill is invoked, so skills keep specialized knowledge out of the base context until it's needed.

Skills sit in **two tiers** under [`../Skills/`](../Skills), and they do not install to the same place:

```
Skills/
├── Core/                    # portable — installs to ~/.claude/skills
│   └── <Category>/          # e.g. Business, Documentation, Image-Gen
│       └── <skill-name>/
│           └── SKILL.md     # YAML frontmatter (name, description) + instructions
└── Projects/                # welded to one org repo — installs into THAT repo
    └── <repo-slug>/         # agent-chat · cronsole · edge-radar · …
        └── <skill-name>/
            └── SKILL.md
```

One question decides the tier: **would you invoke this from a repo other than the one it was
written for?** Yes → [`Core`](../Skills/Core/README.md). No → [`Projects`](../Skills/Projects/README.md).
The test is about where you invoke it, not what it is about — `project-hub-scaffold` is Core
despite being named for an org product, because you run it from whatever repo is *getting* a hub.

Categories inside `Core/` just group related skills. Add one when a skill fits none of them.

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

Skills are picked up from an agent's skills directory. Three options:

1. **Run the install script (recommended for Claude Code)** — from the repo root, run the bundled installer. It mirrors every leaf skill folder into `~/.claude/skills/<name>/` (whole folder, so `scripts/`/`references/`/`prompts/`/`evals/` come along; local `reports/` output never does):

   ```powershell
   pwsh scripts/install-skills.ps1                          # Core tier -> ~/.claude/skills
   pwsh scripts/install-skills.ps1 -Core -Skill recipe-validator   # just one
   pwsh scripts/install-skills.ps1 -List                    # every skill, with its tier
   pwsh scripts/install-skills.ps1 -WhatIf                  # dry run

   # other agents that read a skills directory
   pwsh scripts/install-skills.ps1 -Destination ~/.codex/skills
   pwsh scripts/install-skills.ps1 -Destination ~/.gemini/skills

   # project tier goes into the repo it belongs to, never user scope
   pwsh scripts/install-skills.ps1 -Project cronsole -Destination D:/repos/cronsole/.claude/skills
   ```

   A bare run installs **Core only**, so a project skill cannot leak into user scope by accident.
   Re-run it after editing any skill. Restart the Claude Code session to reload the catalog.
2. **Point at this repo** — configure your agent's skills path to include this repo's `Skills/Core/` folder.
3. **Copy an individual skill** — copy a single `<skill-name>/` folder (the leaf folder, not its tier or category) into your agent's skills directory.

> [!NOTE]
> Tier and category folders are a repo-organization convention. Agents discover skills by the leaf `<skill-name>/` folder containing the `SKILL.md`, so when copying one out, copy that leaf — the levels above it don't need preserving.
>
> That flattening is also why **skill names must be unique across the whole repo**, both tiers included: two skills named the same would overwrite each other in the skills directory. The install script throws on a collision rather than letting it happen quietly.

For **Claude Code**, place (or symlink) a skill folder under one of:

| Scope | Location |
|:---|:---|
| Personal (all projects) | `~/.claude/skills/<skill-name>/SKILL.md` |
| Project (shared via repo) | `<project>/.claude/skills/<skill-name>/SKILL.md` |

The folder name should match the skill's `name`. Restart or reload the agent so it re-scans the skills directory.

## Invoking a skill

- **Explicitly** — type `/<skill-name>` in Claude Code (e.g. `/repo-docs-builder`).
- **Automatically** — the agent may load a skill on its own when your request matches the skill's `description`. This is why a precise, trigger-rich description matters.

## Authoring a new skill

1. Pick the tier with the invoke-it-anywhere test, then create `Skills/Core/<Category>/<skill-name>/SKILL.md` (in the category that fits, or a new one) or `Skills/Projects/<repo-slug>/<skill-name>/SKILL.md`.
2. Write the frontmatter — a unique `name` and a description that leads with the capability and names the trigger conditions.
3. Write the body: purpose, when-to-use, principles, a concrete execution checklist, and explicit anti-patterns. Concrete examples beat abstract advice.
4. Keep it self-contained — the agent won't have your surrounding conversation when the skill loads.
5. Add a row to the matching table — the repo [`../README.md`](../README.md) and [`Skills/Core/README.md`](../Skills/Core/README.md) for a Core skill, or the project's own README for a project skill.
6. If it's worth documenting further (design rationale, longer usage notes), add a doc here in `Docs/`.

> [!TIP]
> The [`repo-docs-builder`](../Skills/Core/Documentation/repo-docs-builder/SKILL.md) skill is a good reference implementation — it shows the frontmatter + when-to-use + principles + workflow + anti-patterns structure.

## Testing a skill

- Invoke it explicitly (`/<skill-name>`) on a real task and confirm the output follows the skill's rules.
- Check auto-invocation: phrase a request that should match the `description` and see whether the agent loads the skill unprompted. If it doesn't, tighten the trigger wording in the description.
