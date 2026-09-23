# Skill harvest ledger

The org's five agent workspaces each grow their own `skills/` folder. Once a week the
**Skill Harvest** job copies the portable ones into `Skills/Core/` here, and this file is
its ledger: one row per workspace skill it has decided on.

> [!IMPORTANT]
> **A `mirrored` skill is a copy. Its source is the workspace repo.** Edit it there. The
> harvest re-syncs the mirror byte for byte when the source changes, and it flags a mirror
> that was edited here instead of overwriting it. The same goes for the roadmap routine:
> leave mirrored skills alone.

- **`mirrored`:** copied into Core at the source SHA shown.
- **`declined`:** judged at that SHA and not promoted, for the reason in the note. It's
  judged again if the source changes.

The job runs Sundays at 08:00 as `\AI-Automation-Tools-Org\Integrate-Projects\Skill Harvest - Org Agents to agent-skills`.
It never pushes to `main`. Each run's changes arrive as one `harvest/auto-<date>` PR.

| skill | source repo | status | Core path | source SHA | date | note |
|:---|:---|:---|:---|:---|:---|:---|
