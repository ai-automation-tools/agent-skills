<h1 align="center">📉 edge-spectrum skills</h1>

<p align="center">
  <em>Skills welded to <a href="https://github.com/ai-automation-tools/edge-spectrum"><code>edge-spectrum</code></a> — they only make sense while you are working in that repo.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/branch-main-0078D4?style=for-the-badge" alt="Default branch main">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Projects-6B7280?style=for-the-badge" alt="Back to Projects"></a>
</p>

---

**The repo:** Market-analytics hub on Vercel — expected-return visualisation and a 25-year sports backtester.

## What lives here

Skills that fail the portability test — they name this repo's files, commands, schema, or
protocol, so invoking them anywhere else is meaningless. A skill you would reach for from
*any* repo belongs in [`Skills/Core/`](../../Core/) instead, even if it was written while
working on this one.

## Skills already shipped from the repo itself

None yet — the only repo in the org with no skills at all.

> [!NOTE]
> Not an oversight to correct blindly. The obvious first question is whether the backtester's model assumptions deserve a review skill the way Edge-Radar's betting math got `betting-logic-review`.

## Adding one

1. Create `<skill-name>/SKILL.md` here. Prefix the name with the project (`edge-spectrum-…`) unless
   the skill *is* the project's namesake — two skills cannot share a name inside one agent.
2. Install it to the repo, not to user scope:
   `pwsh scripts/install-skills.ps1 -Project edge-spectrum -Destination <clone>/.claude/skills`
3. Add a row to [`Skills/Projects/README.md`](../README.md).

---

<p align="center">
  <a href="../README.md">← Projects</a> ·
  <a href="../../Core/">Core skills</a> ·
  <a href="../../../README.md">Repo home</a>
</p>
