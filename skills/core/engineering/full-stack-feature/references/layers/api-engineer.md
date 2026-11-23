> Part of the [`full-stack-feature`](../../SKILL.md) skill. Folded in from the archived
> fullstack-agent workspace on 2026-11-16, where it was the `api-engineer` skill. Read it for work in that layer.

# API engineering

The API is the trust boundary. Everything inside it you wrote and can trust;
everything arriving at it — request bodies, query params, headers, webhook
payloads, env config, the response from someone else's service — is hostile until
proven otherwise. The failure mode this skill prevents is code that reads the
happy request, does the happy thing, and returns the happy shape, with no
thought given to the malformed body, the missing field, the expired token, or the
upstream service that never answers. That code demos perfectly and breaks in
production the first time reality sends something unexpected.

## Validate at the boundary, narrow before use

Parse and validate every piece of external input at the edge, before it touches
any logic — with the app's existing validation tool (Zod, Joi, a schema
validator), not a pile of hand-rolled `if` checks that miss a case. `req.body`
is `unknown`, not the type you wish it were; narrow it, then trust the narrowed
value. This is not defensive theater: an unvalidated field is a runtime crash, a
corrupted row, or an injection waiting for the input that the happy-path test
never sent. The same applies to the *responses* of services you call — an
external API's JSON is external input too, and "it's always shaped like this"
holds until the day it doesn't.

Never concatenate user input into a query. Parameterized queries or the ORM,
always — see `../layers/database-engineer.md`.

Server actions and server functions are routes. Each one is a public POST endpoint
that anyone can call with any payload, so validate its arguments, check the caller's
authorization inside it, and keep the framework patched: the React Server Components
packages had a critical unauthenticated RCE and a high DoS fixed in 19.3.1 (see
current advisories (GitHub Advisory Database, the vendor's own), 2026-11-10). The same goes for a database filter built from
request data: `{ "$ne": null }` in a body is an operator, not a string, so use the
ORM's sanitize option or validate the field's type first.

## Errors have one shape and the right status code

Pick the app's error envelope and use it everywhere — `{ error, code }` or
whatever the repo already returns — so callers can handle failures uniformly
instead of pattern-matching three different shapes. Then get the status code
right, because clients and monitoring make decisions on it: 400 for malformed
input, 401 unauthenticated, 403 authenticated-but-forbidden, 404 not found, 409
conflict, 422 for semantic validation failure, 429 rate-limited, 500 for *your*
bug. Returning 200 with an error in the body, or 500 for a user's bad input, both
lie to the caller. And error responses must not leak internals — a stack trace,
a SQL fragment, or a raw upstream error handed to the client is both a bad
experience and an information disclosure.

## External calls fail predictably instead of hanging

Every call that leaves the process — an HTTP request, a third-party SDK, a
database on another host — can be slow, flaky, or down, and the default behavior
of most clients is to wait **forever.** One upstream hang with no timeout ties up
a worker, then a pool, then the whole service, for a dependency you don't even
control. So: **set an explicit timeout on every outbound call.** Decide what
happens on failure — retry with backoff for idempotent operations, fail fast and
surface a clean error for the rest — and make writes idempotent (an idempotency
key, an upsert) where a retry or a double-delivered webhook could otherwise
charge the card twice. Do not invent a client's timeout or retry option because
it sounds plausible; confirm it exists in the version the repo pins.

## Authorization and tenancy are explicit, on every route

Authentication asks *who are you*; authorization asks *are you allowed to touch
this specific object* — and the second is the one that gets skipped. A handler
that loads a record by an ID from the URL without checking the record belongs to
the caller is a broken-access-control bug: user A requests `/invoices/123` and
reads user B's invoice. Every route that touches user-scoped data checks
ownership or tenant, in code you can point to, not "the middleware probably
handles it." In a multi-tenant app, every query is scoped to the tenant; a
missing `WHERE tenant_id = ?` is a data breach, not a bug.

## Secrets stay out of logs

Log enough to debug — a request ID, the route, the failure category — and never
the secret. API keys, tokens, connection strings, passwords, full request bodies
that contain them, the `Authorization` header: none of these go to stdout, a log
sink, an error tracker, or a test fixture. Redact on the way in. A logged token
is a committed token once the logs are stored.

## Verify

Typecheck, then exercise the boundary — both sides of it. Send the endpoint a
valid request and confirm the success shape and status. Then send it the invalid
ones: the missing field, the wrong type, the unauthorized caller, the oversized
payload, and confirm each returns the right status and a safe error. Run the
tests around the failure paths and read the output; the happy-path test passing
tells you nothing about whether the boundary holds. Report what you exercised and
what you couldn't — "validated success and the 400/401 paths; did not test the
timeout path because I can't force the upstream to hang" is honest.


## Where this comes from

The patterns here are the ones [**Node.js Best Practices**](https://github.com/goldbergyoni/nodebestpractices)
settled, and it is worth citing rather than re-deriving — it is the reference the
Node ecosystem actually defers to. Relevant sections: error handling (2.x),
security (6.x), and going to production (5.x).

Cite it when a reviewer pushes back. "This is the documented convention" lands
better than "this is how I'd do it", and it is also just true.
