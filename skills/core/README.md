<h1 align="center">🧩 Core skills</h1>

<p align="center">
  <em>Portable capabilities — they assume nothing about the repo you are standing in,<br>
  so they install once at user scope and every session can reach them.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-core-2ea44f?style=for-the-badge" alt="Core tier">
  <img src="https://img.shields.io/badge/skills-10-0078D4?style=for-the-badge" alt="10 skills">
  <img src="https://img.shields.io/badge/scope-user-8B5CF6?style=for-the-badge" alt="User scope">
  <a href="../projects/README.md"><img src="https://img.shields.io/badge/↔-Project_skills-6B7280?style=for-the-badge" alt="Project skills"></a>
</p>

---

## 🧪 What qualifies

> **Would you invoke this from a repo other than the one it was written for?**

If yes, it belongs here. Core skills name no repo's files, no repo's schema, no repo's commands.
`recipe-validator` takes the recipe folder as a parameter. `task-router` takes the cost policy as
a parameter. That parameterisation is what makes a skill core — not the subject matter.

A skill that fails the test goes to [`skills/projects/<repo>/`](../projects/README.md) and installs
into that repo instead, so it doesn't clutter the catalog of every unrelated session.

Portable **field** skills (debugging, pricing, vulnerability disclosure and the like) go to
[`skills/domain/`](../domain/README.md) instead. They're mirrored from the org's agent
workspaces and installed only on request, so this catalog stays short.

## 📦 The catalog

| Category | Skill | What it does |
|:---|:---|:---|
| **Automation** | [`html-email-templates`](../../resources/skill-data/core/automation/html-email-templates/README.md) | Three HTML email templates that survive the clients that strip your CSS, plus the subject/label/footer conventions that keep automated mail consistent. |
| **Automation** | [`automated-dev-pipeline`](../../resources/skill-data/core/automation/automated-dev-pipeline/README.md) | Scheduled AI agents that do development work unattended. Ideas become scored plans, plans become private repos built one roadmap item per PR, and a finished project goes public on a GitHub account or organization only after scripted gates and a human approval. Refresh and upkeep jobs then keep every repo current with its dependencies, platforms and standards. Also covers the single-repo variant, where stages are folders and a site-deploying merge is the publish step held for a person, and audits such a fleet for cost, overlap and safety. |
| **Automation** | [`agent-workspace-builder`](../../resources/skill-data/core/automation/agent-workspace-builder/README.md) | Creates, adopts or audits an agent workspace: a repo that gives an agent one field's skills, reviewer agents, commands, rules and docs. Lays down the standard (AGENTS.md canonical, CLAUDE.md importing it, only README, ROADMAP and CHANGELOG at the docs root, a generated capability reference, a verified RESOURCES.md) with four stdlib checks for CI, and sets up the two weekly jobs that keep it alive: a roadmap build and an upkeep pass over intel, skills, `.claude/` and resources. |
| **Automation** | [`task-router`](../../resources/skill-data/core/automation/task-router/README.md) | Sizes a request before work starts — inline, one subagent, recon-then-plan, or fan out — and picks a model tier to match. |
| **Business** | [`business-plan-builder`](../../resources/skill-data/core/business/business-plan-builder/README.md) | Eight-pass business analysis with a decision memo that gates the build half. Every number traces to a source or is tagged an assumption. |
| **Cooking** | [`recipe-validator`](../../resources/skill-data/core/cooking/recipe-validator/README.md) | Food safety, nutrition thresholds, quantity sanity and allergen labelling, ranked by severity. |
| **Documentation** | [`repo-docs-builder`](../../resources/skill-data/core/documentation/repo-docs-builder/README.md) | Repo layout, a house-style README at every level, a navigable docs tree, and a humanizer pass over the prose. |
| **Image-Gen** | [`news-images`](../../resources/skill-data/core/image-gen/news-images/README.md) | Cartoon-editorial news collages and montages across daily/weekly/monthly/yearly cadences. |
| **Web** | [`project-hub-scaffold`](../../resources/skill-data/core/web/project-hub-scaffold/README.md) | Stands up a browsable HTML console over a folder of documents. **Core, not a project skill** — you invoke it from the repo that is *getting* a hub. |
| **Web** | [`web-house-style`](../../resources/skill-data/core/web/web-house-style/README.md) | The shared look, feel and navigation of the org's sites: dark-first tokens with a light theme, the Light / Dark switch in the top-right corner, the source bar, a sticky top bar or a collapsible icon sidebar, and the phone pass. Two starter pages implement all of it. |

Each skill name opens its overview page, with any diagram, screenshots and examples, which links on to the skill's `SKILL.md`, references and scripts. The overviews live under [Resources](../../resources/README.md).

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
  <a href="../projects/README.md">Project skills</a>
  ·
  <a href="../../docs/USING-SKILLS.md">Authoring guide</a>
</p>
