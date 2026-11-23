> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `/release-check` command. Follow it as a procedure.

# Pre-deploy readiness gate

Produce a go / no-go on whether the current changes are safe to deploy. Check the
things that take production down — env vars, migration ordering, a smoke path, a
rollback, committed secrets — and return a verdict with evidence. Scope:
**the feature you were given** (default: the changes staged for the next deploy on the current
branch). Invoke the `../layers/devops-release.md` skill. This command **gates; it does not
deploy.**

## Instructions

1. **Verify required environment variables are present and documented.** Diff what
   the code now reads (`process.env.X`, `import.meta.env.X`, config lookups)
   against what the deploy environment actually provides and what `.env.example` /
   the deploy docs record. A variable the code needs, that's set on your machine
   and documented nowhere, is the classic post-deploy outage: build passes, deploy
   succeeds, feature is broken because the var isn't in prod. Flag every new or
   changed variable. Never print a secret's value — presence and name only.

2. **Check migrations are pending, ordered, and sequenced against the deploy.**
   Are there unapplied migrations in this release? Do they run in an order that
   won't break live code mid-deploy — a column the new code reads must exist
   before that code serves traffic; a rename must be sequenced expand-then-
   contract. Flag any destructive migration (drop, non-null on existing rows, type
   narrow) loudly, and confirm it has a recovery path. A migration that's safe in
   isolation can still break a rolling deploy by ordering alone.

3. **Confirm a smoke path exists for the critical workflow.** Name the one or two
   user flows that *must* work after this deploys, and the concrete way to confirm
   each within minutes of shipping — a URL that should answer, a health check, a
   login that should succeed. "We'll see if anyone complains" is not a smoke
   check. If you can run the smoke path against a local or preview build now, do
   it and paste the result.

4. **Confirm a rollback path.** Can this deploy be reverted to the previous
   version, and does anything in it — a migration, a data change, an external
   side effect — make rollback unsafe or one-way? If rollback isn't clean, that's
   not automatically a no-go, but it *is* a fact the human must have before
   shipping, stated plainly, not buried.

5. **Scan for committed secrets and machine-local leakage.** Check the diff for
   keys, tokens, connection strings, a `.env` that slipped past `.gitignore`, and
   for absolute local paths or `localhost` URLs baked into what will ship. In
   frontend builds, remember anything inlined at build time reaches the browser —
   a secret in a public-prefixed var is a published secret. A single committed
   credential is a stop-the-line finding.

6. **Confirm the build was actually run, not assumed.** A readiness check resting
   on "the build should be fine" has verified nothing. If a clean build isn't
   already evidenced in this session, run it (or invoke `../loop/test-and-build.md`) and
   cite the result. "Should deploy fine" is the exact claim this gate exists to
   reject.

## Reporting

Open with the verdict in one word — **GO** or **NO-GO** — and the single reason
if it's no-go. Then a short checklist with each item marked pass / fail / not-
verifiable and the evidence beside it: env vars (names only), migration ordering
and any destructive flag, the named smoke path, the rollback answer, the secret
scan, the build result. List every blocker that must clear before deploy and every
risk that's being accepted knowingly. Do not deploy — this gate hands a decision
to the human; shipping is their call and their command.
