---
name: readme-header-mfs
description: >-
  Build the hero header block (roughly the first 40 lines) at the top of a repo's root README — centered logo, tagline, docs link, nav row, and two badge rows — matching Mike's Live-Apps house style. Use whenever the user wants to create or restyle the top/header/hero of a GitHub README, add the badge block, or make a new repo's README opener match the other Mikes_AI_Lab projects.
---

You build the **hero header** at the very top of a repository's **root `README.md`** — nothing below the first divider. This is the centered block a visitor sees first: logo, tagline, docs link, quick-nav row, hero badges, and inline tech badges, closed by a `---` rule. It is deliberately narrow: for the full README body (features, quick start, docs tables, footer) use `readme-builder-mfs` instead. This skill exists so every repo in the collection opens with the **same** recognizable header.

## When to use this skill

- Creating the top of a brand-new repo's root README from scratch.
- Restyling an existing README's opener to match the Live-Apps house style.
- Adding or fixing the badge rows / nav row / tagline at the top of a README.
- The user says "make the header match TaskHub / Agent-Chat / the other repos."

Do **not** use it for the body of the README, for non-root READMEs (subfolder index pages), or when the user wants a different visual identity than the house style.

## The house pattern (what every header contains, in order)

1. **Top anchor** — `<a id="readme-top"></a>` so "back to top" links elsewhere resolve.
2. **Centered logo** — links to the live site; `alt` is a full one-sentence description of the project (not just the name); `width="720"`.
3. **Centered tagline** — italic `<em>`, one sentence, broken across two lines with `<br>`.
4. **Explore the docs** — a single centered bold link to the docs folder/README.
5. **Nav row** — centered, three links separated by ` · ` (middle dot): a live/demo link, Report Bug, Request Feature (both issue links).
6. **Hero badges** — centered, `style=for-the-badge`: live-site badge (green, `logo=vercel`), a status badge, and a roadmap/plan badge (purple). 3 badges is the norm.
7. **Inline tech badges** — centered, `style=flat-square`: the stack (language, framework, DB, notable tech). 3–6 badges, each with its brand `logo` where one exists.
8. **Divider** — a single `---` closing the header.

Keep everything centered with `<p align="center">` wrappers. Each block is its own `<p>`. Nothing but these eight elements belongs above the `---`.

## Fill-in-the-blank template

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

## Execution checklist

1. **Gather the variables** — live URL, GitHub owner/repo (for the issues URL), docs path, roadmap path, one-sentence description, two-line tagline, project status, and the tech stack. Read the repo (package.json, existing README, `docs/`) to fill these in; ask only for what you genuinely can't determine.
2. **Confirm the logo** — find the logo SVG/PNG path in the repo; if none exists, fall back to an H1 title or ask.
3. **Fill the template** — replace every `⟨…⟩`; delete inapplicable badge lines entirely.
4. **Set the status badge** color from the maturity table.
5. **Pick tech badges** — 3–6, real brand logos + hex, ordered most-defining-first.
6. **Verify every link** — live URL, docs path, roadmap path, and issues URL all resolve; relative paths are correct for the repo root.
7. **Confirm the `alt` text** on the logo is a full descriptive sentence, and each badge has meaningful `alt`.
8. **Close with `---`** and stop — do not write the README body (that's `readme-builder-mfs`).
9. If placing into an existing README, splice this block **above** the existing content, replacing any prior header.

## Anti-patterns (never do these)

- Writing the README body, feature tables, or footer — this skill is the header only.
- Leaving a placeholder/`⟨…⟩` badge, a badge that links nowhere, or a broken image path.
- Inventing a logo file path that isn't in the repo. Fall back to an H1 or ask.
- Logo `alt` text that's just the project name — it must describe what the project *is*.
- More than ~3 hero badges or more than ~6 inline tech badges; a crowded header reads as noise.
- Left-aligning any block, or mixing the two badge styles (`for-the-badge` is for the hero row, `flat-square` for the tech row).
- Using a `|`-pipe or comma inside a shields badge value (breaks the URL) — use `_` for spaces and `·` for lists.
- Nesting markdown (`##`, `*`, tables) inside the `<p align="center">` HTML — keep the header pure HTML + shields images so it renders in both GitHub and Obsidian.
