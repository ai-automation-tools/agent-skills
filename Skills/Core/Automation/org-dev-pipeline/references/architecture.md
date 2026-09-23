# Architecture

## Contents

- Components
- The weekly rhythm
- State and contracts
- Failure handling

## Components

| Component | Kind | Does | Output |
|:---|:---|:---|:---|
| **Ideate** | stage, Sonnet | Picks one unanalysed idea, runs a business-plan skill with web research, and scores it 1–10 | a plan folder + a ledger row (`planned` or `rejected`) |
| **Incubate** | stage, Opus | Takes the top `planned` plan: local repo, docs, ROADMAP with release gates, private remote via the security wrapper, a weekly roadmap routine, and a sweep target | a private repo + a registered task |
| **Roadmap routine** | per project, weekly | Works the next unchecked ROADMAP item in a throwaway worktree, verifies it (build/test/lint), ticks it, and opens a PR | a `roadmap/auto-<date>` PR |
| **PR sweep** | Opus, 2x/week | Hard gates (mergeable, checks, not draft), then a per-prefix review, then a squash-merge or a hold with a comment | merged PRs + an email |
| **Graduate** | daily; publish script + Sonnet | The script runs the gates, requests approval, and after approval flips to public and re-verifies security. The model then moves the folder, adds landing-page tiles and updates records | a public repo + site tiles |
| **Upkeep** | Sonnet, weekly | Syncs the landing page with the org by PR, sweeps security controls, fixes homepages, and flags red CI, stuck PRs, coverage gaps, thin runway, blocked gates and stalled projects | a dated report + an optional PR |
| **Harvest** | Sonnet, weekly | Mirrors portable workspace skills byte for byte into the shared library's Domain tier, with gates (tier, name collision, duplicate, secrets) | one `harvest/auto-*` PR |
| **Workspace refresh** | Sonnet, weekly, one per workspace | Researches sourced intel for the workspace's field, then fixes the skills that intel makes stale | one `workspace/refresh-*` PR per workspace |
| **Monthly review** | Sonnet, monthly | Source-cited currency fixes to the shared library's hand-curated tiers | one `skills/monthly-review-*` PR |

## The weekly rhythm

The order is set by one fact: **a stage reads `origin/main`**, so whatever feeds it has to be
merged by a sweep that runs before it.

```
Mon  ideate (only if backlog < threshold)       roadmap routines, one weeknight each
Tue  workspace refresh 22:00 ─┐
Wed  sweep 09:30 ◀────────────┘  (merges Mon/Tue roadmaps + refresh)
Sat  upkeep 18:00 (landing PR ready for Sunday)
Sun  harvest 08:00 → sweep 09:30 → incubate 12:00
Daily graduate 16:00 (skips silently unless something is ready or approved)
```

Keep weekend-heavy jobs off the same slot. Two long sessions starting at the same time
compete for the same rate limit.

## State and contracts

- **Ledger** (`PIPELINE.md`): `| Slug | Source | Plan | Verdict | Score | Stage | Repo | Updated |`.
  Stages run `planned → incubating → public`, or `rejected`. Every stage reads it first and
  writes it last. The pre-check parses it, so keep the column order fixed.
- **The release-gate line.** Everything in `docs/ROADMAP.md` above the heading
  `## After public release` is a release gate. The count of open items (`[ ]`, `[-]`,
  `[!]`, including numbered forms) above that line has to reach 0. A missing heading is a
  contract break to report, never something to guess around.
- **Approval**: a `release-approval` issue. Open means awaiting approval. Closed as
  Completed means approved. Closed as Not planned means rejected. Reopening re-queues it.
  The publish script's exit codes carry the state: 0 published, 1 held at a gate,
  10 awaiting, 11 rejected.
- **Branch prefixes**: every routine owns one. The sweep config's `branchPrefixes` is the
  master list, and anything else that needs the list reads it from there.

## Failure handling

| Situation | Behaviour |
|:---|:---|
| Pre-check can't tell (git or gh error) | Run the session. The prompt re-checks |
| Gate fails on a ready project | Stay private. On the weekly slot, queue one roadmap fix item by PR, unless one is already open |
| Security wrapper fails after a create or flip | Stop that project and report it first under Needs <owner> |
| A roadmap run fails verification | No PR. Revert, restore the item, and state what blocked it |
| Stage session crashes | The runner exits non-zero, and the wrapper emails `failed` |
| Clean skip on a daily job | No email (`quietOn: ["^SKIPPED:"]`) |
