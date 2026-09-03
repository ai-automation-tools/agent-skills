# Config schema & architecture — extracted from a reference `Hub/hub.mjs`

Source of truth: the `Hub/hub.mjs` engine you're pointing this skill at, and its
`README.md`. This file exists so Mode A/B scaffolding doesn't require re-reading ~2,500
lines of source every time — but if something here disagrees with the live file, the live
file wins and this doc should be corrected.

## `hub.config.json`

```json
{
  "name": "MyProject",
  "dir": "D:/dev/MyProject",
  "port": 4273,
  "title": "Project Hub — MyProject",
  "favicon": { "glyph": "M", "ink": "#5fe3a1", "line": "#2f6b52" },
  "repoScope": { "groups": ["Live_Apps", "Other_Apps", "Tools", "Draft"] }
}
```

| Key | Required | Validated as | What it does |
|:---|:---:|:---|:---|
| `name` | ✅ | non-empty string | Display name of the workspace root; the label on the tree's top node. |
| `dir` | ✅ | must exist on disk | Absolute path to the workspace. Backslashes and a trailing slash are normalized — write it with forward slashes for portability. |
| `port` | ✅ | integer, `1024`–`65535`, unique across sibling configs | The port this hub serves on. Pick a house convention (e.g. a `427x` block) and avoid `4173`/`5173` — Vite's own preview defaults, easy to collide with on a dev machine. |
| `title` | optional | string | Browser tab title. Defaults to `Project Hub — <name>`. |
| `favicon` | optional | `{ glyph, ink, line }` | `glyph` = 1–2 characters, `ink`/`line` = hex colors. The favicon SVG is built server-side from these three values — no image asset needed. |
| `repoScope` | optional | `{ groups: string[] }` **or** `{ pathPrefix: string }`, never both | Which repos reach the overview's repo table. `groups` for a `Repos/<group>/` tier (e.g. `Live_Apps`/`Other_Apps`/`Tools`/`Draft`); `pathPrefix` for a flat `Repos/` folder; omit entirely to scope every repo the scanner finds anywhere under `dir`. |

`loadConfig()` throws (rather than silently defaulting) on: unreadable/non-JSON file,
missing `name`/`dir`/`port`, a `dir` that doesn't exist, a `port` outside range, or both
`repoScope.groups` and `repoScope.pathPrefix` set. The test suite (`hub.test.mjs`)
exercises all of these plus cross-config port-uniqueness — run `npm test` after writing a
new config, don't just eyeball it.

## Shared roots (`ROOTS`) and user runtimes (`USER_RUNTIMES`)

Every hub can scan more than just its own `dir` — a typical engine also carries a couple
of extra shared roots so every hub surfaces the same cross-project docs/skills alongside
its own workspace:

```js
const ROOTS = [
  { name: CONFIG.name, dir: CONFIG.dir, tint: 'var(--green)' },
  { name: 'Shared Docs', dir: '<absolute path to a shared docs folder>', tint: 'var(--red)' },
  { name: 'Shared Skills', dir: '<absolute path to a shared skills folder>', tint: 'var(--magenta)' },
];
```

Any extra roots beyond `ROOTS[0]` are hardcoded in the engine and identical across every
sibling hub — that's what lets every hub show the same shared, machine-wide content
alongside its own project-specific `dir`. Whether an install has zero, two, or five of
these depends entirely on that install; adjust the example above to match yours.

`USER_RUNTIMES` is a second hardcoded list — home-directory tool folders such as
`~/.claude`, `~/.codex`, `~/.gemini`, or whatever agent CLIs the install cares about —
each entry naming its `dirs` (skills, agents, commands, hooks, …), top-level `files` to
surface, and config paths for MCP servers / installed plugins. This is what populates the
**User CLIs** section, identical across every hub because it reflects the machine's home
directory, not the workspace.

**Mode A never touches either constant** — a new hub just gets a new `ROOTS[0]`
(`CONFIG.name`/`CONFIG.dir`) for free from its own config; the other roots and every user
runtime come along automatically.

**Mode B** (a standalone copy shipped outside this machine's layout) is exactly the case
where you *do* edit these two constants — drop `Documents`/`My Custom Skills` if the new
environment has no equivalent, and drop or rewrite `USER_RUNTIMES` entries for whatever
agent CLIs the new environment actually has (or none, if it's not an agent-tooling
project at all).

## HTTP endpoints

| Path | What it does |
|:---|:---|
| `/api/scan` | The whole payload — tree, stats, repos, runtimes, root docs, search-relevant fields. Gzipped. `?fresh=1` forces a rescan instead of serving the cached one. |
| `/api/file?path=` | One document, rendered to HTML (markdown → `md2html()`, HTML sanitized via `sanitizeHtml()`). |
| `/api/raw?path=` | One file's raw bytes — used for images referenced from a rendered README. |
| `/api/open?path=` | Opens a path with `start`; add `&in=code` to open in VS Code instead. Same-origin only, gated by a `Sec-Fetch-Site` check. |
| `/api/events` | Server-sent events; emits one `change` event per settled filesystem-watcher burst (debounced, not per raw event). |
| `/api/health` | Uptime, scan history, `readErrors`, and `state`. Returns 503 when unwell — this is what `Watch-Hubs.ps1` polls. |
| `/api/hubs` | Lists sibling hubs discovered by walking the parent directory for other `hub.config.json` files, each pinged via `/api/health` server-side (browser CSP is `connect-src 'self'`, so a hub can't fetch another hub's port directly from the page — it asks *this* hub to check on its behalf). Powers the header's hub-switcher dropdown; the dropdown stays hidden with fewer than 2 hubs. |

Every response carries a Content-Security-Policy, `X-Content-Type-Options: nosniff`, and
`Referrer-Policy: no-referrer`; every request is refused unless its `Host` header is
loopback. A new hub gets all of this automatically — none of it lives in `hub.config.json`.

## The filesystem watcher

`/api/events` backs live re-scanning. The watcher deliberately **ignores**:

1. Build output and git internals (`node_modules`, `.git`, `dist`, etc.).
2. The hub's own log/output files — `hub.log`, `hub.err.log`, `watchdog.log`, `scan.json`
   all live inside a scanned root and would otherwise trigger endless self-rescans.
3. Bare **directory** events — Windows reports the parent directory alongside every file
   change, and a directory-only event says nothing a file event hasn't already said.

If a new hub's workspace has its own noisy, frequently-rewritten state file (the kind
that caused the original ~8-second rescan loop, per `Docs/ROADMAP.md`), that's a reason to
extend the shared `ignoreWatchEvent()` rule in `hub.mjs`, not to special-case it in the
new hub's config — there's no per-hub watcher-ignore setting today.

## Testing

```powershell
cd Hub
npm test          # or: node --test hub.test.mjs
```

~28 tests, zero fixtures, zero npm dependencies. The two categories that matter most for
scaffolding a new hub:

- **`every hub config is valid, unique and points somewhere real`** — this is the test
  that actually exercises what Mode A step 5 asks you to run. It walks every sibling
  `hub.config.json`, so adding a new one and running `npm test` from `Hub/` is sufficient
  — you don't need a hub-specific test file.
- **`no stray control bytes in any source file`** — both real production defects found in
  the August 2026 audit were invisible characters (`0x08`/`0x11`) introduced by a scripted
  edit. If you hand-edit `hub.mjs` or `index.html` for Mode A/B reasons, re-run this test
  rather than trusting a visual diff.

## Multi-hub coexistence

Nothing about adding a hub requires coordinating with the others beyond a unique port and
a unique config file. Both `discoverHubs()` (server-side, powers `/api/hubs` and the
header's hub-switcher dropdown) and any external health-check watcher find hubs the same
way — walking the shared engine's parent folder for sibling folders that hold a
`hub.config.json` — so a new Mode A hub is picked up by both automatically. Nothing to
register by hand.
