---
name: org-dev-pipeline
description: Design, stand up, audit, or operate an automated development pipeline for a GitHub organization. Scheduled Claude sessions turn ideas into scored plans, plans into private incubating repos, build them one roadmap item at a time through PRs that a single sweep reviews and merges, and publish them only through scripted release gates plus a human approval. It also covers the upkeep jobs around that loop: landing-page sync, security read-backs, skill harvesting, and agent-workspace refreshes. Use whenever the user wants to automate building or maintaining the repos in a GitHub org, add or change a pipeline stage or scheduled routine, set up where its ideas come from, audit scheduled Claude jobs for cost, overlap or safety, decide what to script versus leave to a model, put an approval step in front of anything irreversible, or asks "why didn't the pipeline do X". Also use when they mention the ai-automation-tools pipeline, incubate or graduate, PIPELINE.md, release gates, or the org PR sweep.
---

# Org dev pipeline

A pattern for letting scheduled, unattended Claude sessions build and maintain a GitHub
organization's repos without a human in the loop, **except at the one step that can't be
undone.** It came out of running the `ai-automation-tools` org this way. The reference
implementation is still live, and every design rule below exists because breaking it cost
something.

Read this file first. Then open the reference that matches the job:

| Job | Read |
|:---|:---|
| Stand up a new pipeline, or add a stage or routine | `references/architecture.md`, then `references/stage-contracts.md` |
| Decide where ideas come from, or connect a new idea source | `references/idea-sourcing.md` |
| Audit an existing fleet (cost, overlap, safety, drift) | `references/audit-checklist.md` |
| Operate or debug a live pipeline | That pipeline's own operator notes: file paths, parameter values, run commands. The `ai-automation-tools` one keeps them at `~/.claude/routines/jobs/_org-pipeline/reference-implementation.md`. If none exist, write them before changing anything |

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
```

Around the loop there are four upkeep jobs. **Upkeep** reconciles the landing page and the
docs with reality and re-verifies security. **Harvest** mirrors portable skills into a
shared library. **Workspace refresh** keeps agent workspaces current on their field. The
**monthly review** keeps the shared library honest.

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
3. **Every write is read back.** A `200` isn't proof. `gh repo create` doesn't inherit org
   security defaults, and a visibility change silently turns controls off. So repo
   creation and every visibility change go through a wrapper that enables the controls and
   reads them back in the same command, and exits non-zero if one is still off.
4. **Only PRs reach default branches, through one merge gate.** Every routine opens a PR on
   a known branch prefix. One sweep (Opus) reviews them against per-prefix rules and
   merges. New prefixes are registered in the sweep config, and the upkeep job reads that
   list instead of keeping its own copy.
5. **Check for work before starting a session.** A cheap deterministic check decides
   whether a stage has anything to do. With nothing to do, it logs `SKIPPED: <reason>` and
   exits 0, with no Claude session and, on daily jobs, no email. If the check itself errors,
   it runs the session anyway, and the prompt applies the same checks.
6. **Match cadence to throughput.** Don't produce what the next stage can't absorb. Plans
   should be generated only when the backlog runs low, and incubation needs a cap. Merge
   frequency limits build speed: one sweep a week means one item a week. Cadence should
   follow demand, not the calendar.
7. **One session, one PR, per repo per cycle.** Jobs that touch the same repo on the same
   topic (intel and the skills it invalidates) are one session and one PR, not two jobs
   that coordinate through `main`.
8. **One ledger, one schedule table.** Pipeline state lives in one markdown ledger that
   every stage reads first and writes last. Each schedule is written down in one place,
   fact-checked weekly against live state. Every other doc links to it. Prompts never
   hand-edit counts or badges, because a recount job does that from the live source.
9. **Make stalls loud.** A gate that only a human can clear, or a project with no merged
   progress in 21 days, gets listed every week until it's resolved. A capped slot held by
   a stuck project is a silent deadlock otherwise.

## Parameters

Pick these before building anything, and write the chosen values into the pipeline's
operator notes (see the table above) so the next session doesn't have to rediscover them.
The RUN SUMMARY key for human-only work is `Needs <owner>`; name the real person, as in
`Needs Mike`, so the email filter and the upkeep report can match it.

| Parameter | Decides |
|:---|:---|
| Org and namespaces | Which clones are "org" and where each is filed (by remote, not by name) |
| Idea source + fit criteria | Where ideate reads candidates from (read-only, a stable ID per idea), and what makes an idea right for this org. See `references/idea-sourcing.md` |
| Ledger path | The single state file |
| Runner + scheduler | How a stage launches headless Claude, logs, and emails a summary |
| Security wrapper | The create-and-verify / re-verify script (rule 3) |
| Publish script | Gates → approval → flip → re-verify (rules 1–2) |
| Approval channel | Issue label + email transport. Replies to a send-only email are never read, so approval is an issue state |
| Landing page repo | What graduation and upkeep keep in sync |
| Incubation cap, ideate threshold | Throughput limits (rule 6) |
| Sweep days, model tiers | Speed and cost. Sonnet for research and writing, Opus for merges and repo creation |

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
