---
name: edge-spectrum-hub-tool
description: >-
  Add, change, retire or debug a tool on the Edge Spectrum hub — the `TOOLS` registry in
  site/src/tools.ts, the three `kind` branches (route / static / external) and what each one
  obliges you to wire, the literal `ACCENT` map Tailwind's JIT depends on, and the calculator
  page pattern built on src/odds.ts and components/CalcUi.tsx. Use for "add a tool to the hub",
  "new calculator page", "new tile", "the tile links nowhere", "the accent colour renders
  unstyled", "the static page 404s in dev but works on Vercel", "deep link reloads to the home
  page", "mark a tool as WIP / soon", "remove a tool", and any work on Home.tsx, App.tsx, the hub
  nav, or a page under site/src/pages/.
---

# Adding a tool to the hub

**The hub is a registry plus a page. A `route` tool also has four route lists to keep in step (§1).**

Everything about a tile — its title, blurb, icon, status pill, accent, and where it points — is
one entry in `site/src/tools.ts`. `Home.tsx` maps over `TOOLS` to draw the grid; `App.tsx` holds
the routes. Nothing else enumerates tools, so **never add a second list.**

All commands run from **`site/`**, not the repo root.

---

## 1. The registry entry

```ts
// site/src/tools.ts — TOOLS is the single source of truth
{
  slug:   'kelly',                 // unique; matches the route/folder name
  title:  'Kelly Stake Sizer',
  blurb:  'One or two sentences, present tense, no marketing.',
  icon:   Calculator,              // a LucideIcon, imported at the top of the file
  href:   '/kelly',
  kind:   'route',                 // 'route' | 'static' | 'external'
  status: 'live',                  // 'live' | 'wip' | 'soon'
  accent: 'teal',                  // must exist in ACCENT in Home.tsx
  tag:    'Calculator',            // optional short category label on the tile
}
```

Then, **by `kind`** — each one obliges exactly one more thing:

| `kind` | `href` | You must also | Rendered as |
|:---|:---|:---|:---|
| `route` | `/slug` | add a `lazy()` import and `<Route path="/slug" element={<Page />} />` in `App.tsx`, then the path in the three other route lists below | `<Link>`, client-side |
| `static` | `/slug/index.html` — **the explicit file** | drop the page under `site/public/slug/` | `<a>`, full page load |
| `external` | the absolute URL | nothing | `<a target="_blank" rel="noopener noreferrer">` |

A `route` page is listed in **four places**, and they must agree (the comment above `PAGE_META` in
`App.tsx` says so): the `<Route>` in `App.tsx`, the `rewrites` in `site/vercel.json`
(`/:page(backtester|odds|parlay|setup)` and its trailing-slash twin), `CLIENT_ROUTES` in
`site/server.ts`, and `site/public/sitemap.xml`. Miss `vercel.json` and the deep link 404s in
production while working in dev. The page itself is a `lazy()` import: `npm run check:bundle` fails
CI if the home page passes 150 kB gzip.

> [!WARNING]
> **A `static` tool's `href` must name `index.html`.** Vite's dev server does *not* auto-serve a
> `public/` directory index, so `/spectrum/` 404s locally while working fine on Vercel — a break
> that only shows up for whoever runs `npm run dev` next. `/spectrum/index.html` resolves
> identically in both. This is written into the comment above the spectrum entry; keep it there.

## 2. The accent must be a literal

`ACCENT` in `site/src/pages/Home.tsx` is a `Record<Accent, …>` of **fully spelled-out Tailwind
class strings**. Tailwind v4's JIT scans source text — it cannot see `text-${color}-400`. A new
accent needs three things or the tile renders unstyled:

1. the key added to the `Accent` union in `tools.ts`,
2. a row in the literal `ACCENT` map with `icon`, `corner` and `hoverBorder` spelled out in full,
3. no interpolation anywhere in between.

The seven that exist — `sky` `emerald` `violet` `amber` `rose` `teal` `cyan` — cover more tools
than the hub has. **Reuse one before adding one.** The `STATUS` map right below it works the same
way and already covers `live` / `wip` / `soon`; a tool that is not ready ships as `soon`, it does
not ship absent.

## 3. Building a `route` page

New calculator pages follow the two that exist — read `pages/OddsConverter.tsx` before writing a
third. The pattern and its reuse rules are in
[`references/page-patterns.md`](references/page-patterns.md).

The short version:

- **Math goes in a pure module, never in the component.** `src/odds.ts` already holds American /
  decimal / fractional / implied conversion, three de-vig methods (multiplicative, power, Shin)
  and parlay joint-probability math, with **zero imports** so `scripts/check-odds.ts` can assert
  against it. Reuse it. Re-deriving a conversion inside a page puts it outside the guard.
- **Chrome goes in `components/CalcUi.tsx`** — `Panel`, `Select`, `Stat` are shared by both
  calculator pages.
- **New non-trivial math earns a `check:*` script** and a line in `.github/workflows/ci.yml`.
  That is the house convention, not an optional extra: every other module of real logic has one.

## 4. Routes that are not tools

`/setup` is a `<Route>` in `App.tsx` with **no** `TOOLS` entry — it is the self-hosting page, linked
from the Home hero, not a tile. That is deliberate and it is the precedent: a page that is not a
*tool* gets a route and stays out of the registry. `<Route path="*">` renders `NotFound` (with
`noindex`), and Vercel answers 404 for any path not in the rewrites, so a typo'd `href` shows the
not-found page — **click the tile after adding it.**

Deep links work in production because `vercel.json` rewrites the listed client routes to
`/index.html`, and nothing else. If a new client route 404s on Vercel but works in dev, that list is
the first place to look.

---

## 5. Checklist

1. **One entry in `TOOLS`** — `slug` unique, `blurb` factual, `tag` short.
2. **Branch on `kind`** (§1). `route` → `lazy()` import + `<Route>`, and the path in `vercel.json`,
   `server.ts` `CLIENT_ROUTES` and `public/sitemap.xml`. `static` → `public/<slug>/` + an
   `index.html` href. `external` → done.
3. **Accent exists as a literal** in `Home.tsx` (§2) — or reuse one of the seven.
4. **Math in a pure module**, chrome from `CalcUi.tsx` (§3).
5. **New logic gets a `check:*` script** wired into CI.
6. `npm run lint` — `tsc --noEmit` catches an accent key that is not in the union.
7. `npm run dev` and **click the tile**, then reload on the deep link. A bad `href` lands on the
   not-found page; a path missing from `vercel.json` only fails in production.
8. Update `AGENTS.md`'s layout block if the tool added a directory.

---

## 6. Anti-patterns

- **A second list of tools.** Nav, footer, sitemap — all of them map over `TOOLS`.
- **An interpolated Tailwind class** (`text-${accent}-400`). JIT never emits it.
- **`href: '/spectrum/'` for a static tool.** Works on Vercel, 404s in dev.
- **Math inside the page component.** It escapes `check:odds`.
- **Trusting dev to prove the route.** Dev serves any path; Vercel serves only the paths in `vercel.json`.
- **Shipping a half-finished tool by leaving it out of `TOOLS`.** Mark it `soon`.
- **Running `npm` at the repo root.** The whole app is in `site/`.

---

## Related

| For | See |
|:---|:---|
| The calculator page pattern, `odds.ts` and `CalcUi` reuse | [`references/page-patterns.md`](references/page-patterns.md) |
| The dataset behind the `/spectrum` static tool | the `edge-spectrum-dataset` skill |
| The Cronsole templates the home page and README list | the `edge-spectrum-registry` skill |
| Adding an API endpoint a new tool needs | the `edge-spectrum-endpoint` skill |
| Branch flow, preview deploys, CI gate order | the repo's `AGENTS.md` |
