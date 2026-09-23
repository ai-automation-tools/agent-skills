<h1 align="center">🧭 Domain skills</h1>

<p align="center">
  <em>Field-specific skills from the org's five agent workspaces: engineering, security,<br>
  business, media and API work. They're portable, but you install them on purpose.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-domain-F59E0B?style=for-the-badge" alt="Domain tier">
  <img src="https://img.shields.io/badge/skills-3-0078D4?style=for-the-badge" alt="3 skills">
  <img src="https://img.shields.io/badge/scope-user,_opt--in-8B5CF6?style=for-the-badge" alt="User scope, opt-in">
  <a href="../Core/README.md"><img src="https://img.shields.io/badge/↔-Core_skills-2ea44f?style=for-the-badge" alt="Core skills"></a>
  <a href="../../README.md"><img src="https://img.shields.io/badge/↩-repository_root-6B7280?style=for-the-badge" alt="Repository root"></a>
</p>

---

## 🧪 How this tier differs

Like Core skills, these assume nothing about the repo you're in. The difference is
where they come from and how they install:

| | `Skills/Core/` | `Skills/Domain/` |
|:---|:---|:---|
| **Holds** | A small, hand-picked set of general tools | Field knowledge: how to debug, test, price, disclose a vulnerability, caption a video |
| **Written** | Here | In one of the org's [agent workspaces](https://github.com/ai-automation-tools), then mirrored here |
| **Install** | A bare `install-skills.ps1` run | Opt in with `install-skills.ps1 -Domain` |

## 🔁 These are mirrors

Every skill here is a **byte-for-byte copy** of a skill in one of the five agent workspaces:
`api-agent`, `business-agent`, `security-agent`, `fullstack-agent` and `media-studio`.
A weekly Skill Harvest job copies the ones that pass its checks and re-syncs them when the
source changes. [`Docs/HARVEST.md`](../../Docs/HARVEST.md) lists every one with its source.

> [!IMPORTANT]
> **Edit a domain skill in its workspace repo, not here.** The next harvest brings the change
> across. An edit made here gets flagged, not merged back.

## 📦 The catalog

| Domain | Skill | Source | What it does |
|:---|:---|:---|:---|
| **Engineering** | [`debugging-methodology`](./Engineering/debugging-methodology/SKILL.md) | fullstack-agent | Reproduce reliably, test one hypothesis at a time, bisect to localize, fix the root cause instead of the symptom. |
| **Engineering** | [`performance-optimization`](./Engineering/performance-optimization/SKILL.md) | fullstack-agent | Measure and profile before changing anything, then fix the biggest bottleneck first. |
| **Engineering** | [`testing-strategy`](./Engineering/testing-strategy/SKILL.md) | fullstack-agent | Decide what to test and at which level, test behavior rather than implementation, and know where coverage numbers mislead. |

Domains so far: `Engineering`. The harvest adds `Security`, `Business`, `Media` or `API` the
first time it mirrors a skill from that field.
