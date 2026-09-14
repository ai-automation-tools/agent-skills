<h1 align="center">📡 Edge-Radar skills</h1>

<p align="center">
  <em>Additional skills for <a href="https://github.com/ai-automation-tools/Edge-Radar"><code>Edge-Radar</code></a> — an overlay on top of the skills that repo already owns.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/branch-master-0078D4?style=for-the-badge" alt="Default branch master">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Projects-6B7280?style=for-the-badge" alt="Back to Projects"></a>
</p>

---

**The repo:** Multi-agent edge detection and execution for Kalshi / Polymarket prediction markets.

## What lives here

**Additional** skills for this repo — an overlay on top of the ones the repo already owns, not
a copy of them and not a place to move them to. The repo's own skills stay in the repo.

What qualifies: anything that fails the portability test, because it names this repo's files,
commands, schema, or protocol, so invoking it anywhere else is meaningless. A skill you would
reach for from *any* repo belongs in [`Skills/Core/`](../../Core/) instead, even if it was
written while working on this one.

## 📦 What this tier adds

Two skills, split by **which half of a strategy's life** they cover. Both sit upstream of the
repo's own `/edge-radar`, which runs a scan once you already know what you want.

| Skill | Covers | Parts |
|:---|:---|:---|
| [**🎛️ edge-radar-strategy-profiles**](./edge-radar-strategy-profiles/SKILL.md) | Designing a strategy as a `.env.<name>` overlay instead of a fork — the two sizing lanes and which knob binds where, subaccount bankroll isolation, the dry-run → pilot → live ladder, comparing two books in one trade log, and killing one cleanly. | [`knobs`](./edge-radar-strategy-profiles/references/knobs.md) · [`launch-and-kill`](./edge-radar-strategy-profiles/references/launch-and-kill.md) |
| [**🔬 edge-radar-strategy-evidence**](./edge-radar-strategy-evidence/SKILL.md) | Proving one. Routing a question to the right tool in `scripts/backtest/`, reporting the model-vs-market Brier **pair**, what each sample size can carry, the diagnostics that catch a fake edge fast, and zero-risk shadow rows when a freeze blocks its own evidence. | [`tool-map`](./edge-radar-strategy-evidence/references/tool-map.md) · [`shadow-book`](./edge-radar-strategy-evidence/references/shadow-book.md) |

Both are repo-specific by design — they name this repo's gates, env keys, scripts and settled
numbers, so they fail the portability test on purpose.

## ⛔ Names already taken in that repo

Skills install **flat**, so publishing a skill here under a name the repo already uses will
overwrite it. Check this list before naming anything new — and prefix with the project slug
whenever there is any doubt.

`edge-radar` (the unified operating surface), `edge-radar-analysis`, `betting-logic-review`

**Maintainer skills** — tracked in `.claude/skills/`, for contributors working on the repo:

`document-writer`, `footballbin-predictions`, `kalshi-markets`, `market-mechanics-betting`
*(`ax-workspace-cookbook` and `design-doc-mermaid-main` were removed 2026-09-14.)*

> [!NOTE]
> The only repo whose skills are written as first-class slash commands — they declare `allowed-tools` and `argument-hint`. Renaming one changes a user-facing command, so treat these names as an interface. Its default branch is `master`, the only one in the org.

## Adding one

1. Check the taken-names list above, then create `<skill-name>/SKILL.md` here. Prefix the name with the project (`edge-radar-…`) unless
   the skill *is* the project's namesake — two skills cannot share a name inside one agent.
2. Install it to the repo, not to user scope:
   `pwsh scripts/install-skills.ps1 -Project edge-radar -Destination <clone>/.claude/skills`
3. Add a row to [`Skills/Projects/README.md`](../README.md).

---

<p align="center">
  <a href="../README.md">← Projects</a> ·
  <a href="../../Core/">Core skills</a> ·
  <a href="../../../README.md">Repo home</a>
</p>
