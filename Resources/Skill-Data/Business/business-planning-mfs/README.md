# business-planning-mfs — Skill-Data

## What the skill does

[`business-planning-mfs`](../../../../Skills/Business/business-planning-mfs/SKILL.md) takes a business idea — anything from a one-line hunch to a finished proposal — and runs a fixed eight-pass analysis over it, then writes the result out as a navigable documentation repo.

| Half | Passes | Ends in |
|:---|:---|:---|
| **Strategy** | Framing & sizing → competitive intelligence → ROI model → decision memo | A call: build, don't build, or validate first. |
| **Build** | Product spec → architecture ADRs → build estimate → build plan | A sliced plan with a stopping point. |

Two things define it. **The gate:** passes 5–8 only run if the memo says build, so a no-go is a complete run rather than a failed one. **The evidence rule:** every number is traceable to a source or tagged `[assum]`, because the dominant failure of an LLM doing business analysis is inventing a plausible market size that gets cited downstream until the fabrication is load-bearing.

The output follows the [`repo-builder-mfs`](../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) house style — a root index carrying the verdict, a README in every pipeline folder, down-links and up-links, and a humanizer pass over the prose.

> [!NOTE]
> The eight passes are adapted from a set of standard business-analysis disciplines (market sizing, competitive intelligence, ROI modeling, decision memos, product spec, technical architecture, build estimation, shipping discipline). The skill's `references/analysis-passes.md` is a condensed, re-scoped version for one-shot use on a single idea.

## About this folder

Reference exemplars for the skill: the end-state folder tree it produces, and a filled-in root README showing the verdict-first structure with real-looking tags and badges. These illustrate the target output. They are not files the skill loads at runtime — the skill's own `references/` folder carries everything it reads.

## Contents

| Path | What it is |
|:---|:---|
| [`Examples/`](./Examples/README.md) | The target output tree and a worked root README. |

---

<p align="center">
  <a href="../../../README.md">← Resources home</a> ·
  <a href="../../../../Skills/Business/business-planning-mfs/SKILL.md">The skill →</a>
</p>
