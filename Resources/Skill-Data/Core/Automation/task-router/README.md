# task-router — Skill-Data

## What the skill does

[`task-router`](../../../../../Skills/Core/Automation/task-router/SKILL.md) decides **how much machinery a request deserves** before any work starts, then picks the model to run it on. Two decisions, in that order:

| Decision | Options |
|:---|:---|
| **Execution shape** | Tier 0 inline (no agent) · Tier 1 one subagent · Tier 2 recon/plan then act · Tier 3 fan-out |
| **Model** | `haiku` mechanical · `sonnet` default, docs + basic research · `opus` genuinely complex · **`fable` never** |

Shape comes first because it is the expensive mistake. A fan-out for a typo burns tokens and wall-clock; an inline guess at an architecture change burns an afternoon. Model choice only matters once the shape is right.

## Why it exists

Two problems, one skill:

1. **Subagents were effectively off.** The standing rule in this environment is *don't use the Agent tool or Workflows unless the user, a CLAUDE.md, or a skill asks for it.* Nothing asked. The skill states explicitly that it **is** the authorization — and only at the tier it selects, so Tier 0 still means no agent.
2. **Model choice had no policy.** The Agent tool accepts `model: fable` silently, and Fable bills as direct API tokens rather than against the subscription. Nothing warns you. The skill's §1 is the guard.

## The subscription rule

The one non-negotiable: **never `fable`**, for anything. It is the only tier that leaves the subscription. If a task seems to want Fable, it wants Opus.

The secondary rule worth restating, because it is the one that gets violated by accident: **documentation updates and basic research are `sonnet`, not `haiku`.** Both read as cheap mechanical work and neither is — deciding what to include, what is stale, and what a source actually says is judgment.

## About this folder

Supporting notes about the skill. Nothing here is read at runtime — the skill is self-contained in its leaf folder.

## Contents

| Path | What it is |
|:---|:---|
| *(this README)* | Rationale and the model policy in one place. |

> [!NOTE]
> The skill's own **§6 Calibration** table is its test fixture — fourteen worked examples from "fix the typo" (Tier 0) to "make the site better" (ask, don't route). If a routing decision disagrees with the nearest row, the table is what to check first. Promote it to a tracked `evals/evals.json` only if routing decisions start drifting from it in practice.

---

<p align="center">
  <a href="../../../README.md">← Resources home</a> ·
  <a href="../../../../Skills/Core/Automation/task-router/SKILL.md">The skill →</a>
</p>
