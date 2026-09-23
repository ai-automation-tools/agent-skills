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
   as `^- Needs <owner>: (?!none)` turn the email to *attention*.

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

## Encoding and shell traps (Windows)

- PowerShell 5.1 reads BOM-less `.ps1` files as ANSI. Keep runners ASCII-only, or run them under `pwsh`.
- Native stderr under `2>&1` with `$ErrorActionPreference='Stop'` throws. Redirect it to `$null`.
- `[string[]]` parameters misbind across `pwsh -File`. Pass switches or single strings.
- Editing Windows paths through a bash heredoc collapses `\\` and can turn `\2…` into
  control bytes. Use a file-based editor, then check the bytes.
