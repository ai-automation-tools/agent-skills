# email-template-mfs — Skill-Data

## What the skill does

[`email-template-mfs`](../../../../Skills/Automation/email-template-mfs/SKILL.md) houses the email templates used across Mike's AI Lab automations, so an agent building or sending an automation email picks the right shape instead of improvising one:

| Template | Used for | Delivery |
|:---|:---|:---|
| **A — Notification** | Short alerts/status updates; also the shared footer appended to *every* fleet email regardless of body template | Inline HTML, the email body itself |
| **B — Report** | Generated analysis/report documents (Portfolio Pilot) | Standalone `.html` file, attached or linked — never pasted into the body (its CSS variables and `backdrop-filter` don't survive Gmail/Outlook) |
| **C — Inline digest** | Markdown briefings from n8n newsletter workflows (IAM & Security, Cybersecurity Vulnerability Watch, Energy Industry, World Geopolitics) | Rendered to light-card HTML and inlined directly as the body — safe because it's inline-styles-only |

All three came from reading the actual senders, not guessing at a house style: Template A/footer from `AI-Automation-Library/script/categories/shared/agentmail/_email_footer.py` + `send_agentmail_notification.py`; Template B from Portfolio Pilot's live `Weekly-*/Portfolio_Analysis.html` output; Template C from the shared `Format Outputs` code node in `Tools/n8n/workflows/Newsletters/*/*.json`.

## About this folder

Reference exemplars for the skill — real output pulled from a live send, kept to verify the skill's claims and to show what "correct" looks like. These are not files the skill reads at runtime.

## Contents

| Path | What it is |
|:---|:---|
| [`Examples/template-c-iam-briefing-verified.html`](./Examples/template-c-iam-briefing-verified.html) | The actual HTML body of the "IAM & Security Briefing" email (`fleet@send.mikesailab.com`, sent 2026-08-31), pulled via the Gmail MCP. Ground truth for Template C — confirms the footer markup, and is where the two `mdToHtml` bugs documented in the skill (per-story bullets not listifying, `---` rendering as literal text) were found. |
| [`Examples/verification-notes.md`](./Examples/verification-notes.md) | What was compared, what matched the skill's original assumptions, and what didn't — written when Template C was added, so the next verification pass has a starting diff instead of starting cold. |

## Notes

- The skill was first written directly into the local, gitignored `.claude/skills/` install mirror and never made it into `Skills/` — this Skill-Data folder, the `Skills/Automation/email-template-mfs/` leaf, and the `README.md` catalog entry were all added together on 2026-09-03 to fix that.
- Template C's bugs are documented in the skill for awareness; fixing the actual n8n node (`Tools/n8n/workflows/Newsletters/*/*.json`) is tracked separately, not part of this skill.

---

<p align="center">
  <a href="../../../README.md">← Resources home</a> ·
  <a href="../../../../Skills/Automation/email-template-mfs/SKILL.md">The skill →</a>
</p>
