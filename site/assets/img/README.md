<h1 align="center">🖼️ Skill screenshots</h1>

<p align="center">
  <em>One image per Core skill card. Name the file after the skill, run the generator,<br>
  and the card shows it. No markup to edit, no manifest to keep.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/format-png_·_jpg_·_webp-F59E0B?style=for-the-badge" alt="Accepted image formats">
  <img src="https://img.shields.io/badge/per_skill-1_to_4-8B5CF6?style=for-the-badge" alt="One to four images per skill">
  <a href="../../README.md"><img src="https://img.shields.io/badge/↩-site-6B7280?style=for-the-badge" alt="Site folder"></a>
</p>

---

## 📋 Expected filenames

| Skill | Primary image | Gallery extras |
|:---|:---|:---|
| [**repo-docs-builder**](../../../skills/core/documentation/repo-docs-builder/SKILL.md) | `repo-docs-builder.png` | `-2`, `-3`, `-4` |
| [**business-plan-builder**](../../../skills/core/business/business-plan-builder/SKILL.md) | `business-plan-builder.png` | `-2`, `-3`, `-4` |
| [**recipe-validator**](../../../skills/core/cooking/recipe-validator/SKILL.md) | `recipe-validator.png` | `-2`, `-3`, `-4` |
| [**html-email-templates**](../../../skills/core/automation/html-email-templates/SKILL.md) | `html-email-templates.png` | `-2`, `-3`, `-4` |
| [**task-router**](../../../skills/core/automation/task-router/SKILL.md) | `task-router.png` | `-2`, `-3`, `-4` |
| [**news-images**](../../../skills/core/image-gen/news-images/SKILL.md) | `news-images.png` | `-2`, `-3`, `-4` |
| [**project-hub-scaffold**](../../../skills/core/web/project-hub-scaffold/SKILL.md) | `project-hub-scaffold.png` | `-2`, `-3`, `-4` |
| [**automated-dev-pipeline**](../../../skills/core/automation/automated-dev-pipeline/SKILL.md) | `automated-dev-pipeline.png` | `-2`, `-3`, `-4` |

`-2` means the gallery name, so `task-router-2.png` is the second image on the `task-router` card.

## 🔍 How the page finds them

- **`scripts/build-showcase.py` finds them**, not the browser. It looks for `.png`, then `.jpg`, `.webp`, `.jpeg`, and writes the paths it finds into the card. Re-run it after adding or renaming an image; CI's `--check` fails until you do.
- **The primary image fills the card** at a 16:10 crop, anchored to the top edge. Gallery extras are only reachable by clicking the card, which opens the lightbox.
- **A missing image is not an error.** The card falls back to a placeholder, so a half-finished set still looks deliberate.
- **Four images is the cap.** The extras are listed in the card's `data-shots` and only loaded when the lightbox opens. Nothing is guessed at, so the console stays free of 404s.
- **Size:** 1600 × 1000 or larger. Light-on-dark captures read best against the card background.

## 📦 Current state

Every card has an image:

- **`repo-docs-builder`** ships with four captures copied from
  `resources/skill-data/core/documentation/repo-docs-builder/images/screenshots/`, so the gallery
  and lightbox have something real to show.
- **`project-hub-scaffold`** has two: the workspace dashboard and the markdown viewer.
- **`business-plan-builder`** has three: the expanded output tree for one idea, plus the collapsed
  top level for two others.
- **`news-images`** has three, converted from PNG to WebP at quality 85 to keep them out of the
  multi-megabyte range. The card leads with a landscape **montage** (1536 × 1024) because a
  portrait collage would be cropped to a sliver by the 16:10 card frame; the two portrait
  **collages** (1024 × 1536) live in the lightbox, where the full panel grid is visible.
- **`recipe-validator`** has two, also WebP, at quality 92 since the screenshots are mostly text.
- **`html-email-templates`** has two: a security advisory digest and a job completion notice.
- **`task-router`** has one, and it isn't a screenshot. `../diagrams/task-router.html` draws the
  four routing tiers in the site's own palette and renders to exactly 1600 × 1000, so the card
  frame crops nothing.
- **`automated-dev-pipeline`** has one, drawn the same way: `../diagrams/automated-dev-pipeline.html`
  shows the build flow (ideas → ideate → incubate → roadmap routine → PR sweep) over the skill's
  three jobs, rendered at 1600 × 1000 and saved as WebP at quality 86. The skill's own
  `pipeline-flow.svg` is a swimlane export that isn't 16:10 and doesn't use the site palette.

The `business-plan-builder` sources are small enough (4–23 KB) that they stayed PNG.

Replace any of them whenever you like. The filenames are all that matters.

---

<p align="center">
  <a href="../../README.md">← Showcase site</a> ·
  <a href="../../../README.md">Repository home</a> ·
  <a href="../../../skills/core/README.md">Core skills</a>
</p>
