---
name: automated-dev-pipeline
description: Design, stand up, audit, or operate scheduled AI agents that do development work unattended. They turn ideas into scored plans, plans into private repos built one roadmap item at a time through PRs that a single sweep reviews and merges, and publish finished projects to a GitHub account or organization only through scripted release gates plus a human approval. Then they keep every repo current with today's tools, dependencies, security practice and standards. Use whenever the user wants to automate building, publishing or maintaining repos; add or change a scheduled coding routine or pipeline stage; set up where ideas come from; keep repos from going stale; audit scheduled Claude jobs for cost, overlap or safety; decide what to script versus leave to a model; or put an approval step in front of anything irreversible. Also use when they mention incubate or graduate, PIPELINE.md, release gates, a roadmap routine, a PR sweep, or ask "why didn't the pipeline do X".
---

# Automated dev pipeline

A pattern for letting scheduled, unattended AI sessions do development work: start new
projects, build them, publish them to GitHub, and keep every repo current afterwards. No
human is in the loop **except at the one step that can't be undone**, which is making a
repo public. It came out of running a real GitHub organization this way. Every design rule
below exists because breaking it cost something.

The pattern does three jobs. They can be adopted separately:

| Job | Stages | What you get |
|:---|:---|:---|
| **Build** | ideate → incubate → roadmap routine → PR sweep | Ideas become private repos that grow one verified PR at a time |
| **Publish** | graduate (scripted gates → approval → public) | A finished project goes public on a personal account or an organization, with its security controls verified |
| **Keep current** | refresh, review, upkeep, and the same roadmap routines | Every repo, new or old, keeps up with its dependencies, platforms, security practice and standards |

The publish target is a parameter: a personal account works the same as an organization.
"The landing page" is then your profile README or portfolio site, if you keep one.

Read this file first. Then open the reference that matches the job:

| Job | Read |
|:---|:---|
| Stand up a new pipeline, or add a stage or routine | `references/architecture.md`, then `references/stage-contracts.md` |
| Decide where ideas come from, or connect a new idea source | `references/idea-sourcing.md` |
| Keep existing repos current, or bring a stale one back up to date | `references/keeping-current.md` |
| Audit an existing fleet (cost, overlap, safety, drift) | `references/audit-checklist.md` |
| Operate or debug a live pipeline | That pipeline's own operator notes: file paths, parameter values, run commands. The reference implementation keeps them at `~/.claude/routines/jobs/_org-pipeline/reference-implementation.md`. If none exist, write them before changing anything |

## The loop

```
ideas ──ideate──▶ scored plan ──incubate──▶ private repo + weekly roadmap routine
                                                  │  one item/run → PR
                                                  ▼
                                    PR sweep (review + merge, 2x/week)
                                                  │  all release gates ticked?
                                                  ▼
                  scripted gates ──▶ approval email + issue ──▶ human closes as Completed
                                                  │
                                                  ▼
                   public + security re-verified ──▶ landing page, records
                                                  │
                                                  ▼
         keep current: refresh + review + upkeep ──▶ PRs into the same sweep
```

Keeping current never ends. A published repo keeps its roadmap routine, and the refresh
and upkeep jobs cover every repo, including ones that never went through the build stages.
You can point the pipeline at repos you already have and use only that part.

## Design rules

Each rule is here because the reference implementation paid for learning it.

1. **Scripts decide, prompts judge.** Anything with a yes/no answer (open PRs, commit
   emails, a secret scan, CI status, an HTTP 200, a count of unchecked boxes) goes in a
   script with an exit code. The model gets the work that needs judgment: writing, review,
   picking the next item. A checklist inside a prompt is a request, not a guarantee.
2. **Irreversible means human.** Making a repo public can't be undone: it gets cloned,
   cached and indexed within minutes. A script runs the gates, then asks for approval on a
   GitHub issue plus an email. It flips visibility only after the issue is closed as
   Completed, and re-runs the gates right before the flip. The model is told never to
   touch that issue or change visibility.
3. **Every write is read back.** A `200` isn't proof. `gh repo create` doesn't turn on
   secret scanning or push protection by itself (and doesn't inherit an organization's
   defaults), and a visibility change can silently turn controls off. So repo creation and
   every visibility change go through a wrapper that enables the controls and reads them
   back in the same command, and exits non-zero if one is still off.
4. **Only PRs reach default branches, through one merge gate.** Every routine opens a PR on
   a known branch prefix. One sweep (the strongest model you run) reviews them against
   per-prefix rules and merges. New prefixes are registered in the sweep config, and the
   upkeep job reads that list instead of keeping its own copy.
5. **Check for work before starting a session.** A cheap deterministic check decides
   whether a stage has anything to do. With nothing to do, it logs `SKIPPED: <reason>` and
   exits 0, with no AI session and, on daily jobs, no email. If the check itself errors,
   it runs the session anyway, and the prompt applies the same checks.
6. **Match cadence to throughput.** Don't produce what the next stage can't absorb. Plans
   should be generated only when the backlog runs low, and incubation needs a cap. Merge
   frequency limits build speed: one sweep a week means one item a week. Cadence should
   follow demand, not the calendar.
7. **One session, one PR, per repo per cycle.** Jobs that touch the same repo on the same
   topic (research on what changed, and the fixes it calls for) are one session and one
   PR, not two jobs that coordinate through `main`.
8. **One ledger, one schedule table.** Pipeline state lives in one markdown ledger that
   every stage reads first and writes last. Each schedule is written down in one place,
   fact-checked weekly against live state. Every other doc links to it. Prompts never
   hand-edit counts or badges, because a recount job does that from the live source.
9. **Make stalls loud.** A gate that only a human can clear, a project with no merged
   progress in 21 days, or a task that stopped firing gets listed every week until it's
   resolved. A capped slot held by a stuck project is a silent deadlock otherwise.
10. **Every currency change cites its source.** A refresh that says "updated to the latest
    version" without a link is a guess. Each change names the release note, advisory or
    standard behind it, so the sweep can check it and a reader can trust it.

## Parameters

Pick these before building anything, and write the chosen values into the pipeline's
operator notes so the next session doesn't have to rediscover them.

| Parameter | Decides |
|:---|:---|
| Publish target | A personal account or an organization, and where each local clone is filed (by its remote, not by its name) |
| Idea source + fit criteria | Where ideate reads candidates from (read-only, a stable ID per idea), and what makes an idea right for you. See `references/idea-sourcing.md` |
| Ledger path | The single state file |
| Runner + scheduler | How a stage launches a headless session, logs, and emails a summary (Task Scheduler, cron, CI schedules) |
| Security wrapper | The create-and-verify / re-verify script (rule 3) |
| Publish script | Gates → approval → flip → re-verify (rules 1–2) |
| Approval channel | Issue label + email transport. Replies to a send-only email are never read, so approval is an issue state |
| Landing page | What graduation and upkeep keep in sync: an org site, a portfolio page, or none |
| Currency scope | Which repos the keep-current jobs cover, what "current" means for each (see `references/keeping-current.md`), and how often |
| Incubation cap, ideate threshold | Throughput limits (rule 6) |
| Sweep days, model tiers | Speed and cost. A mid-tier model for research and writing, the strongest for merges and repo creation |

The RUN SUMMARY key for human-only work is `Needs <owner>`. Use the real person's name, as
in `Needs Alex`, so the email filter and the upkeep report can match it.

## Procedure: adding a stage or routine

1. Write down what it reads, what it writes, and which branch prefix its PRs use. If it
   shares a repo and topic with an existing job, extend that job instead (rule 7).
2. Split its logic. The deterministic parts go in the runner's pre-check or a script
   (rules 1, 5), and the judgment goes in the prompt, following `references/stage-contracts.md`.
3. Register the branch prefix and its merge rule in the sweep config and the sweep prompt.
4. Pick a schedule slot that fits the sweep. Its PR should be waiting when the sweep
   runs, and whatever it feeds should run after the sweep.
5. Dry-run it (`-CheckOnly` / `-WhatIfClaude`), clean up any worktree with the runner's
   cleanup command, and register it.
6. Add one row to the schedule table. Don't restate the row anywhere else.

## Procedure: auditing

Follow `references/audit-checklist.md`. Write the result as two documents: the findings,
ranked P0–P3 with evidence, and a plain numbered next-steps list that says what to change,
where, and how you'll know it worked. People act on the second one.

## Anti-patterns

- **A model with the power to publish.** Visibility changes belong to a script behind an
  approval, never to a prompt instruction.
- **Every job merging its own PRs.** Merges go through one sweep, or review quality drifts
  job by job.
- **Refreshing without sources.** Version bumps and "best practice" edits with no link are
  how a stale model's training data ends up in your repos.
- **Building the whole pipeline at once.** Start with one repo, one roadmap routine and the
  sweep. Add ideate and graduate once that loop merges good PRs.
