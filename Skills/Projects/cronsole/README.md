<h1 align="center">⏱️ cronsole skills</h1>

<p align="center">
  <em>Additional skills for <a href="https://github.com/ai-automation-tools/cronsole"><code>cronsole</code></a> — an overlay on top of the skills that repo already owns.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/branch-main-0078D4?style=for-the-badge" alt="Default branch main">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Projects-6B7280?style=for-the-badge" alt="Back to Projects"></a>
</p>

---

**The repo:** Scheduled-task control plane across Windows Task Scheduler, Claude routines, Gemini Triggers and more.

## What lives here

**Additional** skills for this repo — an overlay on top of the ones the repo already owns, not
a copy of them and not a place to move them to. The repo's own skills stay in the repo.

What qualifies: anything that fails the portability test, because it names this repo's files,
commands, schema, or protocol, so invoking it anywhere else is meaningless. A skill you would
reach for from *any* repo belongs in [`Skills/Core/`](../../Core/) instead, even if it was
written while working on this one.

## 📦 What this tier adds

Two skills, split by **which source the job runs on**. Both cover *which shape a scheduled job
should be* before you create it — the half the repo's own `cronsole` skill deliberately leaves
alone, since that one covers the mechanics of creating a task once you know what you want.

| Skill | Covers | Parts |
|:---|:---|:---|
| [**🪟 cronsole-windows-jobs**](./cronsole-windows-jobs/SKILL.md) | Windows Task Scheduler. Four archetypes — an unattended agent CLI run, a wrapped maintenance script, a service watchdog/lifecycle quartet, a plain command — plus registering, verifying, and handing the job to Cronsole. | [`agent-job`](./cronsole-windows-jobs/references/agent-job.md) · [`maintenance-job`](./cronsole-windows-jobs/references/maintenance-job.md) · [`service-jobs`](./cronsole-windows-jobs/references/service-jobs.md) · [`register-and-verify`](./cronsole-windows-jobs/references/register-and-verify.md) · a runnable wrapper, registrar and windowless shim in [`scripts/`](./cronsole-windows-jobs/scripts/) |
| [**☁️ cronsole-claude-routines**](./cronsole-claude-routines/SKILL.md) | The `CLAUDE_CODE` source — scheduled agent routines in the cloud. Four routine types, the eight-point prompt contract, the one-open-PR rule nothing enforces for you, and the connector's two doors. | [`routine-types`](./cronsole-claude-routines/references/routine-types.md) · [`cronsole-side`](./cronsole-claude-routines/references/cronsole-side.md) |

Both are written so a stranger who clones cronsole can use them — no machine-specific paths, no
one person's job names, and the notification step is transport-agnostic.

## ⛔ Names already taken in that repo

Skills install **flat**, so publishing a skill here under a name the repo already uses will
overwrite it. Check this list before naming anything new — and prefix with the project slug
whenever there is any doubt.

`cronsole` (repo internals — the .NET agent protocol, template registry, MCP server), `source-doctor`

**Maintainer skills** — tracked in `.claude/skills/`, for contributors working on the repo:

`api-architect`, `release-engineering`

> [!NOTE]
> Watch the name collision: `skills/cronsole/` and the connect-pack under `backend/src/tools/` both declare `name: cronsole` with opposite audiences — one for developing Cronsole, one for using a running instance. Two skills cannot share a name in one agent, so anything landing here needs the audience in its name.

## Adding one

1. Check the taken-names list above, then create `<skill-name>/SKILL.md` here. Prefix the name with the project (`cronsole-…`) unless
   the skill *is* the project's namesake — two skills cannot share a name inside one agent.
2. Install it to the repo, not to user scope:
   `pwsh scripts/install-skills.ps1 -Project cronsole -Destination <clone>/.claude/skills`
3. Add a row to [`Skills/Projects/README.md`](../README.md).

---

<p align="center">
  <a href="../README.md">← Projects</a> ·
  <a href="../../Core/">Core skills</a> ·
  <a href="../../../README.md">Repo home</a>
</p>
