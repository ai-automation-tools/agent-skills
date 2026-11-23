> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `/implement-feature` command. Follow it as a procedure.

# Implement the feature slice

Build the vertical slice through the app's existing patterns, add focused tests,
then run the checks and paste the real output. Feature: **the feature you were given** (default:
the slice described in `docs/plans/<slug>.md` if a plan exists, otherwise the
feature named at the top of the repo's `AGENTS.md` or `CLAUDE.md`; if neither is set, ask). Invoke the
`full-stack-feature` skill, and the per-layer skills (`../layers/frontend-engineer.md`,
`../layers/api-engineer.md`, `../layers/database-engineer.md`) for the layers you touch.

## Instructions

1. **Read the plan and the patterns first.** If `docs/plans/<slug>.md` exists,
   build the slice it describes. Either way, read the neighboring code before
   editing — the router, the data-fetching layer, the error shape, the validation
   pattern, the migration style — because you are copying a working path, not
   inventing one. A new dependency or abstraction is a claim the existing ones
   failed; make it out loud or don't make it.

2. **Build the smallest coherent path, end to end.** The thinnest complete column
   a user can actually walk — UI → API → data → back. Wire the layers so they
   agree on the contract: the component sends what the endpoint validates and
   renders what it returns. Read both sides of every boundary; if you own both,
   share the type rather than hand-copying a shape. Stub nothing you intend to
   call "done" — if a piece is deferred, it's named as deferred, not left looking
   finished.

3. **Cover the four async states, not just the happy one.** Every user-facing
   async flow gets loading, empty, error, and success. Validate input at the API
   boundary and return the app's error shape with the right status code. Use a
   transaction for any multi-step write. These are not polish — they're the parts
   that get skipped precisely because the demo doesn't show them.

4. **Don't invent APIs, flags, or config keys.** If you're not certain a function,
   hook, ORM method, or option exists in the version this repo pins, check
   `context7` or read the source. A hallucinated method that fits the pattern is
   the second-most-common failure here, right behind never running the code.

5. **Add focused tests at the most meaningful boundary.** Test the behavior you
   built — the validation that rejects bad input, the state that renders on error,
   the query that returns the right rows — not the framework. A test that only
   exercises the happy path is the same blind spot as a feature that only handles
   it.

6. **Run the checks and paste the actual output.** Typecheck the files you
   changed. Run the focused tests. Read the output and paste it — the test
   summary, the error, the tail. Then exercise the real path: drive the endpoint,
   load the page, submit the form, watch the record change. A green typecheck
   proves the shapes line up, not that the feature works. This is the step the
   whole command exists for; `../loop/test-and-build.md` runs the fuller ladder.

7. **Refuse to claim anything you didn't run, and state what you couldn't
   verify.** Do not write "tests pass" unless you ran them and are looking at the
   result. Do not write "this works end-to-end" for a path you didn't exercise.
   Where you genuinely couldn't verify — no local DB, an unreachable service, a
   step that needs prod — stop and name the risk. "Implemented; typechecks and the
   focused tests pass (output below); I did not exercise the webhook path because
   it needs a live signing secret" is the honest handoff. Silence that implies
   full coverage is the failure.

8. **Scope the change to the request.** Don't refactor unrelated code, reformat
   files you're not touching, or revert the user's own edits. Ask before
   committing, pushing, or deploying — those are gated for a reason.

## Reporting

Lead with what you built and, immediately, the verification: which checks you ran
and their actual output, and which real path you exercised. Then state plainly
what you did *not* verify and why — this is not a footnote, it's the part that
makes the rest trustworthy. List the changed files. Flag any migration, new env
var, or new dependency. Never report a result you did not run.
