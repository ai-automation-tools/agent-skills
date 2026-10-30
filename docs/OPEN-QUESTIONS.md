# Open questions

## Open

### Turn on GitHub private vulnerability reporting for agent-skills?
- Asked: 2026-10-29 by agent-skills-roadmap
- Context: `SECURITY.md` landed and points reporters at admin@ai-automation-tools.dev, because private vulnerability reporting is off on this repo (`gh api repos/ai-automation-tools/agent-skills/private-vulnerability-reporting` returns `enabled: false`). `project-hub`, `agent-chat` and `cronsole` use the Security tab flow instead. The roadmap routine may only change the homepage setting, so this is yours. Recommendation: turn it on (`gh api -X PUT repos/ai-automation-tools/agent-skills/private-vulnerability-reporting`), and the next run will switch `SECURITY.md` to link the Security tab, keeping the email as the fallback.
- Answer:

## Answered
