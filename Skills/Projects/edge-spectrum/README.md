<h1 align="center">📉 edge-spectrum skills</h1>

<p align="center">
  <em>Additional skills for <a href="https://github.com/ai-automation-tools/edge-spectrum"><code>edge-spectrum</code></a> — an overlay on top of the skills that repo already owns.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/branch-main-0078D4?style=for-the-badge" alt="Default branch main">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-Projects-6B7280?style=for-the-badge" alt="Back to Projects"></a>
</p>

---

**The repo:** Market-analytics hub on Vercel — expected-return visualisation and a 25-year sports backtester.

## What lives here

**Additional** skills for this repo — an overlay on top of the ones the repo already owns, not
a copy of them and not a place to move them to. The repo's own skills stay in the repo.

What qualifies: anything that fails the portability test, because it names this repo's files,
commands, schema, or protocol, so invoking it anywhere else is meaningless. A skill you would
reach for from *any* repo belongs in [`Skills/Core/`](../../Core/) instead, even if it was
written while working on this one.

## 📦 What this tier adds

Three skills, split by **which of the repo's three layers** you are standing in. Each names this
repo's files, scripts and constants, so none of them means anything anywhere else.

| Skill | Covers | Parts |
|:---|:---|:---|
| [**🧩 edge-spectrum-hub-tool**](./edge-spectrum-hub-tool/SKILL.md) | The hub surface — one `TOOLS` entry plus one page, the three `kind` branches and what each obliges, the literal `ACCENT` map Tailwind's JIT needs, the calculator pattern over `src/odds.ts` and `CalcUi.tsx`, and the `<Route path="*">` fallback that hides a bad `href`. | [`page-patterns`](./edge-spectrum-hub-tool/references/page-patterns.md) |
| [**📊 edge-spectrum-dataset**](./edge-spectrum-dataset/SKILL.md) | The 187 records in `src/data/edges.ts` and the four artifacts `gen:edges` writes from them, the record-count that lives in three files at once, the provenance ratchet, and the three measures — floored, unfloored, and agreeing on `ruinPoint`. | [`measures`](./edge-spectrum-dataset/references/measures.md) |
| [**🔌 edge-spectrum-endpoint**](./edge-spectrum-endpoint/SKILL.md) | The dual entry point — `server.ts` and `api/*` as thin adapters over `src/server/` — Zod at the trust boundary, the `strategySchema`/`strategyBounds` split that keeps Zod out of a 776 KB bundle, and the advisor gate that fails **closed** on a missing secret. | [`gate`](./edge-spectrum-endpoint/references/gate.md) |

## ⛔ Names already taken in that repo

Skills install **flat**, so publishing a skill here under a name the repo already uses will
overwrite it. Check this list before naming anything new — and prefix with the project slug
whenever there is any doubt.

None — the only repo in the org with no skills of its own, so nothing here can clobber.

**Maintainer skills** — tracked in `.claude/skills/`, for contributors working on the repo:

none — `.claude/skills/` exists but is empty

> [!WARNING]
> **This repo gitignores `.claude/` entirely**, unlike cronsole and the others that track it. An
> install here lands in *your* clone only — it is not a commit other contributors get, and a fresh
> clone starts without it. Re-run the install after cloning.

> [!NOTE]
> The note that used to sit here asked whether the backtester's model assumptions deserve a review
> skill the way Edge-Radar's betting math got `betting-logic-review`. Still open — the three skills
> below cover *changing* the code, not auditing the simulation's assumptions.

## Adding one

1. Check the taken-names list above, then create `<skill-name>/SKILL.md` here. Prefix the name with the project (`edge-spectrum-…`) unless
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
