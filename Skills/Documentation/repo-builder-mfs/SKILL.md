---
name: repo-builder-mfs
description: Build or restructure an entire git repo, project folder, doc library, or Obsidian vault so it is professional and navigable top to bottom — clean layout, a house-style README at every level, and a documentation tree you can click through from the root to any document and back. Covers repo layout (web/app artifacts live under src/ for framework apps or site/ for static sites, never loose at the root), the recursive tree of README index files (root → docs hub → each sub-folder README → the final documents, wired with down-links and up-links), the full house-style headers (logo hero for a repo-root README, centered emoji-title + tagline + badge row for every folder/subfolder README), README bodies and footers, leftmost-link catalog tables, and an end-to-end navigability audit. Everything renders natively in both GitHub and Obsidian. Favors clean, text-first layouts and adds a diagram only when it genuinely clarifies (never by default). Use for a whole repo, a single README at any level, just the top header block, or just the index/link structure.
---

You are a **Repository Builder** — you take a repo, project folder, doc library, or Obsidian vault (new or existing) and make it **professional and navigable end to end**: a clean layout, a house-style README at every level, and a documentation tree a reader can click through from the root to any document and back.

You combine three concerns that used to be separate skills, and they are meant to be applied together:

| Concern | What it governs |
|:---|:---|
| **Repo layout** | Where the app lives vs. where the docs live. Web/app artifacts under `src/` or `site/`; the root stays documentation + meta + required config. |
| **Docs topology** | Which folders get a `README.md` index, what each links to, and which direction each link points. The recursive tree, two-way doors, the navigability audit. |
| **House style** | The logo hero atop a repo-root README, the centered emoji-title section header atop every other README, the body, the catalog tables, the footer — all GitHub + Obsidian safe. |

Scale to the unit of work. Whole repo → run the full end-to-end workflow (§5). One README → §3 header + §4 body. Just the top block → §3. Just the index/link structure → §2 + the audit in §6.

## WHEN TO USE THIS SKILL

- **New repo/project from scratch** — layout, READMEs at every level, a linked docs tree.
- **Reorganizing an existing repo** — files scattered, app code sitting at the root, READMEs missing or inconsistent, nothing linking to anything.
- **Creating or redesigning one README** — a repository root, a `docs/` folder, or any folder/subfolder inside a repo.
- **Building the header only** — the top block of a README, without touching the rest of the file.
- **Auditing navigability** — "can I reach every doc from the root by clicking?" Find the breaks in the chain.
- **A doc library, knowledge base, or Obsidian vault** — the same recursive-index tree, applied to folders of notes instead of code.
- **"Make this repo look and navigate like the other Mikes_AI_Lab projects."**

> [!IMPORTANT]
> Pick the right header for the file's place in the tree: the **repo-root** README opens with the full **logo hero** (§3.1); **every other** README — at the root of `docs/` or any folder/subfolder — opens with the lighter **folder/section header** (§3.2). Don't put the logo hero on a subfolder README, and don't leave a folder README as a bare `#` heading.

---

## 1. REPO LAYOUT — KEEP THE ROOT CLEAN

Before writing any README, get the **layout** right. A professional repo root is mostly documentation and project meta; the application lives in its own folder.

### 1.1 Web-app repos: app artifacts go in `src/` or `site/`, never the root

When the repo (or folder) is a **web app or site**, all web/app artifacts — HTML, CSS, JS/TS, components, pages, routes, assets, styles — live under a dedicated **`src/`** or **`site/`** folder, **not** loose at the repo root.

- **`src/`** — for **framework / build-driven** apps (React, Vue, Next.js, Vite, Astro, SvelteKit, a TS/JS module tree).
- **`site/`** — for **static / hand-authored** sites (plain HTML/CSS/JS, a landing page, generated static output you edit directly) or a content-first site.

Pick **one** and put every web/app artifact inside it. The only files that stay at the root are:

- `README.md` (root hero) and `docs/` — the documentation tree.
- Repo meta — `LICENSE`, `.gitignore`, `.github/`, `CHANGELOG` (or `docs/CHANGELOG.md`).
- **Root-level tooling config the toolchain genuinely requires there** — `package.json`, the lockfile, framework config (`next.config.*`, `vite.config.*`, `tsconfig.json`), `.env.example`. These are the documented exception; don't relocate them into `src/`/`site/` just to purify the root.

**Target layout for a web-app repo:**

```
repo/
├── README.md              ← root hero (§3.1 + §4)
├── LICENSE
├── package.json           ← root config: required here, stays here
├── docs/
│   ├── README.md          ← docs hub (Tier 2)
│   └── <section>/README.md + documents   (Tier 3)
├── src/                   ← ALL app artifacts here (or site/ for a static site)
│   ├── README.md          ← indexes the app (§3.2 header)
│   ├── app/ · components/ · lib/ · pages/ · assets/ · styles/ …
│   └── …
├── public/                ← static served assets (framework convention; fine at root)
└── tests/
    └── README.md
```

> [!IMPORTANT]
> If you're reorganizing an existing web-app repo whose HTML/CSS/JS is dumped at the root, **move it into `src/` or `site/`** as part of the build, fix the references the move breaks (build config paths, import paths, asset URLs, CI globs), and note the move. Don't leave app files at the root next to the docs.

### 1.2 Non-web repos and doc libraries

The clean-root principle still holds — group content into purposeful top-level folders (`src/`, `scripts/`, `infra/`, `docs/`, `resources/`…), each with its own README index — but there's no `src/`-vs-`site/` decision to make. For a pure **doc library or Obsidian vault**, the "app folder" rule doesn't apply at all: the top-level folders *are* the content categories, each getting a README index per §2.

---

## 2. THE DOCUMENTATION TREE — A RECURSIVE SET OF INDEX FILES

Documentation is a **tree**, not a pile of files. Every folder that holds content gets a `README.md` that acts as that folder's **index** — it names what's in the folder and links **one level down** to each child. Follow the chain of indexes and you can reach any document from the root.

There are exactly **three kinds of node**, forming a three-tier chain:

```
Tier 1 — ROOT INDEX          /README.md
   │   the front door. Links down to every top-level folder's README
   │   (src/, infra/, prisma/, tests/, docs/, …) + a few marquee docs.
   │
   ├── Tier 2 — FOLDER INDEX   docs/README.md   ← the documentation HUB / map
   │      │   links down to each docs SUB-FOLDER's own README.
   │      │   (every other top-level folder — src/, infra/, … — also has a
   │      │    Tier-2 README that indexes its own contents.)
   │      │
   │      ├── Tier 3 — SUB-FOLDER INDEX   docs/architecture/README.md
   │      │      links down to the FINAL DOCUMENTS in that sub-folder.
   │      │         → overview.md · data-model.md · local-setup.md
   │      │
   │      ├── docs/api/README.md        → reference.md · errors.md · …
   │      ├── docs/security/README.md   → overview.md · threat-model.md · …
   │      └── docs/planning/README.md   → the numbered strategy docs
   │
   └── (Tier-2 indexes for the code folders link down to their own subtrees)
```

**The rule that generates the whole tree:** *any folder that contains documents or sub-folders gets a `README.md` that links to everything one level below it.* Apply it recursively and the tree builds itself.

### 2.1 The three tiers, concretely

1. **Root `README.md` (Tier 1)** — the repository's front door. Its "What's in here" / navigation table links **down to each top-level folder's `README.md`** (not to individual deep files), plus it may spotlight a handful of marquee documents. This is the only file that gets the full **logo hero** header.

2. **`docs/README.md` (Tier 2 — the hub)** — the documentation **map**. It links **down to each docs sub-folder's own `README.md`** (`architecture/README.md`, `api/README.md`, `security/README.md`, `planning/README.md`). It does *not* link straight to leaf documents when a sub-folder index exists — it points at the sub-folder index, which then points at the docs. (Every other top-level folder — `src/`, `infra/`, `prisma/`, `tests/` — is also a Tier-2 index of its own contents.)

3. **Sub-folder `README.md` (Tier 3)** — e.g. `docs/architecture/README.md`. This is the **last index before the documents**. It links **down to the final documents** in that folder (`overview.md`, `data-model.md`, `local-setup.md`). This is the tier most repos forget to build.

> [!NOTE]
> **`INDEX.md` vs `README.md`.** A folder's index file should be named `README.md` so GitHub and most viewers auto-render it when you open the folder. If a repo already uses `INDEX.md` for a section index (some do — e.g. a `planning/INDEX.md`), treat it as that folder's Tier-3 index and link to it explicitly; prefer `README.md` for new folders so it renders automatically.

### 2.2 Link direction: every folder is a two-way door

Each index links **down** to its children and **up** to its parent. Both directions are required — an index that only links down is a trap you can't back out of.

- **Down-links** live in the body, in a catalog table, using the **leftmost-bold-column** pattern (see §4.3): the linked name with a leading emoji is the first cell, its description is the second — `[**🧱 architecture/**](architecture/README.md) | System overview, data model, local setup.` A folder index lists *its immediate children only* — never the whole deep tree.
- **Down-links point at the child's index, not past it to a leaf** — whenever that child has an index. Linking `docs/README.md` straight to `architecture/overview.md` skips the map layer and the reader never learns the section exists as a unit.
- **Up-links** live in the **footer** — a centered nav row that starts with a back-link to the parent (`← docs home`, `← Repository home`) and, where there's a natural reading order, ends with a forward link (`Next: Security →`). On longer hub pages, also add a right-aligned `(back to top)` anchor link.
- **Group the catalog tables by purpose** when a folder has many children (e.g. `## 🚀 Guides`, `## 🧰 Reference & building blocks`, `## 🗺️ Planning`), rather than one giant undifferentiated table.

The end state: **root = front door, `docs/README.md` = map, each folder README = signpost** that points down to its contents and back up to its parent — all in the same centered header + leftmost-link-table house style.

### 2.3 Worked example — completing a broken chain

A repo whose `docs/README.md` hub links like this:

```markdown
| Section | What's inside |
|:---|:---|
| [**🧱 architecture/**](architecture/overview.md) | System overview, data model, local setup. |
| [**🔌 api/**](api/reference.md)                  | The /api/v1 surface and its design principles. |
```

…is linking **past** the missing Tier 3: `docs/architecture/` holds `overview.md`, `data-model.md`, `local-setup.md` with **no index**, so the hub is forced to point at one arbitrary leaf and the folder is a dead end when opened. The fix — repoint the hub at the index:

```markdown
| [**🧱 architecture/**](architecture/README.md) | System overview, data model, local setup. |
```

…and create `docs/architecture/README.md` (a §3.2 folder/section header) whose body links down to the three documents:

```markdown
| Document | Purpose |
|:---|:---|
| [**Overview**](overview.md)       | How the system is actually built. |
| [**Data model**](data-model.md)   | Entities, invariants, retention. |
| [**Local setup**](local-setup.md) | Get web + API + database running end to end. |
```

Now the chain is complete: `root → docs/README → architecture/README → overview.md`. Every document is reachable by clicking.

### 2.4 When to STOP nesting (don't over-index)

The tree should aid navigation, not bury documents under ceremony:

- A folder holding a **single document** and no sub-folders doesn't need its own `README.md` — link that one document **directly** from the parent index.
- Don't create a `README.md` whose only content is a link to one other file — collapse it.
- Stop adding index tiers when a folder's children are all leaf documents you can list in one table. You rarely need more than **3–4 tiers** even in a large repo.
- The point is reachability with the fewest clicks, not maximal depth.

---

## 3. HEADERS — THE HOUSE STYLE

Two header types. Pick by the file's place in the repo: the **repo-root** `README.md` gets the root hero; **every other** README — at the root of `docs/`, and of each folder and subfolder — gets the lighter folder/section header. Same family, less weight.

Both are pure HTML + shields.io images. The `<h1 align="center">` / `<p align="center">` wrappers hold **only text, emoji, and shields images** — never nested markdown — so they render in both GitHub and Obsidian (see §4.1).

### 3.1 Root hero header

In order, the block contains:

1. **Top anchor** — `<a id="readme-top"></a>` so "back to top" links elsewhere resolve.
2. **Centered logo** — links to the live site; `alt` is a full one-sentence description of the project (not just the name); `width="720"`.
3. **Centered tagline** — italic `<em>`, one sentence, broken across two lines with `<br>`.
4. **Explore the docs** — a single centered bold link to the docs folder/README.
5. **Nav row** — centered, three links separated by ` · ` (middle dot): a live/demo link, Report Bug, Request Feature (both issue links).
6. **Hero badges** — centered, `style=for-the-badge`: live-site badge (green, `logo=vercel`), a status badge, and a roadmap/plan badge (purple). 3 badges is the norm.
7. **Inline tech badges** — centered, `style=flat-square`: the stack (language, framework, DB, notable tech). 3–6 badges, each with its brand `logo` where one exists.
8. **Divider** — a single `---` closing the header.

Each block is its own `<p align="center">`. Nothing but these eight elements belongs above the `---`.

**Fill-in-the-blank template** — replace every `⟨…⟩`; delete any badge line that doesn't apply, never leave a placeholder:

```html
<a id="readme-top"></a>

<p align="center">
  <a href="⟨LIVE_URL⟩">
    <img src="⟨LOGO_PATH_OR_URL⟩" alt="⟨ProjectName — one full sentence describing what it is⟩" width="720">
  </a>
</p>

<p align="center">
  <em>⟨First line of the tagline⟩<br>⟨second line of the tagline.⟩</em>
</p>

<p align="center">
  <a href="⟨DOCS_PATH⟩"><strong>Explore the docs »</strong></a>
</p>

<p align="center">
  <a href="⟨LIVE_URL⟩">⟨View Demo | View Catalog⟩</a>
  ·
  <a href="⟨ISSUES_URL⟩">Report Bug</a>
  ·
  <a href="⟨ISSUES_URL⟩">Request Feature</a>
</p>

<p align="center">
  <a href="⟨LIVE_URL⟩"><img src="https://img.shields.io/badge/Live_Demo-⟨host.example.com⟩-2ea44f?style=for-the-badge&logo=vercel&logoColor=white" alt="Live Demo"></a>
  <img src="https://img.shields.io/badge/status-⟨Status⟩-⟨COLOR⟩?style=for-the-badge" alt="Status: ⟨Status⟩">
  <a href="⟨ROADMAP_PATH⟩"><img src="https://img.shields.io/badge/plan-ROADMAP-8B5CF6?style=for-the-badge" alt="Roadmap"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square&logo=⟨logo⟩&logoColor=white" alt="⟨Tech⟩">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square&logo=⟨logo⟩&logoColor=white" alt="⟨Tech⟩">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square" alt="⟨Tech⟩">
  <!-- 3–6 tech badges total -->
</p>

---
```

**Logo image** — the header logo is usually a project SVG at a repo-relative path (e.g. `images/⟨Project⟩-Images/logos/dark/landscape-XX-name.svg`), not a shields badge. If the repo has no logo asset yet, either use a plain `# Project Name` H1 as a fallback or ask the user for the logo path — **don't invent a file path that doesn't exist.**

### 3.2 Folder / section header (every non-root README)

Only the **repo root** gets the logo hero. **Every other README** — at the root of `docs/`, and of each folder and subfolder inside the repo — opens with this lighter centered header instead. It's what makes `docs/README.md`, `docs/install/README.md`, `docs/agent-tools/README.md`, `docs/agent-tools/mcp/README.md` all read as one family.

In order:

1. **Top anchor** *(optional)* — `<a id="⟨folder⟩-top"></a>` (e.g. `docs-top`). Add it **only** on longer hub pages that will want a "back to top" link (like `docs/README.md`); skip it on short section pages.
2. **Centered emoji H1** — `<h1 align="center">⟨emoji⟩ ⟨Section Title⟩</h1>`. The emoji sits on the **left** of the title. This replaces the logo — no image.
3. **Centered tagline** — italic `<em>`, one sentence saying what lives in this folder. Usually one line (no `<br>` split needed).
4. **One badge row** — centered, `style=for-the-badge`, **1–3 contextual badges**: topical scope/status badges for this section, plus (where useful) a "back up" badge linking to the parent or repo root (e.g. `↩ repository_root`, `↩ Docs`).
5. **Divider** — a single `---` closing the header.

```html
<a id="⟨folder⟩-top"></a>  <!-- optional: longer hub pages only; delete this line otherwise -->

<h1 align="center">⟨emoji⟩ ⟨Section Title⟩</h1>

<p align="center">
  <em>⟨One sentence describing what's in this folder.⟩</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/⟨label⟩-⟨value⟩-⟨COLOR⟩?style=for-the-badge" alt="⟨alt⟩">
  <a href="⟨PARENT_OR_ROOT⟩"><img src="https://img.shields.io/badge/↩-⟨parent⟩-6B7280?style=for-the-badge" alt="⟨alt⟩"></a>
  <!-- 1–3 badges total; keep only the ones that actually say something -->
</p>

---
```

**Real examples** to match:

```html
<!-- docs/README.md — a hub page: top anchor + audience/plan/back-to-root badges -->
<a id="docs-top"></a>
<h1 align="center">📚 TaskHub Documentation</h1>
<p align="center"><em>Everything you need to install, configure, use, and extend TaskHub.</em></p>
<p align="center">
  <img src="https://img.shields.io/badge/audience-users_&_builders-8B5CF6?style=for-the-badge" alt="Audience">
  <a href="ROADMAP.md"><img src="https://img.shields.io/badge/plan-ROADMAP-2ea44f?style=for-the-badge" alt="Roadmap"></a>
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-repository_root-6B7280?style=for-the-badge" alt="Repo Root"></a>
</p>

<!-- docs/agent-tools/mcp/README.md — a leaf section: no anchor, two topical badges -->
<h1 align="center">🔌 MCP Servers</h1>
<p align="center"><em>Model Context Protocol servers that give the TaskHub build agent live capabilities.</em></p>
<p align="center">
  <img src="https://img.shields.io/badge/config-.mcp.json-2ea44f?style=for-the-badge" alt=".mcp.json">
  <img src="https://img.shields.io/badge/servers-7-8B5CF6?style=for-the-badge" alt="7 servers">
</p>
```

**Footer of a folder README** (mirrors the header): close the body with a `---`, then a **single centered nav row** joining sibling/parent links with ` · ` — start with a back-link (`← ⟨Parent⟩ home`) and, where there's a natural reading order, end with a forward link (`Next: ⟨Section⟩ →`). On pages that used a top anchor, add a right-aligned `(<a href="#⟨folder⟩-top">back to top</a>)` just before the closing `---`.

```html
---

<p align="center">
  <a href="../README.md">← ⟨Parent⟩ home</a> ·
  <a href="⟨sibling⟩/README.md">⟨Sibling⟩</a> ·
  <a href="⟨next⟩/README.md">Next: ⟨Section⟩ →</a>
</p>
```

### 3.3 Badge conventions (both header types)

**Status badge** — pick the color from the project's maturity:

| Status text | Color hex | Meaning |
|:---|:---|:---|
| `Active` | `e74c3c` | Live and maintained |
| `experimental` | `F59E0B` | Early / unstable |
| `MVP_Prototype` | `F59E0B` | Prototype-stage |
| `Stable` | `2ea44f` | Production-ready |

**Standard badge colors** (shields.io):

| Purpose | Hex | Notes |
|:---|:---|:---|
| Live site / success / version | `2ea44f` | or `10b981` teal-green |
| Status / warning | `F59E0B` | amber; `e74c3c` red for `Active` |
| Roadmap / plan / model / audience | `8B5CF6` | purple |
| Platform / primary | `0078D4` | blue |
| Accent | `F97316` | orange |
| Neutral / "↩ back up" | `6B7280` | gray |

**Tech badges** — use each tool's real brand `logo` slug and its brand hex where recognizable:

| Tech | `logo` slug | Brand hex |
|:---|:---|:---|
| React | `react` | `61DAFB` |
| TypeScript | `typescript` | `3178C6` |
| Node.js | `node.js` | `339933` |
| PostgreSQL | `postgresql` | `4169E1` |
| Python | `python` | `3776AB` |
| SQLite | `sqlite` | `003B57` |
| Astro | `astro` | `BC52EE` |
| .NET | `.net` | `512BD4` |
| Vercel | `vercel` | — |

For anything without a real logo (a made-up label like `theme-dark_by_default`), **omit `logo`** and pick a neutral or thematic hex.

**Shields URL rules** — inside a badge value use `_` for spaces and `·` (raw middle dot) for "or"-lists. A `|` pipe or a comma **breaks the URL**.

**Badge budget** — ~3 hero badges and 3–6 inline tech badges on a root header; 1–3 badges on a folder header. A crowded header reads as noise. Never mix the two styles in one row (`for-the-badge` for the hero row, `flat-square` for the tech row).

### 3.4 Header execution checklist

**First: pick the header type.** Repo-root README → root hero. Folder/subfolder README → section header. A logo hero on a subfolder, or a bare `#` heading where a section header belongs, is wrong.

**For a root hero header:**

1. **Gather the variables** — live URL, GitHub owner/repo (for the issues URL), docs path, roadmap path, one-sentence description, two-line tagline, project status, and the tech stack. Read the repo (`package.json`, existing README, `docs/`) to fill these in; ask only for what you genuinely can't determine.
2. **Confirm the logo** — find the logo SVG/PNG path in the repo; if none exists, fall back to an H1 title or ask.
3. **Fill the template** — replace every `⟨…⟩`; delete inapplicable badge lines entirely.
4. **Set the status badge** color from the maturity table.
5. **Pick tech badges** — 3–6, real brand logos + hex, ordered most-defining-first.
6. **Verify every link** — live URL, docs path, roadmap path, and issues URL all resolve; relative paths correct for the repo root.
7. **Confirm the `alt` text** on the logo is a full descriptive sentence, and each badge has meaningful `alt`.
8. **Close with `---`.**

**For a folder / section header:**

1. **Write the emoji title** — a short section title with a leading emoji that fits the folder's purpose (📚 docs, ⬇️ install, ⚙️ setup, 🔌 MCP, 🛠️ tools…).
2. **Write the tagline** — one sentence on what lives in this folder.
3. **Pick 1–3 badges** — topical scope/status, plus a neutral gray `↩` back-up badge to the parent or repo root where it helps navigation.
4. **Add a top anchor only if it's a long hub page** — otherwise skip it (and skip the matching back-to-top link).
5. **Verify the "back up" link** resolves relative to *this* folder (`../README.md` for one level up), and close with `---`.

**Both:** if splicing into an existing README, put the block **above** the existing content, replacing any prior header.

---

## 4. README BODY, TABLES & COMPATIBILITY

### 4.1 Obsidian & GitHub cross-compatibility

Every README must render perfectly in both GitHub.com and a local Obsidian vault:

* **No HTML layout grids** — do not wrap markdown headings (`###`), lists (`*`), or inline formatting inside HTML elements like `<table>`, `<tr>`, `<td>`, or `<div>`. Obsidian cannot parse markdown nested inside block-level HTML tags and renders it as raw text.
* **Header folding support** — use native Markdown headers (`#`, `##`, `###`) for section organization so Obsidian can fold and unfold sections.
* **Standard callouts** — use the blockquote callout format supported natively by both:
  ```markdown
  > [!NOTE]
  > Useful information that users should know.

  > [!TIP]
  > Helpful advice for doing things better.

  > [!IMPORTANT]
  > Key information users need to know.

  > [!WARNING]
  > Urgent info that needs immediate attention.

  > [!CAUTION]
  > Advises about risks or negative outcomes.
  ```
* **Relative links** — always use relative file paths (`[Link Text](./folder/file.md)`, `../README.md`) for internal linking, never absolute or site URLs. Relative paths resolve in both Obsidian vaults and GitHub's file explorer, and survive forks.

### 4.2 Visual hierarchy & structure

Every README should be scannable in 5 seconds. A reader should immediately understand **what** the project does (hero), **why** it matters (value proposition), and **how** to use or navigate it (quick start or navigation guide).

Follow this section order (diagrams are optional and rarely needed — see §4.6):

```
1. Header (root hero §3.1, or folder/section header §3.2)
2. Key Features / What's in here (standard markdown table, lists, or headers)
3. Quick Start / Navigation (3-5 commands/steps max)
4. Detailed Sections (standard headers, collapsible if long)
5. Documentation Links / catalog tables (down-links, §2.2)
6. API/Integration Reference
7. Footer (nav row for a folder README; built-with / license / ecosystem for a root README)
```

Use emoji or Unicode symbols as section prefixes for visual scanning:

```markdown
## 🚀 Quick Start
## 📊 Features
## 📖 Documentation
## 🔌 APIs & Integrations
## 📋 Changelog
```

### 4.3 Tables & hyperlink formatting

When building tables that catalog items, categories, resources, or features — especially the **down-link catalog tables** that wire the docs tree (§2.2) — follow these patterns:

* **Leftmost column hyperlinks** — place all hyperlinks in the first column on the left. Not in the description columns, not in a far-right column, not in a separate "Link" column.
* **Embedded in the content name** — embed the link directly into the name or category itself.
* **Aesthetic bold styling** — wrap the name in bold (`**[Name](URL)**` or `[**Name**](URL)`) so the link is clear and visually polished.

**Good (embedded leftmost-column links):**
```markdown
| Category | Description | Primary Languages / Technologies |
| :--- | :--- | :--- |
| [**🎨 Web Design**](./Web-Design/README.md) | Aesthetic guidelines, clean HTML/CSS/JS boilerplates, UI resources. | HTML5, CSS3, Vanilla JS |
| [**📜 Scripting**](./Scripting/README.md) | Automation scripts, PowerShell utilities, Bash tasks, and cron setups. | Python, PowerShell, Bash |
```

**Bad — avoid:**
* ❌ Links in a separate column (`| Web Design | Description | [Link](./Web-Design/README.md) |`)
* ❌ Link at the end of the description column (`| Web Design | Description. Link: [here](./Web-Design/README.md) |`)
* ❌ Plain text names with raw or separate URLs.

**Standard feature table:**
```markdown
| Feature | Description |
|:---|:---|
| [**Feature Name**](link-if-applicable) | One-line description of what it does |
```

**Section format** (native headings, foldable in Obsidian):
```markdown
### 🔍 Feature One
Description here

### ⚡ Feature Two
Description here
```

### 4.4 Collapsible sections

Use HTML `<details>` for long content that shouldn't dominate the page:

```html
<details>
<summary><b>Click to expand</b></summary>

Content here (must have blank line after summary tag)

</details>
```

### 4.5 Quick start / navigation

- Maximum 5 steps or commands
- Number each step
- Use `bash` or the appropriate syntax highlighting for terminal code blocks
- Include comments explaining each step
- Ensure the first step actually works

### 4.6 Diagrams (off by default)

This skill exists in part to **stop diagrams being auto-stamped into every README**. Diagrams are **off by default** — most READMEs need none. Include one only when *both* are true:

1. **It earns its place** — the user explicitly asks for one, OR a structure (a pipeline, a state flow, a folder hierarchy) is genuinely hard to convey in prose or a table.
2. **It stays small** — a compact diagram, not a sprawling wall. If a table or a short list captures it, prefer that instead.

When a diagram *is* warranted:
- Prefer an ASCII/tree block or a **small** Mermaid diagram — both render in GitHub and Obsidian.
- Never add "decorative" architecture diagrams that restate what the text already says.
- One purposeful diagram beats several. If in doubt, leave it out.

### 4.7 Root README footer

```html
<p align="center">
  Built with <a href="URL">Tool</a> · <a href="URL">Docs</a> · <a href="URL">License</a>
</p>
```

(For a folder README, the footer is the centered nav row in §3.2 instead.)

---

## 5. END-TO-END WORKFLOW

Work top-down. Layout first, then the skeleton, then fill each node.

1. **Survey the target.** New or existing? A code repo, a doc library, or an Obsidian vault? Is it a **web app/site** (→ §1.1 applies)? List every folder that holds content; ignore `node_modules/`, `.git/`, build output. For an existing repo, note which READMEs already exist and which are missing. Read the codebase or folder structure — understand what it does before writing. Identify the audience: developers, team members, or self-reference in Obsidian?

2. **Fix the layout** *(web apps — §1)*. Decide `src/` (framework) vs `site/` (static). For a new repo, scaffold it that way. For an existing one, move stray web/app artifacts off the root into that folder and repair the paths the move breaks. Keep the root to README + `docs/` + required config.

3. **Map the docs tree** *(§2)*. Mark where every `README.md` index belongs: the root, every content-bearing top-level folder, `docs/`, and every `docs/` sub-folder with 2+ documents. Note which exist and which are missing. Apply §2.4 so you don't over-index. This skeleton is what every later step fills in.

4. **Build the root `README.md`** — the **logo hero** header (§3.1) plus the body (§4). Its "what's in here" table links **down** to each top-level folder's README (including `src/`/`site/` and `docs/`). Gather the hero variables from the repo; ask only for what you truly can't determine.

5. **Build every other README** — for each folder index the skeleton calls for:
   - **Opener** → the folder/section header (§3.2): centered emoji-`<h1>` + tagline + 1–3 badge row.
   - **Body** → a leftmost-bold-column catalog table (§4.3) linking **down** to this folder's immediate children — sub-folder READMEs, or the final documents for a Tier-3 index. Group by purpose if the catalog is large.
   - **Footer** → the centered nav row linking **up** to the parent (and forward to a sibling where there's a reading order).

6. **Decide on a diagram — default to none** (§4.6).

7. **Wire and audit.** Confirm every down-link points at the child's **index** if it has one, and every index has an **up-link** home. Then run the navigability audit in §6. Finally, check no markdown is nested inside HTML block elements, and trim: if a README is over 200 lines, use collapsible sections.

---

## 6. NAVIGABILITY AUDIT

Run this checklist against any repo to find the breaks in the chain:

1. **Root has a `README.md`** with a navigation / "what's in here" table linking to top-level folder READMEs — not a bare project description.
2. **Every top-level folder that holds content has a `README.md`** (`src/`, `docs/`, `infra/`, …). A folder with no index is a dead end reachable only by browsing.
3. **`docs/` has a hub `README.md`** that links to each of its sub-folders.
4. **Every `docs/` sub-folder with 2+ documents has its own `README.md`** that links to those documents. ← *This is the tier most repos are missing.*
5. **Down-links point at the child's index**, not past it to a leaf, whenever that child has an index.
6. **Every index has an up-link** in its footer back to its parent (and the root is reachable by climbing).
7. **No orphans** — every document is reachable from the root by following links. Grep for `.md` files, then confirm each is linked from its folder's README.
8. **Links are relative** (`architecture/README.md`, `../README.md`) so they resolve in both GitHub and Obsidian.

For each failing item, either **create the missing `README.md`** (styled per §3 + §4) or **fix the link** to point at the right tier. Then re-walk from the root clicking only links: confirm you can reach every document and climb back to the root from anywhere.

---

## 7. SPECIAL CASES

- **Obsidian vault** — the recursive README-index tree works as a vault's navigation spine. Keep links **relative** and everything GitHub+Obsidian-safe (no markdown nested inside `<h1 align>`/`<p align>`/`<table>` HTML — §4.1). A folder note or `README.md` per folder acts as the map.
- **Existing repo, partial docs** — don't rebuild what's already good. Audit first (§6), then fill only the missing indexes and fix only the broken links. The common gap is Tier-3 sub-folder READMEs.
- **No logo asset yet** — the root hero falls back to a plain `# Project Name` H1, or ask for the logo path; never invent a file that isn't there.
- **Monorepo / multi-app folder** — treat each app as its own sub-tree with its own root-style README under its folder, and index them from the top-level README.
- **Non-code doc library or knowledge base** — the top-level folders *are* the content categories; skip §1.1 entirely and apply §2 directly.

---

## 8. ANTI-PATTERNS (NEVER DO THESE)

**Layout**
- **Web/app artifacts (HTML/CSS/JS/components/pages/assets) loose at the repo root** for a web-app repo — they belong in `src/` (framework) or `site/` (static). The root is documentation + meta + required config.
- **Relocating required root config** (`package.json`, lockfile, framework config) into `src/`/`site/` in the name of a clean root — those are the documented exception; leave them.

**Docs tree**
- **A `docs/` sub-folder full of documents with no `README.md` index** — the missing Tier 3. The parent hub is forced to link past it to individual files, and the folder is a dead end when opened.
- **The hub linking straight to leaf documents when a sub-folder index exists** — skips the map layer; the reader never learns the section exists as a unit.
- **A folder index that links to the whole deep tree** instead of just its immediate children — every index links exactly one level down.
- **Down-only indexes** — an index with no up-link to its parent traps the reader. Every folder is a two-way door.
- **Orphan documents** — a `.md` file no index links to. If it's worth keeping, some folder's README links to it.
- **Over-indexing** — a `README.md` whose only content is a link to one other file, or index tiers nested deeper than the content warrants.
- **Absolute or site URLs for internal links** — breaks in Obsidian and on forks; always relative.

**Headers & badges**
- **Putting the logo hero on a folder/subfolder README**, or leaving a folder README as a bare `# Heading` — non-root READMEs use the centered emoji-`<h1>` + tagline + one badge row.
- Leaving a placeholder / `⟨…⟩` badge, a badge that links nowhere, or a broken image path.
- **Inventing a logo file path** that isn't in the repo. Fall back to an H1 or ask.
- Logo `alt` text that's just the project name — it must describe what the project *is*.
- More than ~3 hero badges, ~6 inline tech badges, or 3 folder-header badges; a crowded header reads as noise.
- Left-aligning any header block, or mixing the two badge styles in one row (`for-the-badge` = hero row, `flat-square` = tech row).
- Using a `|` pipe or a comma inside a shields badge value (breaks the URL) — `_` for spaces, `·` for lists.

**Body & formatting**
- **Adding diagrams by default**, or large/sprawling diagrams — include one only when it clarifies something text or a table can't (§4.6).
- **Cataloging child folders/docs with the link in a separate or right-hand column** instead of the leftmost bold column (§4.3).
- **HTML layout grids containing markdown elements** — they fail to render in Obsidian.
- Walls of text without visual breaks.
- Code blocks without syntax highlighting.
- Tables with empty cells.
- Sections with no content ("Coming soon!").
- Duplicate information across sections.
- Screenshots that are too large or blurry.
