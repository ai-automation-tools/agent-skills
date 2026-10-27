# Keeping repos current

A repo that nobody touches goes stale. Its dependencies fall behind, its platforms deprecate
the APIs it calls, its CI actions age out, and the standards it was written to move on. This
is the part of the pipeline that never finishes. It applies to every repo you point it at,
not just the ones the build stages created.

## Contents

- What goes stale
- Five mechanisms, cheapest first
- The refresh session
- The security sweep
- Merge rules for currency PRs
- Cadence
- Anti-patterns

## What goes stale

| Kind | Examples | Usually caught by |
|:---|:---|:---|
| **Dependencies and runtimes** | Outdated packages, a runtime version past end of life, lockfile drift | Dependabot or Renovate, plus CI |
| **Security** | Advisories on a dependency, a leaked-secret pattern, a control switched off, an injectable route, an over-permissioned workflow | Dependabot alerts, secret scanning, the security wrapper's weekly read-back, then the security sweep |
| **Platforms and APIs** | A deprecated endpoint, a changed rate limit, a new auth requirement, a renamed model | A refresh session reading release notes and changelogs |
| **Tooling and CI** | Deprecated GitHub Actions versions, a linter rule set that moved, a build tool's new default | CI warnings, then a refresh session |
| **Standards and practice** | Accessibility guidelines, docs conventions, API design norms, a better testing pattern | A refresh or review session with cited sources |
| **The repo's own docs** | README commands that no longer run, badges and counts that drifted, dead links | The upkeep job |
| **The pipeline itself** | Model names in prompts, a CLI flag the runner uses, the scheduler's settings | The audit, and a refresh of the pipeline's own skills |

## Five mechanisms, cheapest first

Use the cheapest one that catches each kind of drift. An AI session is the most expensive
and the least repeatable, so it gets only what the tools can't do.

1. **Tools that already do it.** Dependabot or Renovate for version bumps, CI for "does it
   still build", GitHub's secret scanning and push protection. Turn them on through the
   security wrapper so they're read back, not assumed. Their PRs go through the same sweep
   under their own branch prefix, with a merge rule like "patch and minor bumps merge when
   CI is green; majors are held".
2. **The upkeep job reports.** Once a week it checks what's measurable across every repo:
   main is green, controls are on, no PR is stuck, docs match reality, every task still
   runs. It fixes only a short allow-list (a homepage URL, a count) and reports the rest.
   Reporting is the point. Drift nobody sees never gets fixed.
3. **A refresh session per repo or workspace.** Research first, then fix, in one PR (design
   rule 7). This handles platforms, APIs, tooling and standards. See below.
4. **A security sweep across every repo.** One weekly session reads what the tools found,
   judges it, looks for what they can't see (code, CI, live headers), fixes what a repo
   change can fix and reports the rest. See below.
5. **The roadmap routine.** Anything too big for a refresh PR (a major upgrade, a migration,
   a redesign to a new standard) becomes a roadmap item. The routine that builds new
   features then does the work one verified step at a time. The refresh session is allowed
   to *add* such items; it doesn't attempt them.

## The refresh session

One session per repo (or per group of repos that share a field), on a schedule. Two steps,
in this order:

**1. Record what changed, with sources.** Search for changes since the last refresh in the
things this repo depends on: its dependencies' release notes, its platforms' changelogs and
deprecation notices, advisories, and the standards it follows. Write them to a dated intel
file in the repo (for example `docs/intel/<yyyy-MM-dd>.md`), one entry per change:

```markdown
- **<what changed>** (<date of the change>). <one line on what it means for this repo>.
  Source: <url>. Action: <fixed in this PR | roadmap item added | none needed>
```

Keep only changes with a primary source: a release note, an advisory, a spec, an official
changelog. A blog post saying "X is deprecated" is a lead, not a source. Follow it back.

**2. Fix what that intel makes stale, and nothing else.** Every edit in the PR traces to an
entry in the intel file. Small, safe fixes go in the PR: a pinned action version, a renamed
config key, a docs correction, a skill or prompt that names an outdated model. Anything that
changes behaviour, needs a migration, or would fail the repo's tests goes to the roadmap as
a new item instead.

Then open one PR with the intel file, the fixes and any new roadmap items. A week with no
relevant changes is a valid outcome: write "no changes found since <date>" and open no PR.

The runner injects today's date into the prompt. Without it, a session's sense of "latest"
is its training cutoff, and it will "update" things to versions that are already old.

## The security sweep

The scanners in mechanism 1 find patterns. They can't tell a leaked key from a docs
placeholder, and they miss most real holes: an API route with no auth, a page that puts
untrusted text in `innerHTML`, a workflow that runs a fork's code with secrets in scope.
One weekly session across **every active repo** covers that gap. It is one job, not one per
repo, because the same judgment applies everywhere and the report is only useful whole.

**1. A script gathers the evidence, the session judges it.** Before the session starts, the
runner collects per repo, read-only and the same every week:

- the security settings (secret scanning, push protection, dependency alerts);
- open dependency, secret-scanning and code-scanning alerts;
- a secret scan (gitleaks or similar) of the **deploy branch's** history, redacted, scoped
  with `--log-opts=<branch>` so it never wanders into the owner's stale local branches,
  honouring the repo's own ignore file **as it is on that branch**;
- tracked `.env` files.

A source that fails is printed as `NOT READ` and reported as not checked, never as clean.
The session then sorts each finding into real, false positive or not checked, grades it
Critical to Low, and reviews what no scanner reads: code (injection, XSS, SSRF, missing auth
or validation, server keys in client bundles), CI (`pull_request_target` with the PR's code,
`${{ github.event.* }}` in a `run:` step, no `permissions:` block), extension manifests,
personal data in public repos, and **passive** checks of the live sites it owns (headers;
`/.env` and `/.git/` must not answer 200).

**2. Fix in the repo, one PR per repo, on its own prefix.** Non-major dependency bumps, the
smallest change that closes a code or CI hole (with a test that fails without it), a secret
moved out of the tree into `.env`, and the fingerprints of false positives it actually
opened and judged, added to the repo's ignore file with a one-line reason each, so next
week's scan is quieter. On a public repo the PR is public: describe what was fixed, never a
working exploit.

**3. Report, and leave the owner's part to the owner.** A dated report (counts by severity,
new and resolved since last week, findings per repo, what needs the owner, what wasn't
checked) is kept and emailed. Render the HTML in the session but have the **runner** print
it between attachment markers, so the markers always sit on lines of their own.

The session never uses, tests or prints a credential, never rotates one, never rewrites
history, never changes a repo setting or a deploy workflow, and never edits a repo that
moves money; those go to the top of the owner's list with the exact command. Removing a
leaked key from the tree does not un-leak it, so the PR says so and rotation comes first.

## Merge rules for currency PRs

Give each kind its own branch prefix so the sweep can apply a path-based rule:

| Prefix | Merge when | Hold when |
|:---|:---|:---|
| Dependency bot | Patch or minor, CI green | Major version, or any failing check |
| Refresh | Every change is inside the intel folder, docs, and the repo's skills or prompts, and each has a source | It touches source code, CI config, a public contract (API, CLI flags, config schema), or deletes or renames anything |
| Security sweep | Dependency bumps, code or CI fixes with passing tests, ignore-file entries, each traced to a finding in the report | It touches deploy config, a deploy workflow or an auth flow, changes behaviour users will notice (a request that now gets 403), or removes more than the finding needs |
| Review (periodic, hand-curated content) | Each change cites a source and stays inside the reviewed files | It adds, renames or removes an item, or restructures |

A held PR is fine. The refresh still did its job by writing the change down, and a person
decides the rest.

## Cadence

Match cadence to how fast the field moves, not to a round number:

| Field | Refresh |
|:---|:---|
| Security (advisories, exploited-vulnerability lists) | Weekly |
| Fast-moving platforms (AI models and APIs, frontend frameworks) | Weekly |
| Most libraries and tooling | Every two weeks or monthly |
| Standards, hand-curated content, reference docs | Monthly or quarterly |

Schedule each refresh so its PR is waiting when the sweep runs, and before anything that
consumes its output. For example, a refresh that fixes shared skills should merge before the
job that copies those skills elsewhere.

## Anti-patterns

- **"Update everything to latest."** Without sources and without the tests passing, that's a
  model guessing what "latest" means.
- **Two jobs on one repo and topic**, like an intel job and a separate fix job. They collide
  on `main` and double the PRs. Make them one session.
- **A refresh that attempts a major migration.** It won't fit in one verified PR. Add a
  roadmap item and let the routine do it in steps.
- **Refreshing repos nobody reads the output of.** If the PRs pile up held and unread, cut
  the cadence or the scope before adding more jobs.
- **A security sweep that tests the keys it finds.** Calling a service with a leaked key to
  "confirm" it is using a stolen credential. Judge it from the file, report it, rotate it by
  hand.
- **Suppressing scanner hits without opening them.** An ignore-file entry is a judgment; one
  added in bulk to quiet the report hides the one real key among the placeholders.
- **Forgetting the pipeline itself.** Its prompts name models, CLI flags and paths too.
  They go stale the same way, and nothing else is watching them.
