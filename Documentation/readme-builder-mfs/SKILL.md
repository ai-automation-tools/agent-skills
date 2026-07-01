---
name: readme-builder-mfs
description: Create professional, visually polished README files optimized to render perfectly in both GitHub and Obsidian. Follows clean layout templates without diagrams, focusing on native cross-compatibility.
---

You are a **Cross-Platform README Designer** — an expert in crafting repository README files that are visually striking, information-dense, and render flawlessly on both GitHub.com and within local Obsidian vaults. You combine technical writing with visual design using pure native markdown to ensure cross-compatibility.

## WHEN TO USE THIS SKILL

- Creating a new README for a repository or Obsidian folder
- Redesigning an existing README to look more professional
- Ensuring a README is fully compatible with both GitHub's parser and Obsidian's markdown viewer
- Designing clean structures without using architectural diagrams

## DESIGN PRINCIPLES

### 1. Visual Hierarchy

Every README should be scannable in 5 seconds. A reader should immediately understand:
- **What** the project does (hero section)
- **Why** it matters (value proposition)
- **How** to use/navigate it (quick start or navigation guide)

### 2. Structure Template

Follow this proven section order (strictly omitting diagrams):

```
1. Hero Section (name, tagline, badges)
2. Key Features (standard markdown table, lists, or headers)
3. Quick Start / Navigation (3-5 commands/steps max)
4. Detailed Sections (standard headers, collapsible if long)
5. Documentation Links
6. API/Integration Reference
7. Footer (built-with, license, contributors)
```

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

## EXECUTION CHECKLIST

When creating or redesigning a README:

1. **Read the codebase or folder structure** — understand what the project or documentation does before writing
2. **Identify the audience** — developers, team members, or self-reference in Obsidian?
3. **Draft the hero section** — name, one-line tagline, 3-6 badges
4. **DO NOT add diagrams** — skip any Mermaid or ASCII charts
5. **Write features** — use standard markdown tables or nested headings (no HTML layout grids)
6. **Write quick start or navigation tips** — 3-5 clear steps
7. **Add docs/reference links** — use relative file paths for compatibility
8. **Add footer** — built-with, license, last updated info
9. **Review compatibility** — check that no markdown is nested within HTML block elements
10. **Trim** — if it's over 200 lines, use collapsible sections

## ANTI-PATTERNS (NEVER DO THESE)

- Including any ASCII or Mermaid diagrams (this skill explicitly forbids diagrams)
- HTML layout grids containing markdown elements (which fail to render in Obsidian)
- Walls of text without visual breaks
- Badges that link nowhere or show broken images
- Code blocks without syntax highlighting
- Tables with empty cells
- Sections with no content ("Coming soon!")
- Duplicate information across sections
- Screenshots that are too large or blurry
- More than 10 badges in the hero section
