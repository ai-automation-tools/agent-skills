<a id="readme-top"></a>

<h1 align="center">🧩 Agent Skills</h1>

<p align="center">
  <em>Portable capabilities for Claude Code and compatible agents —<br>each one a single <code>SKILL.md</code> the agent loads only when it needs it.</em>
</p>

<p align="center">
  <a href="./Docs/USING-SKILLS.md"><strong>Explore the docs »</strong></a>
</p>

<p align="center">
  <a href="https://agent-skills.ai-automation-tools.dev">Showcase site</a> ·
  <a href="#-skill-catalog">Catalog</a> ·
  <a href="#-using-a-skill">Install</a> ·
  <a href="./Docs/USING-SKILLS.md">Authoring guide</a> ·
  <a href="./Docs/ROADMAP.md">Roadmap</a>
</p>

<p align="center">
  <a href="https://agent-skills.ai-automation-tools.dev"><img src="https://img.shields.io/badge/live-agent--skills.ai--automation--tools.dev-F2B34B?style=for-the-badge" alt="Live at agent-skills.ai-automation-tools.dev"></a>
  <img src="https://img.shields.io/badge/skills-7-2ea44f?style=for-the-badge" alt="7 skills">
  <img src="https://img.shields.io/badge/format-SKILL.md-8B5CF6?style=for-the-badge" alt="SKILL.md format">
  <img src="https://img.shields.io/badge/agent-Claude%20Code-D97757?style=for-the-badge" alt="Built for Claude Code">
  <a href="https://github.com/ai-automation-tools"><img src="https://img.shields.io/badge/org-ai--automation--tools-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="ai-automation-tools"></a>
</p>

---

A collection of reusable skills for Claude Code and compatible AI agents. Each skill is a folder with a `SKILL.md` file that tells the agent how to handle a specific task.

<a id="-skill-catalog"></a>

## 🗂️ Browse skills

| Folder | What's inside |
|:---|:---|
| [**🧩 Core**](./Skills/Core/README.md) | Reusable skills that work across repositories and install into your agent's user-level skills directory. |
| [**🗂️ Projects**](./Skills/Projects/README.md) | Additional skills for specific repositories, installed into the project they belong to. |
| [**🖥️ Showcase site**](./site/README.md) | A static page that presents every Core skill as a card, with screenshots and install commands. Published at [agent-skills.ai-automation-tools.dev](https://agent-skills.ai-automation-tools.dev). |

## 📦 Core skills

| Skill | Category | What it does |
|:---|:---|:---|
| [**✉️ html-email-templates**](./Skills/Core/Automation/html-email-templates/SKILL.md) | Automation | Creates HTML emails for notifications, reports, and digests. |
| [**🚦 task-router**](./Skills/Core/Automation/task-router/SKILL.md) | Automation | Chooses a workflow and model tier based on the task. |
| [**📈 business-plan-builder**](./Skills/Core/Business/business-plan-builder/SKILL.md) | Business | Evaluates business ideas and writes a decision memo and build plan. |
| [**🍳 recipe-validator**](./Skills/Core/Cooking/recipe-validator/SKILL.md) | Cooking | Checks recipes for food safety, nutrition, quantities, and allergens. |
| [**🏗️ repo-docs-builder**](./Skills/Core/Documentation/repo-docs-builder/SKILL.md) | Documentation | Organizes repositories and creates linked READMEs, a docs tree, and the roadmap + changelog that go with it. |
| [**🖼️ news-images**](./Skills/Core/Image-Gen/news-images/SKILL.md) | Image-Gen | Generates illustrated news collages and montages. |
| [**🌐 project-hub-scaffold**](./Skills/Core/Web/project-hub-scaffold/SKILL.md) | Web | Builds a local web interface for browsing project documents. |

## 🗂️ Project skills

Each folder lists the project's existing skills and any additional skills provided here.

| Project folder | Additional skills in this repo |
|:---|:---|
| [**💬 agent-chat**](./Skills/Projects/agent-chat/README.md) | `agent-chat-conv-types`, `agent-chat-delivery` and `agent-chat-run-triage`. |
| [**⏱️ cronsole**](./Skills/Projects/cronsole/README.md) | `cronsole-windows-jobs` and `cronsole-claude-routines`. |
| [**📡 edge-radar**](./Skills/Projects/edge-radar/README.md) | `edge-radar-strategy-profiles` and `edge-radar-strategy-evidence`. |
| [**📉 edge-spectrum**](./Skills/Projects/edge-spectrum/README.md) | `edge-spectrum-hub-tool`, `edge-spectrum-dataset` and `edge-spectrum-endpoint`. |
| [**🌐 project-hub**](./Skills/Projects/project-hub/README.md) | `project-hub-scan`, `project-hub-client` and `project-hub-demo`. (`project-hub-scaffold` is listed under Core.) |

<a id="-using-a-skill"></a>

See the [Using Skills guide](./Docs/USING-SKILLS.md) for installation and authoring instructions, or browse [Resources](./Resources/README.md) for examples and supporting material. What's planned next is in the [roadmap](./Docs/ROADMAP.md).
