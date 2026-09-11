<h1 align="center">🧩 Core skills</h1>

<p align="center">
  <em>Portable capabilities — they assume nothing about the repo you are standing in,<br>
  so they install once at user scope and every session can reach them.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-core-2ea44f?style=for-the-badge" alt="Core tier">
  <img src="https://img.shields.io/badge/skills-8-0078D4?style=for-the-badge" alt="8 skills">
  <img src="https://img.shields.io/badge/scope-user-8B5CF6?style=for-the-badge" alt="User scope">
  <a href="../Projects/README.md"><img src="https://img.shields.io/badge/↔-Project_skills-6B7280?style=for-the-badge" alt="Project skills"></a>
</p>

---

## 🧪 What qualifies

> **Would you invoke this from a repo other than the one it was written for?**

If yes, it belongs here. Core skills name no repo's files, no repo's schema, no repo's commands.
`recipe-validator` takes the recipe folder as a parameter. `task-router` takes the cost policy as
a parameter. That parameterisation is what makes a skill core — not the subject matter.

A skill that fails the test goes to [`Skills/Projects/<repo>/`](../Projects/README.md) and installs
into that repo instead, so it doesn't clutter the catalog of every unrelated session.

## 📦 The catalog

| Category | Skill | What it does |
|:---|:---|:---|
| **Automation** | [`html-email-templates`](./Automation/html-email-templates/SKILL.md) | Three HTML email templates that survive the clients that strip your CSS, plus the subject/label/footer conventions that keep automated mail consistent. |
| **Automation** | [`task-router`](./Automation/task-router/SKILL.md) | Sizes a request before work starts — inline, one subagent, recon-then-plan, or fan out — and picks a model tier to match. |
| **Business** | [`business-plan-builder`](./Business/business-plan-builder/SKILL.md) | Eight-pass business analysis with a decision memo that gates the build half. Every number traces to a source or is tagged an assumption. |
| **Cooking** | [`recipe-validator`](./Cooking/recipe-validator/SKILL.md) | Food safety, nutrition thresholds, quantity sanity and allergen labelling, ranked by severity. |
| **Documentation** | [`repo-docs-builder`](./Documentation/repo-docs-builder/SKILL.md) | Repo layout, a house-style README at every level, a navigable docs tree, and a humanizer pass over the prose. |
| **Image-Gen** | [`news-images`](./Image-Gen/news-images/SKILL.md) | Cartoon-editorial news collages and montages across daily/weekly/monthly/yearly cadences. |
| **Media** | [`video-downloader`](./Media/video-downloader/SKILL.md) | YouTube downloads with quality and format control, hardened for Windows. |
| **Web** | [`project-hub-scaffold`](./Web/project-hub-scaffold/SKILL.md) | Stands up a browsable HTML console over a folder of documents. **Core, not a project skill** — you invoke it from the repo that is *getting* a hub. |

Full prose on each — references, scripts, examples — is in the [repository README](../../README.md#-skills).

## 📥 Installing

```powershell
pwsh scripts/install-skills.ps1 -Core          # all of the above -> ~/.claude/skills
pwsh scripts/install-skills.ps1 -Core -Skill task-router
```

`-Core` is the default when neither `-Core` nor `-Project` is given, so a bare run installs
exactly this tier and never leaks a project skill into user scope.

## 🗃️ Categories

Category folders are for humans reading the tree — they carry no meaning at install time, since
every skill lands flat as `~/.claude/skills/<name>/`. **Skill names must therefore be unique
across the whole repo**, categories included. Add a category when three or more skills would
share it; until then use the closest existing one.

---

<p align="center">
  <a href="../../README.md">← Repo home</a>
  ·
  <a href="../Projects/README.md">Project skills</a>
  ·
  <a href="../../Docs/USING-SKILLS.md">Authoring guide</a>
</p>
