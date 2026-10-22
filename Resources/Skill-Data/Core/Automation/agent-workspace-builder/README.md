# 🧠 agent-workspace-builder

> **Overview page.** The skill itself is [`SKILL.md`](../../../../../Skills/Core/Automation/agent-workspace-builder/SKILL.md) · [all Core skills](../../../../../README.md#-core-skills)

## What the skill does

[`agent-workspace-builder`](../../../../../Skills/Core/Automation/agent-workspace-builder/SKILL.md) creates, adopts or audits an **agent workspace**: a repo you open an agent in to do one field's work (security testing, business analysis, full-stack builds, media production, API research). Its `.claude/` carries the field's skills, reviewer agents, commands, rules and hooks, and its doctrine names the one failure an LLM is most likely to commit in that field.

| Job | What you get |
|:---|:---|
| **Create** | A new workspace that meets the standard on its first commit |
| **Adopt** | An existing workspace moved onto the standard, history and links intact |
| **Keep alive** | A weekly roadmap job (builds one item per PR) and a weekly upkeep job (intel, portable skills, `.claude/`, resources; proposes, never installs) |

## The standard, briefly

- `AGENTS.md` is the doctrine every agent CLI reads; `CLAUDE.md` is a bare `@AGENTS.md` import plus Claude-only notes.
- `docs/` holds only `README.md`, `ROADMAP.md` and `CHANGELOG.md` at its root. `docs/reference/` has the generated `CAPABILITIES.md` and the curated, link-verified `RESOURCES.md`; `docs/intel/` has the dated, sourced field log; everything else sits in a topic folder.
- `skills/` holds portable skills, kept apart from the wired `.claude/skills/`.
- Four stdlib Python checks (`check-structure.py`, `validate-skills.py`, `gen-capabilities.py`, `check-links.py`) run in CI, so the layout is an exit code rather than a request.

## Where it came from

It was written to standardize the five agent workspaces in the [ai-automation-tools](https://github.com/ai-automation-tools) org (`api-agent`, `business-agent`, `security-agent`, `fullstack-agent`, `media-agent`). The four scripts started as the shared copies those repos already carried; `check-structure.py` is new, and `validate-skills.py` now covers the portable `skills/` folder too.

## Files

| File | What it is |
|:---|:---|
| [`SKILL.md`](../../../../../Skills/Core/Automation/agent-workspace-builder/SKILL.md) | Create, adopt and audit procedures, principles, anti-patterns |
| [`references/workspace-standard.md`](../../../../../Skills/Core/Automation/agent-workspace-builder/references/workspace-standard.md) | Every file's contract, the AGENTS.md sections, the RESOURCES.md format |
| [`references/automations.md`](../../../../../Skills/Core/Automation/agent-workspace-builder/references/automations.md) | The roadmap and upkeep jobs: scope, hold paths, scheduling, setup |
| [`assets/`](../../../../../Skills/Core/Automation/agent-workspace-builder/assets/) | Templates to copy and fill, including both job prompts |
| [`scripts/`](../../../../../Skills/Core/Automation/agent-workspace-builder/scripts/) | The four checks, each with `--self-check` |
