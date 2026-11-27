<a id="readme-top"></a>

<h1 align="center">🧩 Agent Skills</h1>

<p align="center">
  <em>Portable capabilities for Claude Code and compatible agents —<br>each one a single <code>SKILL.md</code> the agent loads only when it needs it.</em>
</p>

<p align="center">
  <a href="./docs/README.md"><strong>Explore the docs »</strong></a>
</p>

<p align="center">
  <a href="https://agent-skills.ai-automation-tools.dev">Showcase site</a> ·
  <a href="#-skill-catalog">Catalog</a> ·
  <a href="#-using-a-skill">Install</a> ·
  <a href="./docs/USING-SKILLS.md">Authoring guide</a> ·
  <a href="./docs/ROADMAP.md">Roadmap</a> ·
  <a href="./docs/CHANGELOG.md">Changelog</a>
</p>

<p align="center">
  <a href="https://agent-skills.ai-automation-tools.dev"><img src="https://img.shields.io/badge/live-agent--skills.ai--automation--tools.dev-F2B34B?style=for-the-badge" alt="Live at agent-skills.ai-automation-tools.dev"></a>
  <img src="https://img.shields.io/badge/skills-14-2ea44f?style=for-the-badge" alt="14 skills">
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
| [**🧩 Core**](./skills/core/README.md) | Reusable skills that work across repositories and install into your agent's user-level skills directory. |
| [**🧭 Domain**](./skills/domain/README.md) | Field-specific skills (security, business, media, API, science, religion) mirrored from the org's agent workspaces. Portable, installed on request. |
| [**📇 Org catalog**](./docs/CATALOG.md) | Every skill in every public org repo, not only this one, with where it lives and which copies have drifted. Generated weekly. |
| [**🖥️ Showcase site**](./site/README.md) | A static page that presents every Core skill as a card, with screenshots and install commands. Published at [agent-skills.ai-automation-tools.dev](https://agent-skills.ai-automation-tools.dev). |

## 📦 Core skills

| Skill | Category | What it does |
|:---|:---|:---|
| [**✉️ html-email-templates**](./resources/skill-data/core/automation/html-email-templates/README.md) | Automation | Creates HTML emails for notifications, reports, and digests. |
| [**🏭 automated-dev-pipeline**](./resources/skill-data/core/automation/automated-dev-pipeline/README.md) | Automation | Sets up scheduled AI agents that build projects through PRs, publish them to a GitHub account or organization behind scripted gates and a human approval, and keep every repo current. Also covers pipelines whose stages are folders in one repo that deploys a site. |
| [**🧠 agent-workspace-builder**](./resources/skill-data/core/automation/agent-workspace-builder/README.md) | Automation | Creates or standardizes a specialized agent workspace repo (AGENTS.md doctrine, docs tree, capability reference, curated resources, portable skills) and sets up its weekly roadmap and upkeep automations. |
| [**🚦 task-router**](./resources/skill-data/core/automation/task-router/README.md) | Automation | Chooses a workflow and model tier based on the task. |
| [**📈 business-plan-builder**](./resources/skill-data/core/business/business-plan-builder/README.md) | Business | Evaluates business ideas and writes a decision memo and build plan. |
| [**🍳 recipe-validator**](./resources/skill-data/core/cooking/recipe-validator/README.md) | Cooking | Checks recipes for food safety, nutrition, quantities, and allergens. |
| [**🏗️ repo-docs-builder**](./resources/skill-data/core/documentation/repo-docs-builder/README.md) | Documentation | Organizes repositories and creates linked READMEs, a docs tree, and the roadmap + changelog that go with it. |
| [**🐞 debugging-methodology**](./skills/core/engineering/debugging-methodology/SKILL.md) | Engineering | Finds the root cause of a bug by reproducing it and testing one hypothesis at a time. |
| [**🧱 full-stack-feature**](./skills/core/engineering/full-stack-feature/SKILL.md) | Engineering | Delivers a feature across database, API and UI as one verified slice. |
| [**⚡ performance-optimization**](./skills/core/engineering/performance-optimization/SKILL.md) | Engineering | Profiles first, then fixes the biggest bottleneck. |
| [**🧪 testing-strategy**](./skills/core/engineering/testing-strategy/SKILL.md) | Engineering | Decides what to test and at which level. |
| [**🖼️ news-images**](./resources/skill-data/core/image-gen/news-images/README.md) | Image-Gen | Generates illustrated news collages and montages. |
| [**🌐 project-hub-scaffold**](./resources/skill-data/core/web/project-hub-scaffold/README.md) | Web | Builds a local web interface for browsing project documents. |
| [**🎨 web-house-style**](./resources/skill-data/core/web/web-house-style/README.md) | Web | Gives a page the org sites' shared look: dark-first tokens, a Light / Dark switch top right, the source bar, a top bar or icon sidebar, and the phone pass. |

## 🧭 Domain skills

Field-specific skills from the org's agent workspaces (six since `fullstack-agent` was archived on 2026-11-16), copied here unchanged by a weekly
harvest. They're kept apart from Core so Core stays a short list, and they install only
when you ask: `install-skills.ps1 -Domain`. Edit them in their workspace repo; the
[harvest ledger](./docs/HARVEST.md) says which one.

| Domain folder | What's inside |
|:---|:---|
| [**🌐 API**](./skills/domain/api/) | Working with third-party APIs: judging one before you integrate, writing clients that survive failures, staying inside rate limits and quotas, normalizing responses into one traceable shape, and testing integrations without hitting live services. From `api-agent`. |
| [**📈 Business**](./skills/domain/business/) | Field tactics for business decisions: running customer discovery interviews, planning go-to-market, and setting prices. From `business-agent`. |
| [**🔐 Security**](./skills/domain/security/) | Communicating and steering security work: turning verified findings into a report a client acts on, disclosing a vulnerability responsibly, and measuring a security program with metrics, SLAs and a risk register. From `security-agent`. |
| [**🎬 Media**](./skills/domain/media/) | Getting a media asset ready to publish and learning from it afterward: captions, alt text, accessibility checks, rights clearance, and reading post-publish analytics. From `media-agent`. |
| [**🔬 Science**](./skills/domain/science/) | Doing and judging research: appraising a paper's design, bias and statistics, managing research data so it stays findable and reusable, and making figures that show the data honestly. From `science-agent`. |
| [**📜 Religion**](./skills/domain/religion/) | Studying and writing about religion: analyzing myths and motifs across cultures, stating religious dates and calendars correctly, and writing fairly about faiths for a general audience. From `religion-agent`. |

## 🗂️ Skills in other repos

A skill for working on one org repo lives in that repo, so it loads only there and has one copy to
edit. Until 2026-11-27 this repo kept copies for roundtable, cronsole, edge-radar, edge-spectrum and
project-hub; each repo owns them now. The [org catalog](./docs/CATALOG.md) lists every skill in every
public org repo, with where it lives and whether any copy has drifted.

<a id="-using-a-skill"></a>

See the [Using Skills guide](./docs/USING-SKILLS.md) for installation and authoring instructions, or browse [Resources](./resources/README.md) for examples and supporting material. What's planned next is in the [roadmap](./docs/ROADMAP.md), and what has already changed is in the [changelog](./docs/CHANGELOG.md).

## 📄 License

[Apache-2.0](./LICENSE). Where a skill draws on an outside source, the skill credits it.

---

<p align="center">
  <a href="./docs/USING-SKILLS.md">Using Skills</a> · <a href="./docs/README.md">Docs</a> · <a href="./LICENSE">License</a>
</p>
