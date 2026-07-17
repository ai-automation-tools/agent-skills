# Target layout — a fully built web-app repo

The end-state [`repo-builder-mfs`](../../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) produces for a **web-app** repo: a clean root, every web/app artifact under `src/` (or `site/` for a static site), and a linked README index tree you can click through from the root to any document and back.

## Annotated layout

```
repo/
├── README.md ......................... root hero  → readme-builder-mfs
│     ├─ logo hero header             → readme-header-mfs (root hero)
│     └─ "What's in here" table links DOWN to each top-level folder README
│
├── LICENSE
├── package.json ...................... root config — REQUIRED here, stays here
├── next.config.mjs / vite.config.ts .. root config — REQUIRED here, stays here
├── .gitignore · .github/
│
├── src/ .............................. ALL app artifacts here (or site/ for static)
│     ├── README.md                   → readme-header-mfs section header + down-links
│     ├── app/ · components/ · lib/ · pages/ · assets/ · styles/ …
│     └── …                             ← NOT at the repo root
│
├── public/ ........................... framework-served static assets (fine at root)
│
├── docs/
│     ├── README.md ................... docs HUB (Tier 2)  → readme-header-mfs header
│     │     └─ links DOWN to each section's own README
│     ├── architecture/
│     │     ├── README.md ............. section index (Tier 3) → links DOWN to docs
│     │     ├── overview.md
│     │     ├── data-model.md
│     │     └── local-setup.md
│     ├── api/
│     │     ├── README.md
│     │     └── reference.md
│     └── security/
│           ├── README.md
│           └── overview.md
│
└── tests/
      └── README.md ................... section index → down-links to suites
```

## What each composed skill contributed

| Piece | Skill | Rule applied |
|:---|:---|:---|
| Root `README.md` | `readme-builder-mfs` | Logo hero header + full body; "what's in here" table links down to `src/`, `docs/`, `tests/`. |
| Every folder `README.md` opener | `readme-header-mfs` | Centered emoji-`<h1>` + tagline + 1–3 badge row (never the logo hero). |
| The index tree + link direction | `repo-docs-mfs` | Root → `docs/` hub → each section README → the documents; every folder is a two-way door (down-links + up-link footer). |
| `src/` vs `site/` + clean root | `repo-builder-mfs` | Web/app artifacts under `src/`/`site/`; root keeps README + `docs/` + required config only. |

## The two rules that make this "web-app" specific

1. **App artifacts live in `src/`/`site/`, not the root.** The `app/`, `components/`, `lib/`, `pages/`, `assets/`, `styles/` folders sit **inside `src/`** (framework) or **inside `site/`** (static site) — never loose beside `README.md`.
2. **Required tooling config is the exception.** `package.json`, the lockfile, and framework config (`next.config.*`, `vite.config.*`, `tsconfig.json`) stay at the root because the toolchain needs them there — don't relocate them into `src/`/`site/` chasing a purer root.

The result: open the root, read the hero, follow the "what's in here" table into `src/` for the app or `docs/` for the documentation, and from `docs/` drill into any section and back — all in the same house style.
