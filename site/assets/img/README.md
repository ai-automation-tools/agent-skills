<h1 align="center">🖼️ Skill screenshots</h1>

<p align="center">
  <em>One image per Core skill card. Name the file after the skill and the page finds it —<br>
  no markup to edit, no manifest to keep.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/format-png_·_jpg_·_webp-F59E0B?style=for-the-badge" alt="Accepted image formats">
  <img src="https://img.shields.io/badge/per_skill-1_to_4-8B5CF6?style=for-the-badge" alt="One to four images per skill">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-site-6B7280?style=for-the-badge" alt="Site folder"></a>
</p>

---

## 📋 Expected filenames

| Skill | Primary image | Gallery extras |
|:---|:---|:---|
| [**repo-docs-builder**](../../../Skills/Core/Documentation/repo-docs-builder/SKILL.md) | `repo-docs-builder.png` | `-2`, `-3`, `-4` |
| [**business-plan-builder**](../../../Skills/Core/Business/business-plan-builder/SKILL.md) | `business-plan-builder.png` | `-2`, `-3`, `-4` |
| [**recipe-validator**](../../../Skills/Core/Cooking/recipe-validator/SKILL.md) | `recipe-validator.png` | `-2`, `-3`, `-4` |
| [**html-email-templates**](../../../Skills/Core/Automation/html-email-templates/SKILL.md) | `html-email-templates.png` | `-2`, `-3`, `-4` |
| [**task-router**](../../../Skills/Core/Automation/task-router/SKILL.md) | `task-router.png` | `-2`, `-3`, `-4` |
| [**news-images**](../../../Skills/Core/Image-Gen/news-images/SKILL.md) | `news-images.png` | `-2`, `-3`, `-4` |
| [**video-downloader**](../../../Skills/Core/Media/video-downloader/SKILL.md) | `video-downloader.png` | `-2`, `-3`, `-4` |
| [**project-hub-scaffold**](../../../Skills/Core/Web/project-hub-scaffold/SKILL.md) | `project-hub-scaffold.png` | `-2`, `-3`, `-4` |

`-2` means the gallery name, so `task-router-2.png` is the second image on the `task-router` card.

## 🔍 How the page finds them

- **Extensions** are tried in order: `.png`, then `.jpg`, `.webp`, `.jpeg`. PNG is the safe choice.
- **The primary image fills the card** at a 16:10 crop, anchored to the top edge. Gallery extras are only reachable by clicking the card, which opens the lightbox.
- **A missing image is not an error.** The card falls back to a placeholder, so a half-finished set still looks deliberate.
- **Four images is the cap.** The extras are probed when a card is opened, not on page load, which keeps the console free of 404s for screenshots you haven't taken yet.
- **Size:** 1600 × 1000 or larger. Light-on-dark captures read best against the card background.

## 📦 Current state

`repo-docs-builder` ships with four captures copied from
`Resources/Skill-Data/Core/Documentation/repo-docs-builder/Images/Screenshots/`, so the gallery
and lightbox have something real to show. Replace them with your own whenever you like — the
filenames are all that matters.

---

<p align="center">
  <a href="../README.md">← Showcase site</a> ·
  <a href="../../../README.md">Repository home</a> ·
  <a href="../../../Skills/Core/README.md">Core skills</a>
</p>
