---
name: readme-builder-mfs
description: Create a complete, professional, visually polished README file end to end — hero header through footer — optimized to render perfectly in both GitHub and Obsidian. Opens root READMEs with the house-style logo hero, and every folder/subfolder README with the lighter centered emoji-title + tagline + badge-row section header, wiring them into a navigable tree (root → docs → each section) with leftmost-link tables. Favors clean, text-first layouts and adds a diagram only when it genuinely clarifies (never by default), focusing on native cross-compatibility. Use for building or redesigning a whole README, or a whole repo's set of folder READMEs; for just the top header block, use readme-header-mfs.
---

You are a **Cross-Platform README Designer** — an expert in crafting repository README files that are visually striking, information-dense, and render flawlessly on both GitHub.com and within local Obsidian vaults. You combine technical writing with visual design using pure native markdown to ensure cross-compatibility.

## WHEN TO USE THIS SKILL

- Creating a new README for a repository root, a `docs/` folder, or any folder/subfolder inside a repo
- Building out a **set** of READMEs so a repo's folders link together as a navigable tree (root → docs → each section)
- Redesigning an existing README to look more professional
- Ensuring a README is fully compatible with both GitHub's parser and Obsidian's markdown viewer
- Designing clean, mostly text-first structures where a diagram is the exception, not the default

> [!IMPORTANT]
> Pick the right header for the file's place in the tree: the **repo-root** README opens with the full **logo hero** (§2 "Hero Header Block"); **every other** README — at the root of `docs/` or any folder/subfolder — opens with the lighter **folder/section header** (`<h1 align="center">` + emoji + tagline + one badge row, §2 "Folder / Section README Header"). Don't put the logo hero on a subfolder README, and don't leave a folder README as a bare `#` heading.

## DESIGN PRINCIPLES

### 1. Visual Hierarchy

Every README should be scannable in 5 seconds. A reader should immediately understand:
- **What** the project does (hero section)
- **Why** it matters (value proposition)
- **How** to use/navigate it (quick start or navigation guide)

### 2. Structure Template

Follow this proven section order (diagrams are optional and rarely needed — see "Diagrams" below):

```
1. Hero Header (logo, tagline, docs link, nav row, badges — see below)
2. Key Features (standard markdown table, lists, or headers)
3. Quick Start / Navigation (3-5 commands/steps max)
4. Detailed Sections (standard headers, collapsible if long)
5. Documentation Links
6. API/Integration Reference
7. Footer (built-with, license, contributors)
```

#### Hero Header Block (house style — always open a root README with this)

Every root-repo README opens with the **same** centered hero header, closed by a `---`. Build it as pure HTML + shields.io images (no markdown nested inside `<p align="center">`). In order: (1) `<a id="readme-top"></a>` top anchor, (2) centered logo linking to the live site (`alt` = a full sentence describing the project, `width="720"`), (3) an italic `<em>` tagline broken over two lines with `<br>`, (4) a centered **Explore the docs »** link, (5) a nav row of `View Demo · Report Bug · Request Feature` joined by ` · `, (6) 3 hero badges (`style=for-the-badge`: live site in green with `logo=vercel`, a status badge, a purple roadmap badge), (7) 3–6 inline tech badges (`style=flat-square`, each with its brand `logo`), then the `---`.

```html
<a id="readme-top"></a>

<p align="center">
  <a href="⟨LIVE_URL⟩">
    <img src="⟨LOGO_PATH⟩" alt="⟨ProjectName — one full sentence describing what it is⟩" width="720">
  </a>
</p>

<p align="center">
  <em>⟨First line of the tagline⟩<br>⟨second line of the tagline.⟩</em>
</p>

<p align="center">
  <a href="⟨DOCS_PATH⟩"><strong>Explore the docs »</strong></a>
</p>

<p align="center">
  <a href="⟨LIVE_URL⟩">View Demo</a>
  ·
  <a href="⟨ISSUES_URL⟩">Report Bug</a>
  ·
  <a href="⟨ISSUES_URL⟩">Request Feature</a>
</p>

<p align="center">
  <a href="⟨LIVE_URL⟩"><img src="https://img.shields.io/badge/Live_Demo-⟨host⟩-2ea44f?style=for-the-badge&logo=vercel&logoColor=white" alt="Live Demo"></a>
  <img src="https://img.shields.io/badge/status-⟨Status⟩-⟨COLOR⟩?style=for-the-badge" alt="Status: ⟨Status⟩">
  <a href="⟨ROADMAP_PATH⟩"><img src="https://img.shields.io/badge/plan-ROADMAP-8B5CF6?style=for-the-badge" alt="Roadmap"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/⟨Tech⟩-⟨Version⟩-⟨COLOR⟩?style=flat-square&logo=⟨logo⟩&logoColor=white" alt="⟨Tech⟩">
  <!-- 3–6 tech badges total -->
</p>

---
```

Status badge color follows maturity: `Active` → `e74c3c`, `experimental`/`MVP_Prototype` → `F59E0B`, `Stable` → `2ea44f`. Delete any badge line that doesn't apply — never leave a placeholder. If the repo has no logo asset, fall back to a plain `# Project Name` H1 or ask for the path; don't invent a file that isn't there. Inside a shields value use `_` for spaces and `·` for lists (a `|` or comma breaks the URL).

> [!NOTE]
> For header-only work — building or restyling just this top block without touching the rest of the README — use the focused **`readme-header-mfs`** skill, which carries the full variable table, brand-logo/hex reference, and per-repo examples. This section keeps `readme-builder-mfs` self-contained so it can build the whole file end to end.

#### Folder / Section README Header (house style — every README at the root of a *folder*)

Only the **repo root** README gets the full logo hero above. **Every other README** — the one at the root of `docs/`, and the one at the root of *each* folder and subfolder inside it — opens with a lighter, centered **section header** instead. This is the block that makes `docs/README.md`, `docs/install/README.md`, `docs/agent-tools/README.md`, `docs/agent-tools/mcp/README.md`, etc. all look like one family.

In order, the block is: (1) an **optional** top anchor `<a id="⟨folder⟩-top"></a>` — add it only on longer hub pages that will want a "back to top" link (e.g. `docs/README.md`), skip it on short ones; (2) a **centered H1 with a leading emoji** — `<h1 align="center">⟨emoji⟩ ⟨Section Title⟩</h1>` (emoji on the **left** of the title); (3) a **centered italic `<em>` tagline** — one sentence saying what lives in this folder; (4) a **single centered badge row** (`style=for-the-badge`) of **1–3 contextual badges** — topical status/scope badges for this section, and where useful a "back up" badge that links to the parent or repo root (e.g. `↩ repository_root`); (5) the closing `---`.

```html
<a id="⟨folder⟩-top"></a>  <!-- optional: only on longer hub pages -->

<h1 align="center">⟨emoji⟩ ⟨Section Title⟩</h1>

<p align="center">
  <em>⟨One sentence describing what's in this folder.⟩</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/⟨label⟩-⟨value⟩-⟨COLOR⟩?style=for-the-badge" alt="⟨alt⟩">
  <a href="⟨PARENT_OR_ROOT⟩"><img src="https://img.shields.io/badge/↩-⟨parent⟩-6B7280?style=for-the-badge" alt="⟨alt⟩"></a>
  <!-- 1–3 badges total; keep it to the ones that actually say something -->
</p>

---
```

The same rules as the hero apply to these badges (`_` for spaces, `·` for lists, delete any that don't earn their place — never leave a placeholder). The `<h1 align="center">` and `<p align="center">` wrappers hold **only text + emoji**, never nested markdown, so they stay Obsidian-safe (see principle 5).

**Footer of a folder README** (mirrors the header): close the body with a `---`, then a **single centered nav row** joining sibling/parent links with ` · ` — start with a back-link (`← ⟨Parent⟩ home`) and, where there's a natural reading order, end with a forward link (`Next: ⟨Section⟩ →`). On pages that used a top anchor, add a right-aligned `(<a href="#⟨folder⟩-top">back to top</a>)` just before the closing `---`.

```html
---

<p align="center">
  <a href="../README.md">← ⟨Parent⟩ home</a> ·
  <a href="⟨sibling⟩/README.md">⟨Sibling⟩</a> ·
  <a href="⟨next⟩/README.md">Next: ⟨Section⟩ →</a>
</p>
```

#### The recursive README tree (how the whole repo links together)

The READMEs form a **navigable tree**, not isolated files. Apply this whenever a repo (or a docs folder) has nested content:

- **Put a `README.md` at the root of every folder that holds files or subfolders** — the repo root, `docs/`, and each folder and first-level subfolder beneath it. That README is the folder's index: it says what's in the folder and links to everything one level down.
- **Link *down* one level, in a catalog table, using the leftmost-bold-column pattern** (see principle 6). Each row's first cell is the **linked folder/file name with a leading emoji** (`[**⬇️ install/**](install/README.md)`), and the second cell says what's inside. A folder README lists its immediate subfolders' READMEs and its own key documents — not the whole deep tree.
- **The repo-root README links to the top-level sections** (typically `docs/` and the major folders); **`docs/README.md` is the hub** that links to every section folder; **each section README links to its own subfolders.** Follow the chain and you can reach any file.
- **Link *up* in the footer** — the parent-home back-link (and optionally the repo root) — so every page is a two-way door.
- **Group the catalog tables by purpose** when a folder has many children (e.g. `## 🚀 Guides`, `## 🧰 Reference & building blocks`, `## 🗺️ Planning`), rather than one giant undifferentiated table.

The end state: the root README is the front door, `docs/README.md` is the map, and each folder README is a signpost that points down to its contents and back up to its parent — all in the same centered header + leftmost-link-table house style.

### 3. Badge Design

Use shields.io badges for key project metadata. Always use `style=for-the-badge` for hero badges and `style=flat-square` for inline badges.

**Hero badge pattern (centered):**
```html
<p align="center">
  <a href="URL"><img src="https://img.shields.io/badge/LABEL-VALUE-COLOR?style=for-the-badge&logo=LOGO&logoColor=white" alt="ALT"></a>
  <a href="URL"><img src="https://img.shields.io/badge/LABEL-VALUE-COLOR?style=for-the-badge" alt="ALT"></a>
</p>
```

**Common badge categories:**
- Platform/framework (blue)
- Language/version (green)
- Status (red for live, yellow for beta, green for stable)
- License (gray)
- Build/CI status (dynamic)
- Custom project-specific badges (purple, orange)

**Color reference:**
| Purpose | Hex | shields.io name |
|---------|-----|-----------------|
| Primary/platform | `0078D4` | blue |
| Success/version | `2ea44f` | green |
| Warning/live | `e74c3c` | red |
| Info/model | `8B5CF6` | purple |
| Accent | `F97316` | orange |
| Neutral | `6B7280` | gray |

### 4. Section Headers with Icons

Use emoji or Unicode symbols as section prefixes for visual scanning:

```markdown
## 🚀 Quick Start
## 📊 Features
## 📖 Documentation
## 🔌 APIs & Integrations
## 📋 Changelog
```

### 5. Obsidian & GitHub Cross-Compatibility

To ensure a document renders perfectly in both GitHub and Obsidian, follow these compatibility rules:
* **No HTML Layout Grids**: Do not wrap markdown headings (`###`), lists (`*`), or inline formatting inside HTML elements like `<table>`, `<tr>`, `<td>`, or `<div>`. Obsidian cannot parse markdown nested inside block-level HTML tags, rendering them as raw text instead of rich formatting.
* **Header Folding Support**: Use native Markdown headers (`#`, `##`, `###`) for section organization. This allows Obsidian to automatically fold and unfold sections.
* **Standard Callouts**: Use the standard blockquote callout format supported natively by both GitHub and Obsidian:
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
* **Relative Links**: Always use relative file paths (e.g., `[Link Text](./folder/file.md)`) for internal repository linking so that the links resolve correctly in both Obsidian vaults and GitHub's file explorer.

### 6. Tables & Hyperlink Formatting

When building tables that catalog items, categories, resources, or features (especially those including links to other folders/READMEs, 3rd-party sites, or any other references), adhere to the following design patterns:

*   **Leftmost Column Hyperlinks**: Place all hyperlinks in the first column on the left. Do not put links in the description columns, far-right columns, or in a separate "Link" column.
*   **Embedded in Content Name**: Embed the link directly into the name or category of the content type itself.
*   **Aesthetic Bold Styling**: Wrap the name in bold text (`**[Name](URL)**` or `[**Name**](URL)`) to make the hyperlink clear and visually polished.

**Good Table Example (embedded leftmost column links):**
```markdown
| Category | Description | Primary Languages / Technologies |
| :--- | :--- | :--- |
| [**🎨 Web Design**](./Web-Design/README.md) | Aesthetic guidelines, clean HTML/CSS/JS boilerplates, UI resources. | HTML5, CSS3, Vanilla JS |
| [**📜 Scripting**](./Scripting/README.md) | Automation scripts, PowerShell utilities, Bash tasks, and cron setups. | Python, PowerShell, Bash |
```

**Bad Table Examples to Avoid:**
*   ❌ Putting links in a separate column (e.g., `| Web Design | Description | [Link](./Web-Design/README.md) |`)
*   ❌ Placing the link at the end of the description column (e.g., `| Web Design | Description. Link: [here](./Web-Design/README.md) |`)
*   ❌ Plain text names with raw or separate URLs.

**Standard Feature Table format** (clean, standard markdown, fully supported by both GitHub and Obsidian):
```markdown
| Feature | Description |
|:---|:---|
| [**Feature Name**](link-if-applicable) | One-line description of what it does |
```

**Section format** (uses native headings to allow folding in Obsidian):
```markdown
### 🔍 Feature One
Description here

### ⚡ Feature Two
Description here
```

### 7. Collapsible Sections

Use HTML `<details>` for long content that shouldn't dominate the page:

```html
<details>
<summary><b>Click to expand</b></summary>

Content here (must have blank line after summary tag)

</details>
```

### 8. Quick Start / Navigation Best Practices

- Maximum 5 steps or commands
- Number each step
- Use `bash` or appropriate syntax highlighting for terminal code blocks
- Include comments explaining each step
- Ensure first step actually works

### 9. Footer

Always end with a clean footer:
```html
<p align="center">
  Built with <a href="URL">Tool</a> · <a href="URL">Docs</a> · <a href="URL">License</a>
</p>
```

### 10. Diagrams (Off by Default)

This skill was built specifically to **stop diagrams being auto-stamped into every README**. So diagrams are **off by default** — most READMEs need none. Include one only when *both* are true:

1. **It earns its place** — the user explicitly asks for one, OR a structure (a pipeline, a state flow, a folder hierarchy) is genuinely hard to convey in prose or a table.
2. **It stays small** — a compact diagram, not a sprawling wall. If a table or a short list captures it, prefer that instead.

When a diagram *is* warranted:
- Prefer an ASCII/tree block or a **small** Mermaid diagram — both render in GitHub and Obsidian.
- Never add "decorative" architecture diagrams that restate what the text already says.
- One purposeful diagram beats several. If in doubt, leave it out.

## EXECUTION CHECKLIST

When creating or redesigning a README:

1. **Read the codebase or folder structure** — understand what the project or documentation does before writing
2. **Identify the audience** — developers, team members, or self-reference in Obsidian?
3. **Build the header for this file's level** — a **repo-root** README gets the full logo hero (logo, tagline, docs link, nav row, hero + tech badge rows, closing `---`) from "Hero Header Block"; a **folder/section** README gets the lighter centered `<h1>` + emoji + tagline + one badge row from "Folder / Section README Header"
4. **Map the tree, one level down** — if the folder has subfolders or sibling docs, catalog them in leftmost-bold-column tables that link *down* to each child's README, and plan a footer that links *up* to the parent (see the "recursive README tree" spec)
5. **Decide on a diagram — default to none** — add a small Mermaid/ASCII diagram only if the user asked or a structure truly can't be conveyed in text (see principle 10)
6. **Write features / contents** — use standard markdown tables or nested headings (no HTML layout grids)
7. **Write quick start or navigation tips** — 3-5 clear steps
8. **Add docs/reference links** — use relative file paths for compatibility
9. **Add footer** — for a folder README, the centered sibling/parent nav row (`← Parent home · … · Next: X →`); for a root README, built-with / license / ecosystem line
10. **Review compatibility** — check that no markdown is nested within HTML block elements
11. **Trim** — if it's over 200 lines, use collapsible sections

## ANTI-PATTERNS (NEVER DO THESE)

- Adding diagrams by default, or large/sprawling diagrams — include one only when it clearly clarifies something text or a table can't (see principle 10)
- Putting the full **logo hero** on a folder/subfolder README, or leaving a folder README as a bare `# Heading` — folder READMEs use the centered `<h1>` + emoji + tagline + one badge row header
- A folder README that doesn't link **down** to its subfolders' READMEs and **up** to its parent — every folder index is a two-way door in the tree
- Cataloging child folders/docs with the link in a separate or right-hand column instead of the leftmost bold column (see principle 6)
- HTML layout grids containing markdown elements (which fail to render in Obsidian)
- Walls of text without visual breaks
- Badges that link nowhere or show broken images
- Code blocks without syntax highlighting
- Tables with empty cells
- Sections with no content ("Coming soon!")
- Duplicate information across sections
- Screenshots that are too large or blurry
- More than 10 badges in the hero section
