<h1 align="center">🧭 Domain skills</h1>

<p align="center">
  <em>Field-specific skills from the org's five agent workspaces: engineering, security,<br>
  business, media and API work. They're portable, but you install them on purpose.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-domain-F59E0B?style=for-the-badge" alt="Domain tier">
  <img src="https://img.shields.io/badge/skills-15-0078D4?style=for-the-badge" alt="15 skills">
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
| **API** | [`api-response-normalization`](./API/api-response-normalization/SKILL.md) | api-agent | Turn mixed API payloads into one envelope that carries its own provenance — source, request, timestamp, warnings, pointer to the raw response. |
| **API** | [`api-client-resilience`](./API/api-client-resilience/SKILL.md) | api-agent | Write HTTP clients that fail predictably — timeouts, retries with jitter, circuit breaking, idempotency, terminating pagination. |
| **API** | [`api-integration-testing`](./API/api-integration-testing/SKILL.md) | api-agent | Test API integrations without hammering live services — recorded fixtures, contract tests, an opt-in live smoke suite. |
| **API** | [`public-api-evaluation`](./API/public-api-evaluation/SKILL.md) | api-agent | Vet a third-party API before integrating — auth, rate limits, licensing, freshness, stability. |
| **API** | [`rate-limit-and-quota-management`](./API/rate-limit-and-quota-management/SKILL.md) | api-agent | Stay inside a third-party API's rate limits and quotas on purpose — token-bucket throttling, quota budgeting, 429/Retry-After handling, detecting silent throttling. |
| **Business** | [`customer-discovery`](./Business/customer-discovery/SKILL.md) | business-agent | Run customer interviews that produce evidence instead of encouragement — past-behavior questions, disconfirming samples, findings graded by weight. |
| **Business** | [`go-to-market`](./Business/go-to-market/SKILL.md) | business-agent | Plan how a product reaches buyers — beachhead segment, positioning against the real alternative, channel-to-price fit, CAC and payback math, gated launch. |
| **Business** | [`pricing-strategy`](./Business/pricing-strategy/SKILL.md) | business-agent | Set or change a price with an argument behind it — value metric, tiers, willingness to pay from evidence, modeling a change, raising prices on existing customers. |
| **Security** | [`vulnerability-disclosure`](./Security/vulnerability-disclosure/SKILL.md) | security-agent | Run coordinated disclosure — report a flaw to its owner, negotiate a timeline and embargo, request a CVE, or stand up an inbound disclosure process. |
| **Security** | [`security-report-writing`](./Security/security-report-writing/SKILL.md) | security-agent | Turn verified findings into a client-ready report — one-page executive summary, impact-and-fix findings, honest severity, redaction. |
| **Media** | [`captions-and-accessibility`](./Media/captions-and-accessibility/SKILL.md) | media-studio | Make media usable by everyone and verify it — accurate captions, alt text, contrast, safe-area, audio description. |
| **Media** | [`media-rights-and-licensing`](./Media/media-rights-and-licensing/SKILL.md) | media-studio | Establish that every music, footage, font, AI-generated, or likeness element is cleared, and record it, before publishing. |

Domains so far: `Engineering`, `API`, `Business`, `Security`, `Media`.
