# Skill harvest ledger

The org's five agent workspaces each grow their own `skills/` folder. Once a week the
**Skill Harvest** job copies the portable ones into `skills/domain/<domain>/` here, and this file is
its ledger: one row per workspace skill it has decided on.

> [!IMPORTANT]
> **A `mirrored` skill is a copy. Its source is the workspace repo.** Edit it there. The
> harvest re-syncs the mirror byte for byte when the source changes, and it flags a mirror
> that was edited here instead of overwriting it. The same goes for the roadmap routine:
> leave mirrored skills alone.

- **`mirrored`:** copied into `skills/domain/` at the source SHA shown.
- **`declined`:** judged at that SHA and not promoted, for the reason in the note. It's
  judged again if the source changes.

The job runs Sundays at 08:00 as `\AI-Automation-Tools-Org\Integrate-Projects\Skill Harvest - Org Agents to agent-skills`.
It never pushes to `main`. Each run's changes arrive as one `harvest/auto-<date>` PR.

| skill | source repo | status | path | source SHA | date | note |
|:---|:---|:---|:---|:---|:---|:---|
| api-client-resilience | api-agent | mirrored | `skills/domain/api/api-client-resilience` | `3e60863` | 2026-09-22 | first harvest promotion, new Domain |
| api-integration-testing | api-agent | mirrored | `skills/domain/api/api-integration-testing` | `3e60863` | 2026-09-22 | first harvest promotion, new Domain |
| api-response-normalization | api-agent | mirrored | `skills/domain/api/api-response-normalization` | `3e60863` | 2026-10-04 | passes tier test — no workspace layout assumed |
| public-api-evaluation | api-agent | mirrored | `skills/domain/api/public-api-evaluation` | `3e60863` | 2026-09-22 | first harvest promotion, new Domain |
| rate-limit-and-quota-management | api-agent | mirrored | `skills/domain/api/rate-limit-and-quota-management` | `3e60863` | 2026-09-27 | passes tier test — no workspace layout assumed |
| customer-discovery | business-agent | mirrored | `skills/domain/business/customer-discovery` | `d0a3ca3` | 2026-09-27 | first harvest promotion, new Domain |
| go-to-market | business-agent | mirrored | `skills/domain/business/go-to-market` | `d0a3ca3` | 2026-09-28 | passes tier test — no workspace layout assumed |
| pricing-strategy | business-agent | mirrored | `skills/domain/business/pricing-strategy` | `d0a3ca3` | 2026-09-28 | passes tier test — no workspace layout assumed |
| debugging-methodology | fullstack-agent | mirrored | `skills/domain/engineering/debugging-methodology` | `6f8bc8d` | 2026-09-22 | moved from Core 2026-09-22 |
| performance-optimization | fullstack-agent | mirrored | `skills/domain/engineering/performance-optimization` | `6f8bc8d` | 2026-09-22 | moved from Core 2026-09-22 |
| testing-strategy | fullstack-agent | mirrored | `skills/domain/engineering/testing-strategy` | `6f8bc8d` | 2026-09-22 | moved from Core 2026-09-22 |
| captions-and-accessibility | media-studio | mirrored | `skills/domain/media/captions-and-accessibility` | `5698b35` | 2026-09-27 | first harvest promotion, new Domain |
| media-rights-and-licensing | media-studio | mirrored | `skills/domain/media/media-rights-and-licensing` | `5698b35` | 2026-10-04 | passes tier test — no workspace layout assumed |
| post-publish-analytics | media-studio | mirrored | `skills/domain/media/post-publish-analytics` | `5698b35` | 2026-10-11 | passes tier test — no workspace layout assumed |
| security-metrics-and-posture | security-agent | mirrored | `skills/domain/security/security-metrics-and-posture` | `df83520` | 2026-10-11 | passes tier test — no workspace layout assumed |
| security-report-writing | security-agent | mirrored | `skills/domain/security/security-report-writing` | `df83520` | 2026-09-28 | passes tier test, new Domain |
| vulnerability-disclosure | security-agent | mirrored | `skills/domain/security/vulnerability-disclosure` | `df83520` | 2026-10-04 | passes tier test — no workspace layout assumed |
