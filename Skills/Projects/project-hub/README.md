<h1 align="center">🌐 project-hub skills</h1>

<p align="center">
  <em>Additional skills for <a href="https://github.com/ai-automation-tools/project-hub"><code>project-hub</code></a> — an overlay on top of the skills that repo already owns.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/branch-main-0078D4?style=for-the-badge" alt="Default branch main">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Projects-6B7280?style=for-the-badge" alt="Back to Projects"></a>
</p>

---

**The repo:** Zero-dependency Node server that turns a workspace into a browsable HTML console.

## What lives here

**Additional** skills for this repo — an overlay on top of the ones the repo already owns, not
a copy of them and not a place to move them to. The repo's own skills stay in the repo.

What qualifies: anything that fails the portability test, because it names this repo's files,
commands, schema, or protocol, so invoking it anywhere else is meaningless. A skill you would
reach for from *any* repo belongs in [`Skills/Core/`](../../Core/) instead, even if it was
written while working on this one.

## ⛔ Names already taken in that repo

Skills install **flat**, so publishing a skill here under a name the repo already uses will
overwrite it. Check this list before naming anything new — and prefix with the project slug
whenever there is any doubt.

None here — `project-hub-scaffold` is **core**, not a project skill, because you invoke it from whatever repo you are adding a hub to.

**Maintainer skills** — tracked in `.claude/skills/`, for contributors working on the repo:

none

> [!NOTE]
> The repo carries a published copy of `project-hub-scaffold` at `Skills/`. This repo is canonical; that copy is a travel copy so the skill works without this repo present. Edit here, then republish.

## Adding one

1. Check the taken-names list above, then create `<skill-name>/SKILL.md` here. Prefix the name with the project (`project-hub-…`) unless
   the skill *is* the project's namesake — two skills cannot share a name inside one agent.
2. Install it to the repo, not to user scope:
   `pwsh scripts/install-skills.ps1 -Project project-hub -Destination <clone>/.claude/skills`
3. Add a row to [`Skills/Projects/README.md`](../README.md).

---

<p align="center">
  <a href="../README.md">← Projects</a> ·
  <a href="../../Core/">Core skills</a> ·
  <a href="../../../README.md">Repo home</a>
</p>
