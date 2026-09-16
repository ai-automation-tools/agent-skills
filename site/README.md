<h1 align="center">🖥️ Showcase site</h1>

<p align="center">
  <em>The Core catalog in a browser — seven skill cards, each with a screenshot,<br>
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
| [**index.html**](./index.html) | The page: hero, the seven Core skill cards, the project list, the install commands. All of the copy lives here, so it renders before JavaScript runs. |
| [**styles.css**](./styles.css) | The dark theme. A card takes its colour from its `data-category`, which means a new category is one accent variable. |
| [**script.js**](./script.js) | The typewriter hero, category filters, copy buttons, and the screenshot lightbox. |
| [**assets/img/**](./assets/img/README.md) | The screenshots, plus the naming rules the page follows. |
| [**assets/diagrams/**](./assets/diagrams/task-router.html) | Sources for any diagram that ships as an image. `task-router.html` is a 1600 × 1000 page that renders to `assets/img/task-router.webp`; edit it and screenshot it again if the tiers change. |

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

One `<article class="card">` block per skill in `index.html`. To add, remove or reorder a skill, edit those blocks and the matching button in the `.filters` row. Colours come from `data-category`, so a new category needs a `--c-<name>` variable in `styles.css` and nothing else.

## 🌐 Publishing

GitHub Pages serves this as-is: point Pages at the repo root and set the source folder to `/site`. Any static host works the same way.

## 🚧 Action items

What's left before this page is finished, in rough order of what matters most.

### 📸 Screenshots

Every card has an image now.

- [ ] Decide whether the four seeded `repo-docs-builder` images stay. They're rendered examples lifted from the skill's own `Resources/` folder, so they show the output a run produces rather than the skill at work.
- [ ] Compress what goes in. Most images are WebP now; the seeded `repo-docs-builder` PNGs still run up to 274 KB.

### 🌐 Hosting

Nothing serves the page yet.

- [ ] Turn on GitHub Pages: source `main`, folder `/site`.
- [ ] Add the resulting URL to the repo's About panel so people can find it.
- [ ] Add an `og:image` (a 1200 × 630 crop of the hero) and a `twitter:card`. A shared link previews as bare text right now.

### 🔁 Copy that drifts

The card text is written into `index.html` and repeats each `SKILL.md`. Nothing keeps the two in step.

- [ ] Re-read the seven taglines and feature lists against the current `SKILL.md` files.
- [ ] Pick a sync story: a manual pass whenever a skill changes, or a small script that generates the card blocks from the frontmatter.
- [ ] Re-check the project list against `Skills/Projects/`, since the repo README is the source of truth and this page copies it.

### ♿ Accessibility

- [ ] Give the filter chips `aria-pressed`, so the selected category is announced instead of only coloured.
- [ ] Keep focus inside the lightbox while it's open, and hand it back to the card that opened it.
- [ ] Rewrite the screenshot `alt` text to describe the image itself rather than name the skill.
- [ ] Check `--text-faint` (`#6d7484`) against the card background. It measures roughly 4:1, under the 4.5:1 that body text needs.

### 🧹 Smaller things

- [ ] Test the breakpoints on a real phone. The layout has only been checked at desktop widths.
- [ ] Fill the last grid row. Eight cards in three columns leaves one slot empty; `grid-column: span 2` on one card would close it, or leave it as is.
- [ ] Give the hero panel a no-JS fallback line, so it isn't blank when the script fails to load.
- [ ] Add `site/` to the layout diagram in `CLAUDE.md`, which still shows the tree without it.
- [ ] Add a link check across the READMEs and the card links, so a renamed skill fails loudly instead of 404ing quietly.

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="../Skills/Core/README.md">Core skills</a> ·
  <a href="../Docs/USING-SKILLS.md">Using skills</a>
</p>
