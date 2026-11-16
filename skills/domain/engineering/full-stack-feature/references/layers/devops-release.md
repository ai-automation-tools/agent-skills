> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `devops-release` skill. Read it for work in that layer.

# DevOps and release

This is the layer where being wrong is most public and least local. A broken
component shows up on one screen; a broken build config or a missing production
env var takes the whole app down, and it does it in the one environment you were
most confident about. The failure mode this skill prevents is the config change
made by pattern-matching — edit the YAML until it looks like the examples, push,
"that should fix CI" — with nothing reproduced, nothing run, and the actual
failure never understood.

## Reproduce the failure before you change the config

You cannot fix a build you didn't reproduce. Before editing CI or build config,
run the failing command locally — the exact command the pipeline runs, `npm run
build`, `npm ci`, the Docker build — and see the failure yourself. A config edit
made against a guess about the cause fixes nothing and often adds a second
problem, and "this should fix CI" pushed straight to the pipeline turns the shared
build into your debugger, one slow red run at a time. If the failure genuinely
only reproduces in CI (a platform difference, a missing secret, an env-specific
path), that itself is the finding — narrow it to *what* differs before you touch
anything.

## Don't claim a build you didn't run

"Should deploy fine" and "the build is clean" are claims, and a claim about a
build is worthless without the build. Run it, watch it finish, read the tail of
the output. A green build is the minimum evidence for saying a change is
deploy-ready; a config that looks right and was never run is exactly the fluent-
but-unexecuted output this whole skill is organized against. See
`../loop/test-and-build.md` for the ordered ladder.

## Secrets and machine-local paths stay out of artifacts

Two things leak into build output and both are quiet:

- **Secrets** — an API key baked into a client bundle, a token echoed in a build
  log, a `.env` copied into a Docker image, credentials in a screenshot. In
  frontend builds especially, remember that anything inlined at build time ships
  to the browser: a secret in a `VITE_`/`NEXT_PUBLIC_` variable is a published
  secret. Secrets are referenced through the platform's env/secret mechanism and
  injected at runtime, never committed and never printed.
- **Machine-local assumptions** — an absolute `D:\Users\...` path, a hard-coded
  `localhost` URL, a port that only exists on your box, a dependency you installed
  globally and forgot. These pass locally and fail in the clean CI environment.
  Prefer relative paths and env-driven config; the artifact should carry no trace
  of the machine that built it.

## A CI run that breaks with no code change is probably the platform

Moving labels and runtimes change under a pipeline that nobody edited. Before
blaming the last commit, check the runtimes' and actions' current release notes for these:

- **`ubuntu-latest`** is migrating from 24.04 to 26.04 between 2026-10-19 and
  2026-11-19. Pin `ubuntu-24.04` until the build is tested on 26.04.
- **JavaScript actions run on Node 24 only.** A third-party action still declaring
  `node20` in its `action.yml` fails. Check before pinning an action version.
- **Vercel no longer accepts Node 20** for new deployments (`engines.node` is the
  fix), and `ubuntu-22.04` runners retire around 2027-04.

## Keep deploy changes minimal and reversible, with a rollback path

Change the least that fixes the problem — a deploy config diff should be readable
in one screen, not a rewrite that also "cleans up" three unrelated things and
becomes impossible to bisect when the deploy goes wrong. And before shipping,
know the way back: can this deploy be rolled back to the previous version, does a
schema migration in this release have a safe reversal or at least a documented
recovery, is there a health check or a log line that tells you within minutes
whether the new version is actually serving. A deploy with no rollback path is a
bet that you're right, placed in the one environment where being wrong is most
expensive.

## Document env vars without their values

When a change needs a new environment variable, record it — its name, what it's
for, and an example placeholder — in `.env.example` or the deploy docs, never
with the real value. The next person setting up an environment finds out what
`STRIPE_WEBHOOK_SECRET` is for from the docs, and finds out its value from the
secret store. A required variable that's set on your machine and documented
nowhere is the classic "works on my machine" outage: the build passes, the deploy
succeeds, and the feature is broken in prod because the variable isn't there.

## Verify

Run the build. Run the CI-equivalent commands locally if the pipeline can't be
triggered safely. For a production-facing change, walk the smoke path — does the
deployed thing actually answer, does the health check pass — and confirm the
rollback path exists before you'd need it. Report the exact commands and their
output, the env vars the change requires, and anything you could only verify in a
local proxy for the real environment. `../loop/release-check.md` turns this into a go/no-go
gate. "The build passes locally and I've documented the new env var; I could not
verify the production deploy because that's gated" is the honest handoff — never
"deployed successfully" for something you didn't watch deploy.
