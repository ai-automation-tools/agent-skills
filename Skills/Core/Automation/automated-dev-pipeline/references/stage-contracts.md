# Stage prompt contracts

Every unattended prompt in the pipeline has the same skeleton. When you write a new one,
copy the closest existing prompt from the reference implementation and keep these parts.

## Required sections

1. **Opening line:** "You are running unattended as … Nobody will answer questions
   mid-run. Finish the job and end with the RUN SUMMARY block." Without it, sessions stop
   to ask.
2. **Paths table:** every path the stage reads or writes, and nothing else. Mark sources
   read-only.
3. **Numbered steps.** Each step says what "done" means. Name the exact commands where a
   wrong command is costly (worktree cleanup, repo creation, visibility).
4. **Rules:** the don'ts, each with its reason. For example: never push to a default
   branch, never change visibility, never touch the approval issue, never edit `bin\`,
   scratch files go in `$env:TEMP\<stage>\`.
5. **A partial-failure clause:** "If a step fails partway, say exactly which steps finished
   and which didn't." A half-created project that nobody hears about is the worst outcome.
6. **A RUN SUMMARY block** with fixed `- Key: value` lines, ending in `- Needs <owner>: <list | none>`.
   The runner's email extracts `^RUN SUMMARY` and `^- ` lines, and `warnOn` patterns such
   as `^- Needs <owner>: (?!none)` turn the email to *attention*. **This applies to stages
   on the maintenance-style runner.** A roadmap-style runner doesn't parse output. There,
   the PR body (or the APPEND MODE comment) carries the summary and a **Needs <owner>**
   section, and the runner judges success by whether a PR appeared or the branch moved.
   See "Runners and what they give you" in `architecture.md`.
7. **For a stage in a repo wired to hardware or live apps:** a line saying which tools are
   denied and that a refusal is expected, not a failure to work around. The deny list
   itself goes in the run worktree's settings (SKILL.md rule 11). The prompt only explains it.

**Shared rules for a family of stages** (several stages on one repo) can live in one file
that each prompt tells the session to read first. Keep what differs in each prompt, and the
contract (caps, definition of done, ledger) in the repo, where the stages can read it.

## What the runner does before the prompt

- **Injects today's date and weekday.** A session's sense of "today" drifts to its
  training cutoff, which falsifies retrieval dates in research.
- **Runs the pre-check.** A stage with nothing to do never sees its prompt.
- **For graduate:** runs the publish script first, then passes the results into the prompt
  as a `PUBLISH RESULTS` block. The model acts only on those results.

## Roadmap routine prompt (per project)

Filled in from a template at incubation. Every placeholder has to be replaced from the real
repo, because a generic "done" is where weak runs start. It must:

- read `CLAUDE.md`, the ROADMAP, the spec and build plan, then the code
- take the first unchecked item that isn't marked Needs <owner>, working above the gate line first
- claim it (`[-]` with a dated note) before coding
- run the repo's exact verify commands. If any fails, open no PR, revert, and don't weaken
  tests or add lint-disables
- update docs and the CHANGELOG in the same commit as the tick
- open one PR, or append to the open one (APPEND MODE), and never merge it itself

## Merge rules (sweep prompt)

One table row per branch prefix: what the PR should contain, what makes it mergeable, and
what makes it a hold. Holds are path-based wherever possible ("merge only if every changed
file is under X") because a path check is cheap and hard to argue with. Anything that
touches a hand-curated area, deletes or renames, or lacks a source URL is a hold.

**Put path holds in the runner, not only the prompt** (rule 1). The reference sweep runner
takes two per-target keys:

```json
{ "project": "Design-Lab", "ghRepo": "owner/repo", "allowedBases": ["main"],
  "branchPrefixes": ["design/auto-"],
  "holdPaths": ["design/projects/live/*", "site/*"] }
```

- **`branchPrefixes`** overrides the sweep-wide list for that repo only. Use it when one
  repo hosts several routines and only some of them should be merged automatically.
- **`holdPaths`** are globs where `*` crosses `/`. The runner lists the PR's changed files
  (`gh pr diff --name-only`), and any match makes the PR HOLD with the files named. The
  session may comment on a held PR but can't merge it. This is how a deploy-on-merge
  publish waits for a person while routine progress still merges.

Test a new gate against a real merged PR that should trip it, and one that shouldn't,
before trusting it on Sunday.

## Encoding and shell traps (Windows)

Moved to SKILL.md ("Windows shell traps") so they're read before the first edit, not after
the third broken file.
