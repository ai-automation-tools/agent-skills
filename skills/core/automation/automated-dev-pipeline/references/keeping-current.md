# Keeping repos current

A repo that nobody touches goes stale. Its dependencies fall behind, its platforms deprecate
the APIs it calls, its CI actions age out, and the standards it was written to move on. This
is the part of the pipeline that never finishes. It applies to every repo you point it at,
not just the ones the build stages created.

## Contents

- What goes stale
- Six mechanisms, cheapest first
- The refresh session
- The security sweep
- The docs sweep
- One fact, many surfaces
- The status report
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
| **The repo's own docs** | README commands that no longer run, badges and counts that drifted, dead links, a layout or format that wandered from the house standard | The docs sweep, and the upkeep job |
| **Facts repeated across surfaces** | A version, a count, a feature list or a tagline that the README, the homepage, the demo, the landing page and the repo's About box each state, after the app changed one of them | Scripted comparisons in the upkeep job, then a homepage job (see "One fact, many surfaces") |
| **Vendor names** | A vendor renames a product or feature the repo names in prose, UI strings, headings and file names | The refresh session for the prose, then a roadmap item for the rest |
| **The pipeline itself** | Model names in prompts, a CLI flag the runner uses, the scheduler's settings | The audit, and a refresh of the pipeline's own skills |

## Six mechanisms, cheapest first

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
   It also keeps every public list of the repos in step (the landing page, and the account or
   organization profile README, which no build stage touches and which goes stale first), by
   PR. The profile is the most public page you have, so its PR waits for the owner.
   Reporting is the point. Drift nobody sees never gets fixed. Beside it, a weekly
   **status report** gives the owner one page on the whole fleet of repos: what stage each
   is in and whether it is healthy. See below.
3. **A refresh session per repo or workspace.** Research first, then fix, in one PR (design
   rule 7). This handles platforms, APIs, tooling and standards. See below.
4. **A security sweep across every repo.** One weekly session reads what the tools found,
   judges it, looks for what they can't see (code, CI, live headers), fixes what a repo
   change can fix and reports the rest. See below.
5. **A docs sweep across every repo.** A script measures every repo's distance from one
   docs standard each week; a session fixes a rotating share of the repos, Markdown only,
   one PR each. See below.
6. **The roadmap routine.** Anything too big for a refresh PR (a major upgrade, a migration,
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

**Vendor renames need two speeds.** When a vendor renames a product or feature the repo
names, fix the prose in the PR and add "(formerly X)" at the first mention, so readers who
know the old name still find it. Never change a heading, a file name, a URL path, a UI
string, an identifier or test data in a refresh: apps, homepages and other repos link to
those, and a renamed heading breaks its anchor with no error. Add one roadmap item instead,
with "done when" covering the UI, the headings and every link to them, the homepage and
the demo. The roadmap routine can change code and links together.

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

## The docs sweep

A standard that only lives in a skill or a style guide is followed by the repos written
after it and nobody else. Refresh sessions fix facts, the roadmap routine builds features,
and upkeep checks layout, so docs formatting drifts with no owner. One weekly job fixes that.

**1. A script measures, across every repo.** Read-only, from each repo's default branch (not
the owner's working copy): the root and folder headers and footers the standard asks for,
folder indexes, orphan docs nothing links to, broken relative links and anchors, dead outside
links (only 404, 410 and DNS failures; a bot wall is not dead), Markdown that won't render
inside HTML blocks, changelog order, and the writing tells the standard bans. It also lists
**protected docs**: every doc that code, config or another repo names by path. And it checks
every full deep link into the repos (`github.com/<owner>/<repo>/blob/<branch>/<path>#anchor`,
in docs or code) against that repo's tree and headings, because an app's help link to a
moved doc fails silently: the host still serves a page, just not the right one.

**2. The session fixes a share of the repos.** Rotate a third (or a quarter) of the repos a
week by week number, so each PR stays reviewable and every repo comes round within a month.
Per repo, in a worktree: links and anchors first, then indexes and orphans, headers and
footers, outside links, and the prose pass last, with a file cap per run. Markdown only, on
its own branch prefix, with the repo's own checks run before the PR opens.

**3. It never moves anything that something links to.** No file moves or renames, no heading
text changes. Fix the link, never the heading. When the standard wants a rename (a folder's
case, a file name, a heading that carries a vendor's old name), the sweep adds a roadmap item
whose "done when" names every in-repo reference, the homepage and the app's in-app links,
and the repo's roadmap routine does it with the code. The one safe exception is a page title
nothing links to, after a search across every repo shows that.

**4. The standard isn't the sweep's to change.** A flag the session thinks is wrong (a tag
quoted inside backticks, say) goes in the report's "scanner false positives" section, and a
person fixes the script. A session told only "make the scanner quiet" will edit the standard.

## One fact, many surfaces

A public app states the same facts in many places: the README, the docs, the homepage, the
demo, the organization's landing page, the profile README, the repo's About box and topics,
the release list, and the app's own UI and help links. Each surface is written by a
different job or person at a different time, so "the repo says one thing and the app says
another" is the normal state unless something compares them.

- **Name one surface of record per fact.** Version: the package manifest and the newest
  changelog heading (a release tag must match). Feature list and commands: the README.
  Counts: the data in the repo, counted by a script, never a sentence. Tagline: the README's.
  Write this down once, in the upkeep prompt.
- **Compare by script, fix by the job that owns the surface.** Upkeep diffs every other
  surface against the record each week and reports each mismatch as "surface says X, record
  says Y". A homepage job reads that report and fixes the homepage by PR, the landing-page
  PR fixes the cards, and the About box goes through the security wrapper. A mismatch in the
  record itself goes to the repo's roadmap.
- **A card carries its derived assets.** When the landing page shows a screenshot or thumbnail per
  card, whoever adds or repoints a card also runs the page's own capture script for it and commits
  the image with the card; a card without one renders blank on hover and nothing flags it. Write
  the command into the page's runbook. If the capture fails, ship the card anyway and list it in
  the report rather than blocking the stage.
- **A homepage job closes the gap after a big release.** Weekly, per app: what shipped since
  the homepage last changed (changelog, merged PRs) against what the page says. It also opens
  the demo in a browser: a demo built from an old commit, or demo data that no longer shows
  the shipped features, becomes a roadmap item on the app, not an edit to the app.
- **Make the demo say what it was built from.** A build SHA or version in a meta tag or
  footer turns "is the demo stale?" from a judgment into a string compare.
- **Click-test the live sites.** A browser test suite in CI that loads every homepage and
  demo, and keeps one issue open while anything fails, catches what file diffs can't. A
  weekly fix job reads that issue and the upkeep report, root-causes each finding and opens
  one PR per repo.

## The status report

Upkeep, the security sweep and the roadmap routines each report on their own slice. None of
them answers the owner's first question on a Sunday: **what does the whole fleet look like,
and which repos need me?** A weekly status report does, as one page across every active repo.

**1. A script gathers the facts.** Per repo, read-only: visibility, the local folder (which
is the lifecycle stage when clones are filed by stage), last push, latest release, the
homepage's HTTP status, the latest CI run on the default branch (push events only, or the
dependency bot's runs hide the real build), open PRs (how many from routines, how old the
oldest), open issues, the creation date (so a repo new to the fleet is flagged, not
discovered), and the roadmap's open items **above** the release heading, each by its title,
with the owner-only ones marked, plus a count of the items after it. Add the pipeline ledger
and the roadmap status script's output. A source that fails is `NOT READ`, never green.

**2. The session classifies and summarizes, nothing else.** Each repo gets one stage and one
health, by written thresholds so the colours mean the same every week: **red** for a failing
default branch, a homepage that doesn't answer 200, or a routine PR stuck past the sweep's
patience; **amber** for a repo with a roadmap but no push in a month, no open work before its
next gate, items waiting on the owner, or a pile of open PRs. The report leads with three to
five lines on the fleet, then the repos new this week, the ones **almost public** (private,
a few gates left or all done and waiting on approval), red and amber with a reason each, one
table per stage answering per project *is it public, is the roadmap done, what's left*, with a
plain one-line status and links to the repo, its homepage and the running app. Link only URLs
the script saw answer 200 that week (it probes the conventional app address itself), never
ones the model builds, so the report can't send the owner to a dead or guessed page, the pipeline, what changed since last week's report, and what
waits on the owner (pointing at the digest rather than repeating it).

**3. Report only.** It opens no PRs and edits no repo, so it needs no prefix in the sweep and
can run on a mid-tier model in a few minutes. Fixes stay with the jobs that own them. Schedule
it after the week's sweeps, publishes and upkeep finish, so it shows the week's end state, and
before the owner's digest. Email it with the same runner-printed HTML attachment as the
security sweep, and let only a red repo or an unread source turn the email to *attention*.
Unlike the per-run mail, route it to the owner's inbox: it is the one page they read weekly.

## Merge rules for currency PRs

Give each kind its own branch prefix so the sweep can apply a path-based rule:

| Prefix | Merge when | Hold when |
|:---|:---|:---|
| Dependency bot | Patch or minor, CI green | Major version, or any failing check |
| Refresh | Every change is inside the intel folder, docs, and the repo's skills or prompts, and each has a source | It touches source code, CI config, a public contract (API, CLI flags, config schema), or deletes or renames anything |
| Security sweep | Dependency bumps, code or CI fixes with passing tests, ignore-file entries, each traced to a finding in the report | It touches deploy config, a deploy workflow or an auth flow, changes behaviour users will notice (a request that now gets 403), or removes more than the finding needs |
| Review (periodic, hand-curated content) | Each change cites a source and stays inside the reviewed files | It adds, renames or removes an item, or restructures |
| Docs sweep | Only `.md` files change, no file is moved, renamed or deleted, no heading text changes, and the repo's checks pass | It touches anything that isn't Markdown, or a generated, vendored or dated-record file |
| Homepage | Only the homepage's files change, and every fact it adds traces to the repo's default branch | It changes the app, or the homepage lives in a deploying path a person must merge |

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
- **A docs job that renames to meet the standard.** Moving a file or retitling a heading
  breaks every deep link to it, from apps, homepages and other repos, with no error. Queue
  the rename on the roadmap where the code changes with it.
- **Letting a session edit the standard its scanner checks.** It will, to make a flag go
  away. Route disputed flags to a report section for a person.
- **Forgetting the pipeline itself.** Its prompts name models, CLI flags and paths too.
  They go stale the same way, and nothing else is watching them.
