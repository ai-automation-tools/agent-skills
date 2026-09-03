---
name: project-hub-scaffold-mfs
description: >-
  Scaffold a new browsable HTML project console — the same live, zero-dependency
  Node server + explorer UI used by the Mikes_AI_Lab / Mike_IAM / Mike_Finance
  Project Hubs (source at D:/AI_Agents/Documents/My-Documents/My-IT-Tools/HTML-Project-Design/Hub) —
  for a new project or workspace, so it gets the same dark terminal-style theme,
  sidebar tree, header controls, hash-based Back/Forward navigation, and markdown
  rendering as the existing hubs instead of a one-off design. Use when the user
  wants to "set up an HTML site for this project", "add a project hub for X",
  "give this project a browsable console like the AI Lab one", "scaffold a doc
  browser", or is starting a new project/folder and wants a live HTML layer over
  it that matches the existing hubs' look, navigation, and behavior.
---

You are scaffolding a **Project Hub** — a local, zero-dependency Node.js server plus a
vanilla-JS single-page UI that scans a workspace live (repos, agent runtimes, skills,
commands, docs) and serves it as a dark, terminal-styled console with a sidebar tree,
search, and markdown rendering. Three of these already run side by side over
`Mikes_AI_Lab`, `Mike_IAM`, and `Mike_Finance`. This skill is for adding a **fourth** (or
a completely independent standalone one) that looks, navigates, and behaves identically —
never a from-scratch reimplementation of the UI.

The canonical source lives at:

```
D:\AI_Agents\Documents\My-Documents\My-IT-Tools\HTML-Project-Design\
├── Hub\                     the ONE program — hub.mjs, index.html, Start-Hub.ps1, tests
├── Project-Hub\             config pointing the program at Mikes_AI_Lab      (:4273)
├── Project-Hub-IAM\         config pointing the program at Mike_IAM          (:4274)
├── Project-Hub-Finance\     config pointing the program at Mike_Finance      (:4275)
└── Docs\ROADMAP.md          the audit history — what shipped and why, in order
```

**Read `references/design-system.md` and `references/config-schema.md` in this skill
before scaffolding anything.** They hold the color tokens, layout rules, keyboard
shortcuts, config schema, and endpoint list extracted from the live source, so you don't
need to re-read `hub.mjs`/`index.html` end to end every time. If either reference ever
looks stale against the live files, trust the live files and update the reference.

## WHEN TO USE THIS SKILL

- **A new project/repo wants the same browsable console** the AI Lab, IAM, and Finance
  workspaces already have — same theme, same sidebar/tree, same search, same navigation.
- **"Set up an HTML site for this project"** where the project is a folder of code, docs,
  or both, and the ask is for a live, scanning explorer rather than a static page someone
  hand-maintains.
- **Adding a fourth (or Nth) workspace** to the existing three-hub family.
- **A project needs its own standalone copy** of this console — shipped inside a repo
  that lives outside this machine's `HTML-Project-Design` folder, or that must not depend
  on a path under `D:\AI_Agents\...`.
- **Not** for building a generic marketing site, landing page, or one-off static page —
  that's a different job (`frontend-design` skill, or plain hand-authored HTML). This
  skill is specifically the *live workspace-scanning console* pattern.

## THE THREE MODES

Pick one. Mode A is the default — reach for B or C only when its trigger condition is
true.

### Mode A — add a sibling hub (default)

Use this whenever the new project is something the shared engine can point `dir` at: a
repo or folder that exists on this machine, whether or not it's part of
`Mikes_AI_Lab`/`Mike_IAM`/`Mike_Finance`. This is the 5-minute path and the one that keeps
getting every future engine fix for free, because all four hubs share the same
`Hub/hub.mjs` + `Hub/index.html` — nothing is copied.

> [!TIP]
> `scripts/scaffold-hub.ps1` automates steps 2–4 below (folder, `hub.config.json`, the
> `Start-Hub.ps1` shim) for Mode A, or the whole file copy + config for Mode B
> (`-Standalone -TargetDir <path>`). It checks port uniqueness against every sibling
> config before writing and refuses to overwrite an existing folder. It does **not** run
> `npm test`, start the server, or touch the docs in step 7 — do those yourself.

1. **Pick a name, a port, and a favicon glyph.** Name = the workspace's own name (matches
   its folder/repo name). Port = next unused `427x` (check every sibling
   `hub.config.json`'s `port` — the test suite rejects a collision). Glyph = one or two
   characters distinct from the other hubs' (`/` is taken by AI Lab — pick something that
   reads at 10px, e.g. a single letter or a simple symbol).
2. **Make the folder** `Project-Hub-<Name>` next to `Project-Hub`, `Project-Hub-IAM`, and
   `Project-Hub-Finance` under `HTML-Project-Design\`.
3. **Write `hub.config.json`** in it — see `references/config-schema.md` for every field.
   Minimum viable config:
   ```json
   {
     "name": "<Name>",
     "dir": "<absolute path to the workspace, forward slashes>",
     "port": <unused 1024-65535, house convention is 427x>,
     "title": "Project Hub — <Name>",
     "favicon": { "glyph": "<1-2 chars>", "ink": "<hex>", "line": "<darker hex>" }
   }
   ```
   Add `"repoScope": { "groups": [...] }` only if the workspace has a `Repos/<group>/`
   tier like `Mikes_AI_Lab`; use `"repoScope": { "pathPrefix": "Repos" }` for a flat
   `Repos/` (like IAM and Finance); omit `repoScope` entirely to scope every repo found.
4. **Copy `Start-Hub.ps1`** from any sibling folder (`Project-Hub\Start-Hub.ps1`) into the
   new folder **byte-for-byte** — it is a generic shim that reads `$PSScriptRoot` and
   needs no edit. Do not write a new one.
5. **Run `npm test` from `Hub\`.** It validates the new config parses, its `dir` exists,
   and its port doesn't collide with a sibling's.
6. **Start it and verify:** `cd Project-Hub-<Name>; .\Start-Hub.ps1` then load
   `http://127.0.0.1:<port>` and confirm the overview renders, the sidebar tree walks the
   new workspace, and (once a second hub is also running) the hub-switcher dropdown in
   the header lists both.
7. **Wire it into the docs**, matching what the three existing hubs already do:
   - `HTML-Project-Design\README.md` — add a row to the **Project Hub Consoles** table and
     the **What's in here** table.
   - The new workspace's own root `README.md`, if it has a "Live sites" or tooling table
     (mirrors §"Live Sites" parsing — `parseLiveSites()` reads that table live).
   - If the workspace has a `.code-workspace` file, add the `folderOpen` task +
     `auto-run-command` rule the other three use, so the hub self-launches on window open
     (see the root `HTML-Project-Design\README.md`'s note on this).
8. **Do not duplicate `hub.mjs` or `index.html`.** If you find yourself editing UI or
   scanner logic to fit the new workspace, that change belongs in the shared `Hub/`
   source (it should already generalize — `ROOTS`, `USER_RUNTIMES`, and `repoScope` exist
   precisely so a new workspace never needs source changes) — fix it there, not in a copy.

### Mode B — standalone copy (only when the project must not depend on this machine's shared engine)

Use this only when the target project must carry its own copy of the tool — e.g. it
ships as part of a repo that isn't `Mikes_AI_Lab`/`Mike_IAM`/`Mike_Finance` and can't
assume `D:\AI_Agents\Documents\My-Documents\My-IT-Tools\HTML-Project-Design\Hub` exists
on whatever machine runs it.

1. Copy `Hub\hub.mjs`, `Hub\index.html`, `Hub\Start-Hub.ps1`, `Hub\package.json`, and
   (if you want its test coverage) `Hub\hub.test.mjs` into the new project — e.g. under
   `tools/project-console/`. `scripts/scaffold-hub.ps1 -Standalone -TargetDir <path>` does
   this copy for you.
2. Write a `hub.config.json` beside the copy, same schema as Mode A (the script does this
   too, from the same parameters as Mode A).
3. Edit the copy's `ROOTS` and `USER_RUNTIMES` constants near the top of `hub.mjs` (see
   `references/config-schema.md`) — they're hardcoded for the `Documents` +
   `My Custom Skills` + `~/.claude`/`~/.codex`/… layout of *this* machine. Drop or replace
   whatever doesn't apply to the new project's environment.
4. Run it with `node hub.mjs --config hub.config.json` or via the copied
   `Start-Hub.ps1 -ConfigDir .`.
5. Everything in `references/design-system.md` still applies unchanged — it's the same
   `index.html`, so the theme, layout, and navigation need no rework. Only the scanner
   inputs (`ROOTS`/`USER_RUNTIMES`) are project-specific.
6. This copy is now independent of the source hub — a fix made in the shared
   `HTML-Project-Design\Hub\` will **not** reach it. Note that trade-off to the user
   explicitly; it's why Mode A is the default.

### Mode C — match the visual language only, no live server

Use this only when the ask is a **static** page (a single doc, a small hand-authored
site, something with no filesystem to scan) that should merely *look and navigate* like
the hubs — not run the scanner/watcher engine at all.

1. Pull the four theme blocks (`html[data-theme="…"]` CSS custom properties), the
   `IBM Plex Mono`/`IBM Plex Sans` font pair, the `--zoom` scaling pattern, and the layout
   classes straight out of `Hub\index.html` — see `references/design-system.md` for the
   exact tokens and where each is used. Don't reinvent the palette by eye.
2. Keep the same structural shell (sidebar + header + content pane) and the same markdown
   typography rules (`.md h1/h2/h3`, code, tables, callouts) so a document dropped into
   either system reads identically.
3. Say plainly to the user that this is a **visual-language-only** match: no live scan,
   no watcher, no search index, no hash-routed history. If any of those turn out to be
   wanted after all, that's Mode A or B, not this.

## DECIDING BETWEEN THE THREE

| Question | Answer → Mode |
|:---|:---|
| Does the project live somewhere this machine's `Hub/hub.mjs` can `dir:` point at, and is it fine depending on that shared engine? | Yes → **A** |
| Must the console ship *inside* the project itself, independent of this machine? | Yes → **B** |
| Is there nothing to scan — just a page that should look and navigate the same? | Yes → **C** |

Default to **A** unless the user's phrasing rules it out (a repo destined for another
machine, a project with no live filesystem to browse, or an explicit "just make it look
like that, no server").

## EXECUTION CHECKLIST

1. Ask (or infer from context) which mode applies, using the table above. If genuinely
   ambiguous, ask — a wrong mode means redoing the scaffold.
2. Read `references/config-schema.md` for the exact `hub.config.json` fields, `ROOTS`/
   `USER_RUNTIMES` shape, and the endpoint list.
3. Read `references/design-system.md` if the mode touches the UI at all (A, B, and C all
   do).
4. Run the mode's numbered steps above.
5. **Verify before calling it done**, matching how the Back/Forward buttons were verified
   when added to this same UI: run `npm test` (Mode A/B) and load the page in a browser —
   confirm the overview renders, the sidebar tree matches the target `dir`, search
   returns hits, and (Mode A/B) `/api/health` returns 200.
6. Update the docs the new hub's siblings already update (step 7 of Mode A) — a hub that
   works but isn't listed in `HTML-Project-Design\README.md` is half-finished.

## ANTI-PATTERNS

- **Reimplementing the UI from a screenshot** instead of reusing `index.html` verbatim
  (Mode A/B) or lifting its actual CSS tokens (Mode C). The whole point of this skill is
  that the four hubs are indistinguishable in look and behavior — eyeballing the colors
  produces drift the next redesign won't catch.
- **Forking `hub.mjs`/`index.html` in Mode A.** If the shared engine can't yet do
  something the new workspace needs, fix the shared source (it's designed to generalize
  via config) — don't fork it per hub. That's exactly the triplication problem the three
  hubs were unified out of on 2026-08-31 (see `Docs/ROADMAP.md`).
- **Skipping `npm test` before declaring the config valid.** The test suite exists
  specifically to catch a bad `dir`, a colliding `port`, or invalid JSON before the
  server ever starts.
- **Leaving the new hub undocumented.** A hub not listed in `HTML-Project-Design\README.md`
  will be forgotten the next time someone runs `Watch-Hubs.ps1` or looks for what's
  running on which port.
- **Choosing a port outside the `427x` house block** without a reason — `4173`/`5173`
  collide with Vite's defaults on this machine (see the `README.md` note on why the hubs
  moved off `417x`).
- **Picking Mode B by default.** It costs future fixes; only take it when the project
  truly can't depend on the shared engine's path.
