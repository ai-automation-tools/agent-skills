> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `/test-and-build` command. Follow it as a procedure.

# Run the verification ladder

Run the checks in order — typecheck → lint → focused tests → full suite → build —
stop at the first red, and paste the actual output. Scope: **the feature you were given**
(default: the current working changes and the package/scripts at the repo root).
Invoke the `../layers/devops-release.md` skill for build and environment specifics. This
command's entire purpose is to produce evidence, so its cardinal rule is: **never
report green without the output that proves it.**

## Instructions

1. **Find the real commands first.** Read `package.json` scripts (or the Makefile,
   the CI config, the repo's own docs) to get the *actual* commands this project
   uses — `npm run typecheck`, `npm run lint`, `npm test`, `npm run build`, or
   whatever they really are. Don't assume a script exists because it usually does;
   if there's no typecheck script, say so rather than inventing one. Run each with
   the venv/toolchain the repo expects.

2. **Run the ladder in order, cheapest and most-local first.** Each rung catches a
   different class of failure and the order is deliberate — a typecheck failure
   makes running the full suite a waste:
   1. **Typecheck** — the shapes line up.
   2. **Lint** — the obvious defects and style violations.
   3. **Focused tests** — the tests around what changed. Fast, targeted, the ones
      most likely to catch your own bug.
   4. **Full suite** — regressions elsewhere, when the change's risk warrants it
      and it's practical to run.
   5. **Build** — it actually compiles/bundles for production.

3. **Stop at the first red.** A red rung usually makes the rungs above it
   meaningless, and running them anyway buries the real failure under noise. Halt,
   read the failure, and diagnose it — what failed, in which file, why. Then say
   whether it's a real defect in the change, a flaky/environmental issue, or a
   pre-existing failure unrelated to this work (and prove that claim — "already
   red on a clean checkout" needs the clean-checkout run, not an assertion).

4. **Paste the actual output, not a paraphrase.** The test summary line, the
   compiler error, the build tail — the real text. "Tests pass" with no output is
   precisely the unverified claim this skill exists to prevent, and it is
   indistinguishable from a lie until someone re-runs it. Redact any secret that
   appears in the output on sight; keep everything else.

5. **Report what you could not run, and why.** A rung that needs a seeded database
   you don't have, network access that's gated, or a service that's down is a rung
   you *skipped*, not one that passed. Name it as skipped and say what it would
   take to run it. An honest gap is fixable; a silent one gets discovered in
   production.

## Reporting

Lead with the ladder as a status line — which rungs ran, which are green, which is
red, which were skipped — followed immediately by the pasted output for anything
that ran. If a rung is red, lead with *that*: the failure, the diagnosis, and
whether it's yours. Do not summarize a run as passing without the artifact under
it. If everything genuinely passed and you have the output to show it, say so
plainly — that's the whole point of running the ladder.
