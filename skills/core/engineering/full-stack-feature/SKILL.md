---
name: full-stack-feature
description: Use when delivering a feature that crosses layers — a form that saves to the database and shows back, an endpoint the UI actually calls, a webhook that updates a record a page renders — because the default failure is declaring "done" with a layer stubbed, the UI and API never wired together, and nothing run. Triggered by "build a feature", "add X end to end", "wire up", "full stack", "vertical slice", "UI to API to database", "implement this feature", "make it save", "hook the frontend to the backend", "plan this feature", "is this ready to ship".
---

# Full-stack feature delivery

Read this first for anything that touches more than one layer. A feature is not
done when each layer compiles in isolation — it is done when a real request
travels UI → API → data → back to the UI and you watched it happen. The failure
this skill exists to prevent is the one that reads as success: three fluent
layers, each plausible on its own, handed over with "this should work" while the
form posts to an endpoint that doesn't exist, the endpoint returns a shape the
component never renders, and nobody ran the flow.

**A vertical slice through all layers beats a horizontal slab of any one.** One
field that saves and displays end-to-end, verified, is worth more than a
beautiful form wired to nothing and an API with no caller. Build the thinnest
path that a user can actually walk, prove it, then widen.

## Read the existing patterns before you write anything

The first edit on a cross-layer feature is a mistake if you made it before
reading how the app already does this. Open the neighbors: how does an existing
route fetch and mutate data, what does the data-fetching layer look like (fetch
wrapper, TanStack Query, a server action), how are errors shaped and surfaced,
where does validation live, how are migrations run, what does an existing
component do for its loading and error states. You are copying a working path,
not inventing one. **A new dependency or a new abstraction is a claim that the
existing ones failed** — sometimes true, but make the claim out loud and cheaply
disprovable, don't smuggle it in because it was faster than reading the code.

Do not invent APIs, hook names, ORM methods, or config keys because they *look*
like they should exist. If you are not certain a function or option exists in the
version this repo pins, check `context7` or read the source. A hallucinated
method that fits the pattern perfectly is the second-most-common way this work
goes wrong, right behind never running it.

## Map the feature across the layers first

Before code, write the slice down — even three lines in the plan. What does the
UI need to show and collect; what request does that imply; what does the API
validate, do, and return; what does the data layer need (a new column, a new
table, an index, a migration); does anything cross a trust boundary (auth,
another user's data, an external call). This map is where you discover the
migration you'd otherwise remember halfway through, or the auth check that makes
the whole thing harder. `references/loop/plan-feature.md` produces this as a file; for a small
slice, the map can live in your head — but it exists before the first edit.

Then find the **smallest coherent path**: the least code that makes one real
end-to-end interaction work. Coherent is the operative word — not a UI with a
faked response, not an endpoint with no caller, but the narrowest complete
column. Stub nothing you intend to call "done." If you must defer a piece, it is
named as deferred in the report, not left looking finished.

## Implement through the existing patterns

Wire it the way the app wires things. The single highest-value check on a
full-stack feature is that **the UI and the API agree on the contract** — the
component sends what the endpoint validates, and renders what the endpoint
returns. This is exactly where the "each layer looks right" failure hides: the
form posts `{ userName }`, the route reads `{ username }`, and both files are
individually flawless. Read both sides of every boundary you touch. If you own
both sides, keep the type in one place and import it; don't hand-copy a shape and
hope.

## Every async flow the user can see has four states

Loading, empty, error, success. The happy path alone is a demo, not a feature,
and it is the default output when nobody is watching. What does the screen show
while the request is in flight, when the list comes back empty, when the API
returns a 400 or the network drops, and when it succeeds. An error path that
swallows the failure into a blank screen is worse than a crash, because it looks
like it worked. See `references/layers/frontend-engineer.md` for what each state actually requires.

## Verify by running it, then report what you could not

You do not get to say "done" on evidence you didn't produce. Typecheck the files
you changed. Run the focused tests around the new behavior and read the output.
Then exercise the real path — drive the endpoint, load the page, submit the form,
watch the record change — because a green typecheck proves the shapes line up,
not that the feature works. `references/loop/implement-feature.md` and `references/loop/test-and-build.md` run this
ladder and paste the actual output; a claim of success with no artifact is the
thing this skill exists to prevent.

Then be honest about the edge of what you verified. "Implemented; typechecks and
the unit tests pass; I did not exercise the webhook path because it needs a live
signing secret I don't have" is a real handoff. Silence that implies full
coverage is not. If you genuinely could not run the slice end-to-end — no local
DB, an unreachable service, a step that needs prod — **stop and name the risk**
rather than papering it with "this should work." An unverified change is a
hypothesis, and labeling it one is the honest move.

## The loop, end to end

The references hold the full procedure. Use them in this order:

1. **Plan** with `references/loop/plan-feature.md`: map every layer, find the smallest coherent
   path, and write the plan to a file before any code.
2. **Build** with `references/loop/implement-feature.md`, reading the layer guide for each layer
   you touch: `references/layers/frontend-engineer.md`, `references/layers/api-engineer.md`,
   `references/layers/database-engineer.md`, `references/layers/devops-release.md`.
3. **Prove it** with `references/loop/test-and-build.md`: typecheck, focused tests, build, and
   the real flow, with the output pasted.
4. **Review** with `references/loop/review-changes.md` and the matching checklists:
   `references/reviewers/frontend-reviewer.md`, `references/reviewers/backend-reviewer.md`,
   `references/reviewers/database-reviewer.md`, `references/reviewers/accessibility-reviewer.md`.
   Each reviewer only reports; it never edits.
5. **Decide to ship** with `references/loop/release-check.md` and
   `references/reviewers/release-reviewer.md`: a go or no-go, and the rollback path.

## Anti-patterns

- "Done" with a layer stubbed, or with no pasted output behind it.
- Inventing an API, hook, ORM method or config key because it looks like it should exist.
- A happy path with no loading, empty or error state.
- A new dependency or abstraction nobody argued for.
- Hand-copied request and response shapes on two sides of a boundary.
