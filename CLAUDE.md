@AGENTS.md

# CLAUDE.md — Agent Skills (Claude-only notes)

Everything about this repo lives in `AGENTS.md` (imported above): the tiers, the layout, the standing
instructions, validation and the PR flow. Edit the rules there, not here. This file holds only what is
specific to Claude Code.

- **Skills surface as `/skill-name`.** Use that to live-test a skill (`/<skill-name>` on a real task),
  then phrase a request that should match its `description` and check that Claude loads it unprompted.
- **`/skill-writer`** is available in this environment and is the canonical authoring guide for
  structure and frontmatter questions.
- **User scope is `~/.claude/skills`.** `install-skills.ps1 -Core` writes there; never edit an installed
  copy, because the next install wipes it. Edit the skill here and reinstall.
