> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `database-engineer` skill. Read it for work in that layer.

# Database engineering

The data layer is the one place where a mistake is not a redeploy away from fixed.
Application code you can revert; a migration that dropped a column or rewrote a
million rows with the wrong default has already destroyed the thing you'd revert
to. So the discipline here is front-loaded: the dangerous step gets flagged and
reasoned about *before* it runs, never explained after. The failure mode this
skill exists to prevent is a fluent, correct-looking migration handed over as
routine when it is quietly destructive, or a schema change that ships with no
index and turns a fast page into a full table scan under real data.

## Flag the destructive migration before running it

Some migrations cannot be safely undone once applied to data that exists.
Treat these as **stop-and-confirm**, called out explicitly before execution,
never run on reflex:

- **Dropping** a column or table — the data is gone; a down-migration recreates
  the column, not its contents.
- **Adding `NOT NULL` to a column with existing rows** — fails outright, or
  silently backfills a default you didn't choose. The safe path is add nullable →
  backfill → then enforce not-null in a later step.
- **Narrowing a type** (`text` → `varchar(50)`, `bigint` → `int`) — truncates or
  errors on data that no longer fits.
- **Renaming** a column or table that live code and other migrations reference —
  breaks readers mid-deploy unless sequenced with the code change.

For each, state what it does to existing data, whether it's reversible, and the
expand/contract alternative if one exists, then let the human decide. A
destructive migration described *after* it ran is a post-mortem, not a heads-up.

## Migrations, always — never hand-edit a schema

Every durable schema change goes through the project's migration tool, checked in
as a migration file, run the normal way. Never hand-edit a production schema and
never apply a change out-of-band that the migration history won't reproduce — the
next environment builds from the migrations, and a schema that exists only in
prod is a landmine for the next deploy. Keep the migration, the ORM model, any
seed data, and the generated types/client in the same change; a migration that
adds a column and a model that doesn't know about it is a half-applied change
that typechecks and fails at runtime.

## Index the columns you actually query

An index missing from a column you filter, join, sort, or enforce uniqueness on is
invisible in development — the table is tiny, everything is fast — and it is the
single most common reason a feature that "worked" grinds to a halt in production.
When you add or change a query, look at its predicates and add the indexes to
match:

- **Filter columns** (`WHERE status = ?`) and **join keys** (foreign keys are not
  automatically indexed in every engine — index them).
- **Sort columns** (`ORDER BY created_at`), especially paired with a filter — a
  composite index in the right column order serves both.
- **Uniqueness** you rely on gets a unique constraint, which is also the index —
  don't enforce uniqueness in application code and hope.

Indexes cost write throughput and storage, so this is "index what you query," not
"index everything." Where you can, confirm the plan with `EXPLAIN ANALYZE` on
representative data rather than guessing — a guess about an index is as unverified
as a guess about anything else.

## Transactions for multi-step writes

If an operation writes in more than one step and the steps must all succeed or all
fail — debit one account and credit another, insert a parent and its children,
update a row and write an audit record — it runs in a transaction. Without one, a
failure between steps leaves the data in a state that should be impossible, and
those are the corruptions nobody notices until the numbers don't add up weeks
later. Scope the transaction to the unit that must be atomic; don't wrap a whole
request in one out of superstition.

## Nullability, defaults, cascades, and backfills are decisions

Every new column makes four choices, and the default of "whatever the tool did"
is how you get surprises. Is it nullable, or required with a default — and if
required on an existing table, what value do the old rows get (that's a backfill,
plan it). What does a foreign key do on delete — cascade, restrict, set null —
and is that what the app actually wants (an accidental `CASCADE` deletes children
you meant to keep; a missing one leaves orphans). Make each choice on purpose and
note the backfill when one is needed. A backfill of a large table is itself a
migration with a runtime and a lock profile — say so.

## Verify

Run the migration against a real local database — up, and the down if it claims to
be reversible — and confirm the schema is what you intended. Run the queries that
matter and, for anything performance-sensitive, look at the plan. Run the tests
that touch the changed tables and read the output. Report what you ran: "migration
applies and rolls back cleanly on local Postgres; the index is present and
`EXPLAIN` uses it" is verified; "wrote the migration, looks correct" is not.
Flag anything you could only reason about because you couldn't run it against real
data volume.


## Where this comes from

Query and connection guidance follows [**Node.js Best Practices**](https://github.com/goldbergyoni/nodebestpractices)
(section 6 for injection and secrets, section 5 for pooling under load) and the
PostgreSQL manual for anything about locking or index choice. When those two
disagree with a framework's ORM docs, they win — an ORM's defaults optimize for
getting started, not for the row count you will have in a year.
