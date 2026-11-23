> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `frontend-engineer` skill. Read it for work in that layer.

# Frontend engineering

The UI is where "looks right" and "is right" diverge the most, because a
screenshot of the happy path fools everyone including the person who built it.
The failure mode here is a component that renders beautifully with the one hard-
coded record the developer tested, and falls apart the moment the data is
loading, empty, or errored — none of which appear in the demo. Build for all four
states or you have built a prop, not a feature.

## The four states are the feature

Every async flow the user can see has four states, and three of them are the ones
that get skipped: **loading, empty, error, success.**

- **Loading** — what fills the space while the request is in flight. A skeleton or
  spinner that reserves the final layout, not a jump from nothing to content.
  Reserving the space is also how you avoid layout shift (below).
- **Empty** — the list came back with zero rows. This is a designed state with a
  message and usually an action ("No invoices yet — create one"), not a blank
  region the user reads as a bug.
- **Error** — the request failed: a 400, a 500, a dropped connection, a timeout.
  The user sees a human message and, where it makes sense, a retry. The one thing
  the error path must never do is fail silently into a blank screen, because that
  is indistinguishable from success that rendered nothing.
- **Success** — the happy path. The only one you'll get for free.

If you wrote a component that calls an API and it has one return branch, you are
not done. Wire these before you call the feature complete, and drive at least the
error and empty branches to confirm they render — don't assume the code you wrote
for them runs.

## Accessibility is not a later pass

Inaccessible markup is a correctness bug, not a polish item, and it is invisible
in a screenshot — which is exactly why it gets shipped. The floor:

- **Every input has a real label** — a `<label>` associated with the control, not
  a placeholder pretending to be one (placeholders vanish on focus and are
  invisible to screen readers). Buttons and icon-only controls have accessible
  names.
- **Keyboard works.** Every interactive element is reachable and operable with
  Tab and Enter/Space, focus order follows reading order, and focus is visible —
  do not remove the focus ring without replacing it with a visible one. A `div`
  with an `onClick` and no keyboard handler is broken for keyboard and screen-
  reader users; use a real `<button>`.
- **Semantic HTML first.** Heading levels descend in order (`h1` → `h2`, no
  skips), lists are lists, the one `<main>` is `<main>`. Reach for ARIA only to
  describe what native elements can't; a correct native element beats an ARIA
  patch on a wrong one.
- **Contrast and motion.** Text meets contrast minimums; don't encode meaning in
  color alone. Respect `prefers-reduced-motion` for anything that animates.

You cannot fully verify this by reading the code. Drive it: Tab through the new
UI, confirm focus is visible and lands where it should, check that labels are
associated. If a browser-driving tool is available, use it.

## Client state and server state are different things

The most common state bug is treating data that lives on the server as if it
lives in the component. Server state — the list of records, the current user's
profile — is a cache of something remote: it goes stale, it needs refetching, it
can fail to load. Copying it into `useState` and mutating the copy gives you two
sources of truth that drift the instant anyone else changes the data. Use the
app's server-state tool (TanStack Query, SWR, a loader) for remote data and keep
`useState` for genuinely local UI state — is this menu open, what's typed in this
field. Don't invent a second pattern when the repo already has one.

## Layout shift and gratuitous dependencies

**Layout shift** is the content jumping as things load — an image with no
dimensions, an async block that pushes everything down when it arrives, a font
swap that reflows text. Reserve space up front: dimensions on media, min-heights
on async regions, skeletons shaped like their content. This is the same discipline
as the loading state, seen from the layout side.

**A new UI dependency is a claim the platform and the existing stack couldn't do
the job.** A date picker, a dropdown, a modal library — most are a few
accessible elements and some CSS the app can already express, and each one is
bundle weight, an accessibility surface you didn't audit, and a maintenance
liability. Match the app's existing component and styling patterns first. If a
dependency genuinely earns its place, say why in the report rather than adding it
silently.

## Verify

Typecheck the files you changed. Run the component tests around the new behavior
and read the output. Then load the actual UI and drive the states — especially
the three that aren't the happy path — because a passing typecheck proves the
props line up, not that the empty state renders. Report what you drove and what
you couldn't; "typechecks and renders the success and error states; I did not
test the empty state against a real empty response" is an honest handoff.
