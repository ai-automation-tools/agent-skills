<h1 align="center">🖥️ Showcase site</h1>

<p align="center">
  <em>The Core catalog in a browser — eight skill cards, each with a screenshot,<br>
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
| [**index.html**](./index.html) | The page: hero, the eight Core skill cards, the project list, the install commands. All of the copy lives here, so it renders before JavaScript runs. |
| [**styles.css**](./styles.css) | The dark theme. A card takes its colour from its `data-category`, which means a new category is one accent variable. |
| [**script.js**](./script.js) | The typewriter hero, category filters, copy buttons, and the screenshot lightbox. |
| [**assets/img/**](./assets/img/README.md) | The screenshots, plus the naming rules the page follows. |

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

---

<p align="center">
  <a href="../README.md">← Repository home</a> ·
  <a href="../Skills/Core/README.md">Core skills</a> ·
  <a href="../Docs/USING-SKILLS.md">Using skills</a>
</p>
