> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `/plan-feature` command. Follow it as a procedure.

# Plan a feature across the layers

Map a feature across every layer it touches *before* a line of code is written,
and write the map to `docs/plans/<slug>.md`. Feature: **the feature you were given** (default:
the feature named in the "App" / status lines at the top of the repo's `AGENTS.md` or `CLAUDE.md`; if
that's still a bracketed placeholder, ask — a plan for an unstated feature invents
its own scope). This command produces a **plan, not code.** Invoke the
`full-stack-feature` skill for the layer-mapping method.

## Instructions

1. **Read the existing patterns before planning anything.** A plan written from
   general knowledge of "how React apps work" is worthless; a plan written from
   *this* app's routing, data-fetching, error-handling, validation, and migration
   patterns is a map someone can follow. Open the neighbors — an existing route
   that fetches and mutates, an existing migration, an existing component with its
   states — and plan to build through them. If the feature needs a pattern the app
   doesn't have yet, that's a decision to name in the plan, not a default to reach
   for silently.

2. **List every layer the feature touches, concretely.** Frontend: which
   components and routes, what they show and collect, which of the four async
   states apply. API: which endpoints, what each validates and returns, any auth
   or tenancy check. Data: new columns, tables, indexes, constraints — and whether
   any of it is a destructive migration that needs flagging (see
   `../layers/database-engineer.md`). External: any third-party call, its failure mode, its
   secret. A layer you can't describe concretely is a layer you haven't understood
   yet — that gap is a finding for the plan, not something to smooth over.

3. **Call out migration, config, and env needs explicitly.** Name every schema
   change and whether it's reversible; every new environment variable and what
   it's for; every config or deploy change. These are the things that get
   discovered halfway through implementation and force a rewrite — surfacing them
   now is most of the value of planning at all. Flag any destructive migration
   here, loudly, so the human sees it before code exists.

4. **Identify the smallest coherent path.** The thinnest complete column a user
   can actually walk end-to-end — UI → API → data → back — with nothing stubbed
   that you'd later call "done." Say what's in that first slice and what's
   deliberately deferred to a later one. A plan that tries to build every layer to
   full width at once is how features stall with three half-done tiers and nothing
   that runs.

5. **Write the verification plan.** State, before any code exists, how the finished
   slice will be *proven* — which typecheck, which focused tests to add and at
   what boundary, and the real end-to-end path to exercise (drive this endpoint,
   load that page, submit that form, watch that record change). A feature with no
   verification plan is one that will be "verified" by assertion later. Name the
   things that will be hard to verify locally now, while there's still time to
   arrange for them.

6. **List the risks and open questions.** The destructive migration, the external
   dependency you don't control, the auth boundary, the assumption you're making
   about an unread part of the codebase. Each risk names what would resolve it.
   Don't pad the list, and don't hide the one that actually worries you.

7. **Write the plan to `docs/plans/<slug>.md` and do not write feature code.** The
   deliverable is the file. Confirm before overwriting an existing plan. If the
   feature is genuinely too underspecified to map — you can't name the decision it
   serves or the layers it touches — say so and ask, rather than inventing a
   scope to have something to write.

## Reporting

Lead with the smallest coherent path and the layers it crosses — that's what the
reader acts on. Call out the migration, config, and env needs by name, flagging
any destructive migration first. State how the slice will be verified and which
parts will be hard to verify locally. List the top risks, the real one first.
Point at the plan file. Do not report any code as written — this command writes a
plan.
