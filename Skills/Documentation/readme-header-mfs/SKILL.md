---
name: readme-header-mfs
description: >-
  Build the centered header block at the top of any README in a repo, matching Mike's Live-Apps house style — the full hero header for a repo-root README (logo, tagline, docs link, nav row, two badge rows), or the lighter section header for any non-root/folder README (emoji H1 title, tagline, one badge row). Use whenever the user wants to create or restyle the top/header/hero of a GitHub README, add the badge block, style a docs/ or subfolder index README's opener, or make a repo's README headers match the other Mikes_AI_Lab projects.
---

You build the **centered header block** at the top of a README — nothing below the first `---` divider. This skill is deliberately narrow: for the full README body (features, quick start, docs tables, footer) use `readme-builder-mfs` instead. It exists so every README in the collection opens with the **same** recognizable house style.

There are **two header types** — pick by the file's place in the repo:

- **Root hero header** — the top of a repository's **root `README.md`**. The big centered block a visitor sees first: logo, tagline, docs link, quick-nav row, hero badges, inline tech badges, closed by `---`.
- **Folder / section header** — the top of **every other README**: the one at the root of `docs/`, and of each folder and subfolder inside the repo. A lighter centered block: an emoji-led `<h1>` title, a one-line tagline, a single badge row, closed by `---`. Same family, less weight.

## When to use this skill

- Creating the top of a brand-new repo's root README from scratch (**root hero header**).
- Styling the opener of a `docs/` README or any folder/subfolder index README (**folder/section header**).
- Restyling an existing README's opener to match the Live-Apps house style.
- Adding or fixing the badge rows / nav row / tagline / emoji title at the top of any README.
- The user says "make the header(s) match TaskHub / Agent-Chat / the other repos."

Do **not** use it for the body of the README, or when the user wants a different visual identity than the house style.

## Root hero header — the house pattern (what every root header contains, in order)

1. **Top anchor** — `<a id="readme-top"></a>` so "back to top" links elsewhere resolve.
2. **Centered logo** — links to the live site; `alt` is a full one-sentence description of the project (not just the name); `width="720"`.
3. **Centered tagline** — italic `<em>`, one sentence, broken across two lines with `<br>`.
4. **Explore the docs** — a single centered bold link to the docs folder/README.
5. **Nav row** — centered, three links separated by ` · ` (middle dot): a live/demo link, Report Bug, Request Feature (both issue links).
6. **Hero badges** — centered, `style=for-the-badge`: live-site badge (green, `logo=vercel`), a status badge, and a roadmap/plan badge (purple). 3 badges is the norm.
7. **Inline tech badges** — centered, `style=flat-square`: the stack (language, framework, DB, notable tech). 3–6 badges, each with its brand `logo` where one exists.
8. **Divider** — a single `---` closing the header.

Keep everything centered with `<p align="center">` wrappers. Each block is its own `<p>`. Nothing but these eight elements belongs above the `---`.

## Root hero header — fill-in-the-blank template

Replace every `⟨…⟩`. Delete any badge line that doesn't apply — never leave a placeholder badge.

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
  <a href="⟨LIVE_URL⟩"><img src="https://img.shields.io/badge/⟨Live_Demo⟩-⟨host.example.com⟩-2ea44f?style=for-the-badge&logo=vercel&logoColor=white" alt="⟨Live Demo⟩"></a>
  <img src="https://img.shields.io/badge/status-⟨Status⟩-⟨COLOR⟩?style=for-the-badge" alt="Status: ⟨Status⟩">
  <a href="⟨ROADMAP_PATH⟩"><img src="https://img.shields.io/badge/plan-ROADMAP-8B5CF6?style=for-the-badge" alt="Roadmap"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square&logo=⟨logo⟩&logoColor=white" alt="⟨Tech⟩">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square&logo=⟨logo⟩&logoColor=white" alt="⟨Tech⟩">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square" alt="⟨Tech⟩">
</p>

---
```

## Conventions (match these exactly)

**Status badge** — pick the color from the project's maturity:

| Status text | Color hex | Meaning |
|:---|:---|:---|
| `Active` | `e74c3c` | Live and maintained |
| `experimental` | `F59E0B` | Early / unstable |
| `MVP_Prototype` | `F59E0B` | Prototype-stage |
| `Stable` | `2ea44f` | Production-ready |

**Standard badge colors** (shields.io):

| Purpose | Hex |
|:---|:---|
| Live site / success / version | `2ea44f` (or `10b981` teal-green) |
| Status / warning | `F59E0B` (amber) or `e74c3c` (red for Active) |
| Roadmap / plan / model | `8B5CF6` (purple) |
| Platform / primary | `0078D4` (blue) |
| Accent | `F97316` (orange) |
| Neutral | `6B7280` (gray) |

**Tech badges** — use each tool's real brand `logo` slug and its brand hex where recognizable (e.g. `react`/`61DAFB`, `typescript`/`3178C6`, `node.js`/`339933`, `postgresql`/`4169E1`, `python`/`3776AB`, `sqlite`/`003B57`, `astro`/`BC52EE`, `.net`/`512BD4`, `vercel`). For anything without a logo (a made-up label like "theme-dark_by_default"), omit `logo` and pick a neutral/thematic hex. Use `_` for spaces and `·` (raw middle dot) for "or"-lists inside a single badge value.

**Logo image** — the header logo is usually a project SVG at a repo-relative path (e.g. `images/⟨Project⟩-Images/logos/dark/landscape-XX-name.svg`), not a shields badge. If the repo has no logo asset yet, either use a plain `# Project Name` H1 as a fallback or ask the user for the logo path — don't invent a file path that doesn't exist.

## Folder / section header — the pattern for every non-root README

Only the **repo root** gets the logo hero above. **Every other README** — at the root of `docs/`, and of each folder and subfolder inside the repo — opens with this lighter centered header instead. It's what makes `docs/README.md`, `docs/install/README.md`, `docs/agent-tools/README.md`, `docs/agent-tools/mcp/README.md` all read as one family.

In order, the block contains:

1. **Top anchor** *(optional)* — `<a id="⟨folder⟩-top"></a>` (e.g. `docs-top`). Add it **only** on longer hub pages that will want a "back to top" link (like `docs/README.md`); skip it on short section pages.
2. **Centered emoji H1** — `<h1 align="center">⟨emoji⟩ ⟨Section Title⟩</h1>`. The emoji sits on the **left** of the title. This replaces the logo — no image.
3. **Centered tagline** — italic `<em>`, one sentence saying what lives in this folder. Usually one line (no `<br>` split needed).
4. **One badge row** — centered, `style=for-the-badge`, **1–3 contextual badges**: topical scope/status badges for this section, plus (where useful) a "back up" badge linking to the parent or repo root (e.g. `↩ repository_root`, `↩ Docs`).
5. **Divider** — a single `---` closing the header.

Everything stays centered with `<h1 align="center">` / `<p align="center">` wrappers holding **only text + emoji + shields images** — never nested markdown — so it renders in both GitHub and Obsidian.

### Folder / section header — fill-in-the-blank template

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

**Badge colors** reuse the same table as the hero (purple `8B5CF6` for plan/audience, green `2ea44f` for status/roadmap, gray `6B7280` for the neutral "back up" badge, blue/orange/amber for topical scope). Same shields rules: `_` for spaces, `·` for lists, delete any badge that doesn't earn its place.

**Real examples** (from TaskHub) to match:

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

> [!NOTE]
> This skill is header-only. The matching **footer** for a folder README — a centered `← Parent home · Sibling · Next: X →` nav row, plus a right-aligned `(back to top)` on pages that used a top anchor — belongs to the full-README skill. Use `readme-builder-mfs` when you also need the body and footer wired into the navigable README tree.

## Execution checklist

**First: pick the header type.** Is this the **repo-root** README (→ root hero header) or a **folder/subfolder** README (→ folder/section header)? A logo hero on a subfolder, or a bare `#` heading where a section header belongs, is wrong.

**For a root hero header:**

1. **Gather the variables** — live URL, GitHub owner/repo (for the issues URL), docs path, roadmap path, one-sentence description, two-line tagline, project status, and the tech stack. Read the repo (package.json, existing README, `docs/`) to fill these in; ask only for what you genuinely can't determine.
2. **Confirm the logo** — find the logo SVG/PNG path in the repo; if none exists, fall back to an H1 title or ask.
3. **Fill the template** — replace every `⟨…⟩`; delete inapplicable badge lines entirely.
4. **Set the status badge** color from the maturity table.
5. **Pick tech badges** — 3–6, real brand logos + hex, ordered most-defining-first.
6. **Verify every link** — live URL, docs path, roadmap path, and issues URL all resolve; relative paths are correct for the repo root.
7. **Confirm the `alt` text** on the logo is a full descriptive sentence, and each badge has meaningful `alt`.
8. **Close with `---`** and stop — do not write the README body (that's `readme-builder-mfs`).

**For a folder / section header:**

1. **Write the emoji title** — a short section title with a leading emoji that fits the folder's purpose (📚 docs, ⬇️ install, ⚙️ setup, 🔌 MCP, 🛠️ tools…).
2. **Write the tagline** — one sentence on what lives in this folder.
3. **Pick 1–3 badges** — topical scope/status for the section, plus a neutral gray "↩ back up" badge to the parent or repo root where it helps navigation.
4. **Add a top anchor only if it's a long hub page** — otherwise skip it (and skip the matching back-to-top link).
5. **Verify the "back up" link** resolves relative to *this* folder (`../README.md` for one level up), and close with `---`.

**Both:** if placing into an existing README, splice the block **above** the existing content, replacing any prior header.

## Anti-patterns (never do these)

- Writing the README body, feature tables, or footer — this skill is the header only.
- Putting the **logo hero on a folder/subfolder README**, or leaving a folder README opener as a bare `# Heading` — non-root READMEs use the centered emoji-`<h1>` + tagline + one badge row.
- Leaving a placeholder/`⟨…⟩` badge, a badge that links nowhere, or a broken image path.
- Inventing a logo file path that isn't in the repo. Fall back to an H1 or ask.
- Logo `alt` text that's just the project name — it must describe what the project *is*.
- More than ~3 hero badges or more than ~6 inline tech badges (root), or more than 3 badges in a folder header; a crowded header reads as noise.
- Left-aligning any block, or mixing the two badge styles in the hero (`for-the-badge` is for the hero row, `flat-square` for the tech row).
- Using a `|`-pipe or comma inside a shields badge value (breaks the URL) — use `_` for spaces and `·` for lists.
- Nesting markdown (`##`, `*`, tables) inside the `<h1 align="center">` / `<p align="center">` HTML — keep the header pure HTML + shields images so it renders in both GitHub and Obsidian.
