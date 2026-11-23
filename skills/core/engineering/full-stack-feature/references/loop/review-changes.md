> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `/review-changes` command. Follow it as a procedure.

# Review the working diff

Read-only review of the current uncommitted changes. Decide which reviewer agents
apply based on what actually changed, dispatch them, and consolidate their ranked
findings. Target: **the feature you were given** (default: the full working diff — `git diff` plus
staged and untracked changes). This command **reviews and reports; it does not
fix.**

## Instructions

1. **Get the diff and read it before dispatching anything.** Run `git status` and
   `git diff` (include staged with `git diff --cached` and note untracked files).
   Read it yourself first so you can route intelligently — a reviewer pointed at
   the wrong surface wastes a pass. If the diff is empty, say so and stop.

2. **Route by what changed, not by ritual.** Match the changed files to the
   reviewers that have something to say, and dispatch only those:
   - **`../reviewers/frontend-reviewer.md`** — components, pages, styling, client state,
     anything under the UI tree.
   - **`../reviewers/backend-reviewer.md`** — routes, controllers, server actions, webhooks,
     workers, auth, validation, external calls.
   - **`../reviewers/database-reviewer.md`** — migrations, schema, ORM models, raw queries,
     seed data.
   - **`../reviewers/release-reviewer.md`** — build config, CI, Dockerfiles, env/deploy config,
     or any change whose success is being *claimed* rather than shown.
   - **`../reviewers/accessibility-reviewer.md`** — any change a user sees or operates: markup,
     components, forms, dialogs, focus or keyboard handling, colour and motion.
     Run it alongside `../reviewers/frontend-reviewer.md`, never instead of it.

   A pure CSS tweak doesn't need the database reviewer; a migration-only change
   doesn't need the frontend one. Dispatch the applicable agents in parallel —
   they're read-only and independent. If several apply, run several.

3. **Let the agents do the finding; they are read-only by design.** Each returns a
   ranked list of findings with file and line references — they don't edit, and
   neither do you in this command. Your job is to route, collect, and consolidate,
   not to start fixing what they surface.

4. **Consolidate into one ranked list, severity first.** Merge the agents'
   findings into a single list ordered by "would this break something in
   production or leak data," not by which agent spoke or how confident it was.
   De-duplicate where two reviewers flag the same underlying issue. Keep the file
   and line reference on each so every finding is checkable. Separate "this is a
   bug" from "this is unproven" — they need different responses.

5. **Watch for the failure this workspace is built against.** Across every layer,
   the thing to surface loudest is a success that was *claimed but not shown* — a
   change described as "tested" or "works" with no evidence in the diff or the
   session that it was run, an API cited that may not exist in the pinned version,
   an error/empty/loading state skipped, a boundary left unvalidated. Flag these
   even when the code reads cleanly, because reading cleanly is exactly their
   disguise.

## Reporting

Lead with the verdict: the count of findings by severity and the single most
serious one. Then the consolidated ranked list — most severe first, each with its
file/line and a one-line "what it would take to fix," so the human can act
without re-reading the diff. Name which reviewers you ran and which you skipped
and why. Do not fix anything — this command reports; fixing is a separate,
deliberate step the human authorizes.
