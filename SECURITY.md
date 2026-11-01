# Security policy

## Reporting a vulnerability

Please don't open a public issue for a security problem. Email
**admin@ai-automation-tools.dev** with what you found, how to reproduce it, and the commit you
tested. That's the address the [organization's default policy](https://github.com/ai-automation-tools/.github/blob/main/SECURITY.md)
names for repos without GitHub's private vulnerability reporting, and this repo doesn't have it
switched on yet.

You'll get an acknowledgement within about a week. This library is maintained by one person,
so fixes are best effort, prioritized by severity. Credit goes in the changelog unless you'd
rather stay anonymous.

## Supported versions

Agent Skills has no releases. Only the latest commit on `main` gets fixes, and an installed
skill is fixed by reinstalling it.

## What's in scope

A skill is instructions an agent follows with your tools and your permissions, so a harmful
instruction counts as a vulnerability here even when no code runs. Reports that matter most:

- a `SKILL.md`, reference or prompt template that steers an agent into a destructive or
  outward-facing action (deleting files, pushing, posting, sending, spending) the skill's
  stated purpose doesn't need, or that tells it to skip a confirmation
- a script shipped inside a skill (`skills/**/scripts/`) that writes, deletes or sends
  anything outside the paths its skill names, or runs input it reads as code
- `scripts/install-skills.ps1` writing outside the destination it was given, or overwriting
  a skill without the collision check stopping it
- a committed secret, token or private machine path
- the showcase at [agent-skills.ai-automation-tools.dev](https://agent-skills.ai-automation-tools.dev)
  loading or running script it shouldn't

Skills under `skills/domain/` are mirrored byte for byte from the org's agent workspaces
([`docs/HARVEST.md`](./docs/HARVEST.md) lists each one's source). Report them here all the
same; the fix lands in the source workspace and the next harvest carries it over.

Out of scope: what an agent does once you've told it to ignore a skill, and problems in the
agent CLIs themselves, which go to their vendors.

## Secrets

Nothing in this repo needs a secret, and `.env*` and `*.key` are gitignored. GitHub secret
scanning and push protection are on for the repo. A full-history [gitleaks](https://github.com/gitleaks/gitleaks)
scan on 2026-10-29 (every commit on every branch) found nothing. To repeat it from a clone:

```
gitleaks git . --redact --log-opts="--all"
```

If a secret is ever committed, rotate it first, then remove it; rewriting history comes last.
