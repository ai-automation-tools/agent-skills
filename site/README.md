<h1 align="center">🖥️ Showcase site</h1>

<p align="center">
  <em>The Core catalog in a browser — one card per Core skill, each with a screenshot,<br>
  its capabilities, and a one-line install command.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/stack-vanilla_HTML_·_CSS_·_JS-F59E0B?style=for-the-badge" alt="Vanilla HTML, CSS and JavaScript">
  <img src="https://img.shields.io/badge/build_step-none-2ea44f?style=for-the-badge" alt="No build step">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-repository_root-6B7280?style=for-the-badge" alt="Repository root"></a>
</p>

---

Three files and an image folder. No framework, no `package.json`, nothing to compile.

## 📁 What's in here

| File | What it is |
|:---|:---|
| [**index.html**](./index.html) | The page: hero, the Core skill cards, the Domain and Project lists, the install commands. Everything renders before JavaScript runs. The cards, filter chips, lists and counts sit between `<!-- gen:… -->` markers and are **generated** — don't hand-edit inside them. |
| [**showcase.json**](./showcase.json) | The hand-written card copy: each Core skill's glyph, tagline, feature bullets and screenshot `alt` text, plus the glyph for each Domain and Project group. Card order follows this file. |
| [**styles.css**](./styles.css) | The dark theme. A card takes its colour from its `data-category`, which means a new category is one accent variable. |
| [**script.js**](./script.js) | The typewriter hero, category filters, copy buttons, and the screenshot lightbox. |
| [**assets/img/**](./assets/img/README.md) | The screenshots, plus the naming rules the page follows. |
| [**assets/diagrams/**](./assets/diagrams/task-router.html) | Sources for any diagram that ships as an image. `task-router.html` is a 1600 × 1000 page that renders to `assets/img/task-router.webp`; edit it and screenshot it again if the tiers change. |
| [**CNAME**](./CNAME) | `agent-skills.ai-automation-tools.dev`. Shipped inside the published folder so the custom domain re-asserts itself on every deploy. |

## 🚀 Run it

1. Open the page directly.

   ```powershell
   start index.html
   ```

2. Or serve the folder, which is the safer bet:

   ```powershell
   python -m http.server 8080 --directory site
   ```

   Then visit `http://localhost:8080`.

> [!TIP]
> Serve it rather than double-clicking the file. The page probes for screenshots by trying several extensions in turn, and Chrome will refuse some of those requests over `file://`.

## 🖼️ Adding screenshots

Name the image after the skill and drop it into `assets/img/`:

```text
site/assets/img/task-router.png
```

The card picks it up on the next reload. Add `-2`, `-3` or `-4` to a name for extra shots in the lightbox gallery. A card with no image shows a placeholder, so you can fill them in a few at a time.

The table of expected filenames is in [`assets/img/README.md`](./assets/img/README.md).

## ✏️ Editing the copy

The **Skills/ tree decides what's on the page**; [`showcase.json`](./showcase.json) only supplies the words. After adding, renaming or removing a skill, or editing its copy:

```powershell
python scripts/build-showcase.py          # rewrites the generated regions of index.html
python scripts/build-showcase.py --check  # what CI runs: fails if index.html is out of date
```

- **A new Core skill** gets a card even with no `showcase.json` entry: the tagline is the first sentence of its `description` and there are no bullets. Add an entry (glyph, tagline, features, alt) to give it real copy.
- **An entry for a skill that no longer exists** fails the check, so stale copy can't linger.
- **Reorder** cards by reordering `showcase.json`. Skills without an entry come last, alphabetically.
- **Domain and Project lists** follow the tree, alphabetically within each group; `showcase.json` only gives each group its glyph and order.
- Text outside the markers (hero copy, install blocks, section intros) is still hand-edited. Colours come from `data-category`, so a new category needs a `--c-<name>` variable in `styles.css` and nothing else.

## 🌐 Publishing

Live at **[agent-skills.ai-automation-tools.dev](https://agent-skills.ai-automation-tools.dev)**, linked from the org landing page at [ai-automation-tools.dev](https://ai-automation-tools.dev).

[`.github/workflows/pages.yml`](../.github/workflows/pages.yml) uploads this folder to GitHub Pages on any push to `main` that touches `site/`. Nothing is compiled — the artifact is the folder.

> [!NOTE]
> **The Pages source is a workflow, not a branch folder.** Classic Pages only offers `/` or `/docs` as a source directory, and this site lives in `/site` — so the deployment runs as an Action instead. Leave the repo's Pages setting on **GitHub Actions**; switching it back to *Deploy from a branch* silently stops publishing this folder.

Any static host works the same way: serve `site/` as the document root.

## 🚧 Action items

What's left before this page is finished, in rough order of what matters most.

### 📸 Screenshots

Every card has an image now.

- [ ] Decide whether the four seeded `repo-docs-builder` images stay. They're rendered examples lifted from the skill's own `Resources/` folder, so they show the output a run produces rather than the skill at work.
- [ ] Compress what goes in. Most images are WebP now; the seeded `repo-docs-builder` PNGs still run up to 274 KB.

### 🌐 Hosting

Published by [`pages.yml`](../.github/workflows/pages.yml) to `agent-skills.ai-automation-tools.dev`.

- [x] Turn on GitHub Pages, source **GitHub Actions**, publishing `site/`.
- [ ] Add the URL to the repo's About panel so people can find it from GitHub.
- [ ] Add an `og:image` (a 1200 × 630 crop of the hero) and a `twitter:card`. A shared link previews as bare text right now, and the org landing page now sends traffic here.

### 🔁 Copy that drifts

Since 2026-10-05 the cards, chips, group lists and counts are generated from the `Skills/` tree and CI fails when the page falls behind. What's left is the wording in `showcase.json`, which is still hand-written.

- [ ] Re-read the taglines and feature lists in `showcase.json` against the current `SKILL.md` files.
- [x] Pick a sync story: `scripts/build-showcase.py` generates the cards from the tree and `showcase.json`, checked in CI. *(2026-10-05)*
- [x] Re-check the project list against `Skills/Projects/`: generated from the tree now, along with the Domain list. *(2026-10-05)*

### ♿ Accessibility

- [ ] Give the filter chips `aria-pressed`, so the selected category is announced instead of only coloured.
- [ ] Keep focus inside the lightbox while it's open, and hand it back to the card that opened it.
- [ ] Rewrite the screenshot `alt` text to describe the image itself rather than name the skill.
- [ ] Check `--text-faint` (`#6d7484`) against the card background. It measures roughly 4:1, under the 4.5:1 that body text needs.

### 🧹 Smaller things

- [ ] Test the breakpoints on a real phone. The layout has only been checked at desktop widths.
- [ ] Fill the last grid row. Eight cards in three columns leaves one slot empty; `grid-column: span 2` on one card would close it, or leave it as is.
- [ ] Give the hero panel a no-JS fallback line, so it isn't blank when the script fails to load.
- [x] Add `site/` to the layout diagram in `CLAUDE.md`.
- [ ] Add a link check across the READMEs and the card links, so a renamed skill fails loudly instead of 404ing quietly.

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="../Skills/Core/README.md">Core skills</a> ·
  <a href="../Docs/USING-SKILLS.md">Using skills</a>
</p>
