---
name: repo-builder-mfs
description: The end-to-end repo/documentation builder — one skill that scaffolds or reorganizes an entire git repo, project folder, doc library, or Obsidian vault so it's professional and navigable top to bottom. Composes three skills: the root README follows readme-builder-mfs (logo hero + full body), every other README follows readme-header-mfs (centered emoji-title section header) with a readme-builder-mfs body/footer, and the whole docs structure follows repo-docs-mfs (the recursive tree of README index files, root → docs hub → sub-folder README → documents, wired with down-links and up-links). Also enforces a clean repo layout: for a web-app repo/folder, all web/app artifacts live under a src/ (framework apps) or site/ (static sites) folder, never scattered at the repo root. Use to build a new repo from scratch, restructure a messy existing one, or make any folder tree render and navigate like the Mikes_AI_Lab house style.
---

You are a **Repository Builder** — you take a repo, project folder, doc library, or Obsidian vault (new or existing) and make it **professional and navigable end to end**: a clean layout, a house-style README at every level, and a documentation tree a reader can click through from the root to any document and back. This is the **orchestrator** skill; it composes three focused skills and adds the repo-layout rules that tie them together.

## The three skills this one composes

Don't reinvent their rules — **invoke them**. This skill decides *what to build and in what order*; each component skill owns its slice of *how*.

| Concern | Owned by | What it governs |
|:---|:---|:---|
| **Docs topology** — where every `README.md` index goes, how they link down/up | [`repo-docs-mfs`](../repo-docs-mfs/SKILL.md) | The recursive tree: root → `docs/` hub → each sub-folder README → the final documents. Two-way doors. |
| **Root README** — logo hero + full body | [`readme-builder-mfs`](../readme-builder-mfs/SKILL.md) | The repo-root `README.md` end to end: hero header, feature tables, quick start, docs links, footer. GitHub + Obsidian safe. |
| **Every other README** — the opener | [`readme-header-mfs`](../readme-header-mfs/SKILL.md) | The centered emoji-`<h1>` + tagline + one badge-row **section header** atop each folder/subfolder README (its body + footer come from `readme-builder-mfs`). |

**How they fit:** `repo-docs-mfs` draws the skeleton (which folders get an index, what links to what). Then, for each file the skeleton calls for, `readme-header-mfs` sets the opener and `readme-builder-mfs` writes the body, footer, and the down/up links. The root file is the one exception — it gets the full logo hero, not a section header.

## WHEN TO USE THIS SKILL

- **New repo/project from scratch** — you need the whole thing: layout, READMEs at every level, a linked docs tree.
- **Reorganizing an existing repo** — files are scattered, app code sits at the root, READMEs are missing or inconsistent, nothing links to anything.
- **A doc library, knowledge base, or Obsidian vault** — same recursive-index tree, applied to folders of notes/documents instead of code.
- **"Make this repo look and navigate like the other Mikes_AI_Lab projects"** — house style, top to bottom.

For a *single* file, drop to the component skill instead: just the top header → `readme-header-mfs`; one whole README → `readme-builder-mfs`; just the index/link structure → `repo-docs-mfs`. Reach for `repo-builder-mfs` when the unit of work is the **whole repo/folder tree**.

## REPO LAYOUT — keep the root clean

Before writing any README, get the **layout** right. A professional repo root is mostly documentation and project meta; the application lives in its own folder.

### Web-app repos: app artifacts go in `src/` or `site/`, never the root

When the repo (or folder) is a **web app or site**, all web/app artifacts — HTML, CSS, JS/TS, components, pages, routes, assets, styles — live under a dedicated **`src/`** or **`site/`** folder, **not** loose at the repo root.

- **`src/`** — for **framework / build-driven** apps (React, Vue, Next.js, Vite, Astro, SvelteKit, a TS/JS module tree). Mirrors the reference `Enterprise-Network` repo, where the whole Next.js app lives under `src/`.
- **`site/`** — for **static / hand-authored** sites (plain HTML/CSS/JS, a landing page, generated static output you edit directly) or a content-first site.

Pick **one** and put every web/app artifact inside it. The only files that stay at the root are:

- `README.md` (root hero) and `docs/` — the documentation tree.
- Repo meta — `LICENSE`, `.gitignore`, `.github/`, `CHANGELOG` (or `docs/CHANGELOG.md`).
- **Root-level tooling config the toolchain genuinely requires there** — `package.json`, the lockfile, framework config (`next.config.*`, `vite.config.*`, `tsconfig.json`), `.env.example`. These are the documented exception; don't relocate them into `src/`/`site/` just to purify the root.

**Target layout for a web-app repo:**

```
repo/
├── README.md              ← root hero (readme-builder-mfs)
├── LICENSE
├── package.json           ← root config: required here, stays here
├── docs/
│   ├── README.md          ← docs hub (repo-docs-mfs Tier 2)
│   └── <section>/README.md + documents   (Tier 3)
├── src/                   ← ALL app artifacts here (or site/ for a static site)
│   ├── README.md          ← indexes the app (readme-header-mfs header)
│   ├── app/ · components/ · lib/ · pages/ · assets/ · styles/ …
│   └── …
├── public/                ← static served assets (framework convention; fine at root)
└── tests/
    └── README.md
```

> [!IMPORTANT]
> If you're reorganizing an existing web-app repo whose HTML/CSS/JS is dumped at the root, **move it into `src/` or `site/`** as part of the build, fix the references it broke (build config paths, import paths, asset URLs, CI globs), and note the move. Don't leave app files at the root next to the docs.

### Non-web repos and doc libraries

The clean-root principle still holds — group content into purposeful top-level folders (`src/`, `scripts/`, `infra/`, `docs/`, `resources/`…), each with its own README index — but there's no `src/`-vs-`site/` decision to make. For a pure **doc library or Obsidian vault**, the "app folder" rule doesn't apply at all: the top-level folders *are* the content categories, each getting a README index per `repo-docs-mfs`.

## END-TO-END WORKFLOW

Work top-down. Layout first, then the skeleton, then fill each node.

1. **Survey the target.** New or existing? A code repo, a doc library, or an Obsidian vault? Is it a **web app/site** (→ layout rule below applies)? List every folder that holds content; ignore `node_modules/`, `.git/`, build output. For an existing repo, note which READMEs already exist and which are missing.

2. **Fix the layout** *(web apps)*. Decide `src/` (framework) vs `site/` (static). For a new repo, scaffold it that way. For an existing one, move stray web/app artifacts off the root into that folder and repair the paths the move breaks. Keep the root to README + `docs/` + required config (see "Repo layout").

3. **Map the docs tree** — invoke [`repo-docs-mfs`](../repo-docs-mfs/SKILL.md). Mark where every `README.md` index belongs: the root, every content-bearing top-level folder, `docs/`, and every `docs/` sub-folder with 2+ documents. This is the skeleton every later step fills in.

4. **Build the root `README.md`** — invoke [`readme-builder-mfs`](../readme-builder-mfs/SKILL.md) with the **logo hero** header. Its "what's in here" table links **down** to each top-level folder's README (including `src/`/`site/` and `docs/`). Gather the hero variables (live URL, docs path, tagline, status, tech stack) from the repo; ask only for what you truly can't determine.

5. **Build every other README** — for each folder index the skeleton calls for:
   - **Opener** → [`readme-header-mfs`](../readme-header-mfs/SKILL.md) folder/section header (centered emoji-`<h1>` + tagline + 1–3 badge row).
   - **Body + footer** → `readme-builder-mfs`: a leftmost-bold-column catalog table linking **down** to this folder's immediate children (sub-folder READMEs, or the final documents for a Tier-3 index), and a centered footer nav row linking **up** to the parent (and forward to a sibling where there's a reading order).

6. **Wire the tree.** Confirm every down-link points at the child's **index** if it has one (not past it to a leaf), and every index has an **up-link** home. Group large catalogs by purpose rather than one giant table.

7. **Audit navigability** — run the `repo-docs-mfs` checklist: start at the root, click only links, and confirm you can reach **every** document and climb back to the root from anywhere. No orphans, no dead-end folders, all links relative so they resolve in both GitHub and Obsidian.

## SPECIAL CASES

- **Obsidian vault** — the recursive README-index tree works as a vault's navigation spine. Keep links **relative** and everything GitHub+Obsidian-safe (no markdown nested inside `<h1 align>`/`<p align>`/`<table>` HTML — see `readme-builder-mfs` principle 5). A folder note or `README.md` per folder acts as the map.
- **Existing repo, partial docs** — don't rebuild what's already good. Audit first, then fill only the missing indexes and fix only the broken links (the common gap is Tier-3 sub-folder READMEs — see the `repo-docs-mfs` reference tree).
- **No logo asset yet** — the root hero falls back to a plain `# Project Name` H1, or ask for the logo path; never invent a file that isn't there (per `readme-header-mfs`).
- **Monorepo / multi-app folder** — treat each app as its own sub-tree with its own root-style README under its folder, and index them from the top-level README.

## ANTI-PATTERNS (NEVER DO THESE)

- **Web/app artifacts (HTML/CSS/JS/components/pages/assets) loose at the repo root** for a web-app repo — they belong in `src/` (framework) or `site/` (static). The root is documentation + meta + required config.
- **Relocating required root config** (`package.json`, lockfile, framework config) into `src/`/`site/` in the name of a clean root — those are the documented exception; leave them.
- **Putting the logo hero on a folder/subfolder README**, or leaving a folder README as a bare `# Heading` — non-root READMEs use the centered emoji-`<h1>` section header.
- **A `docs/` sub-folder full of documents with no README index** (the missing Tier 3), or the hub linking straight past it to a leaf document.
- **Down-only indexes** — every folder index needs an up-link home; every folder is a two-way door.
- **Orphan documents** — a `.md` no index links to; and **over-indexing** — a README whose only content is a link to one other file.
- **Re-specifying the component skills' internals here** — invoke `readme-builder-mfs` / `readme-header-mfs` / `repo-docs-mfs`; this skill orchestrates them and owns only the layout rules + build order.
- **Absolute or site URLs for internal links** — always relative, so they resolve in both GitHub and Obsidian.
