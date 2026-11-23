# Open questions

## Open

_None._

## Answered

### Does Kimi CLI still read ~/.agents/skills when ~/.config/agents/skills exists?
- Asked: 2026-11-17 by agent-skills-upstream
- Context: Kimi's docs (moonshotai.github.io/kimi-cli/en/customization/skills.html) say it uses only the first existing directory of `~/.config/agents/skills` then `~/.agents/skills`, so `-AllAgents` installs to `~/.agents/skills` are ignored if the former exists. It also reads `~/.claude/skills`, so Core still reaches it. Separately, OpenAI's Codex docs (learn.chatgpt.com/docs/build-skills) no longer mention `~/.codex/skills`. No change made to the installer or `docs/USING-SKILLS.md`; recommend adding a one-line Kimi caveat if you use that folder.
- Answer: No (verified 2026-11-22, audit AS-29; a fact, not a preference). Kimi's docs split user folders into a brand group (`~/.kimi/skills`, `~/.claude/skills`, `~/.codex/skills`, all merged by default) and a generic group (`~/.config/agents/skills`, then `~/.agents/skills`, first existing only). On the owner's machine `~/.config/agents/skills` doesn't exist, so the `-AllAgents` copy still reaches Kimi, and `~/.claude/skills` reaches it either way. The caveat is now in `docs/USING-SKILLS.md`. The Codex point needs no change: the table already calls `~/.codex/skills` legacy.

### Turn on GitHub private vulnerability reporting for agent-skills?
- Asked: 2026-10-29 by agent-skills-roadmap
- Context: `SECURITY.md` landed and points reporters at admin@ai-automation-tools.dev, because private vulnerability reporting is off on this repo (`gh api repos/ai-automation-tools/agent-skills/private-vulnerability-reporting` returns `enabled: false`). `project-hub`, `roundtable` and `cronsole` use the Security tab flow instead. The roadmap routine may only change the homepage setting, so this is yours. Recommendation: turn it on (`gh api -X PUT repos/ai-automation-tools/agent-skills/private-vulnerability-reporting`), and the next run will switch `SECURITY.md` to link the Security tab, keeping the email as the fallback.
- Answer: No, keep it off (owner, 2026-11-11). `SECURITY.md` stays as written, with the email as the reporting route.
