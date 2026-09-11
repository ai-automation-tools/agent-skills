<h1 align="center">⏱️ cronsole skills</h1>

<p align="center">
  <em>Skills welded to <a href="https://github.com/ai-automation-tools/cronsole"><code>cronsole</code></a> — they only make sense while you are working in that repo.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/branch-main-0078D4?style=for-the-badge" alt="Default branch main">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Projects-6B7280?style=for-the-badge" alt="Back to Projects"></a>
</p>

---

**The repo:** Scheduled-task control plane across Windows Task Scheduler, Claude routines, Gemini Triggers and more.

## What lives here

Skills that fail the portability test — they name this repo's files, commands, schema, or
protocol, so invoking them anywhere else is meaningless. A skill you would reach for from
*any* repo belongs in [`Skills/Core/`](../../Core/) instead, even if it was written while
working on this one.

## Skills already shipped from the repo itself

`cronsole` (repo internals — the .NET agent protocol, template registry, MCP server), `source-doctor`

> [!NOTE]
> Watch the name collision: `skills/cronsole/` and the connect-pack under `backend/src/tools/` both declare `name: cronsole` with opposite audiences — one for developing Cronsole, one for using a running instance. Two skills cannot share a name in one agent, so anything landing here needs the audience in its name.

## Adding one

1. Create `<skill-name>/SKILL.md` here. Prefix the name with the project (`cronsole-…`) unless
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
