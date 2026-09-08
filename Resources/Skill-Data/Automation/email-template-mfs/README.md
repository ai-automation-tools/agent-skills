# email-template-mfs — Skill-Data

## What the skill does

[`email-template-mfs`](../../../../Skills/Automation/email-template-mfs/SKILL.md) houses three reusable HTML email templates, so an agent building or sending an automation email picks the right shape instead of improvising one:

| Template | Used for | Delivery |
|:---|:---|:---|
| **A — Notification** | Short alerts/status updates; also a shared footer that can be appended to any body template | Inline HTML, the email body itself |
| **B — Report** | Generated analysis/report documents | Standalone `.html` file, attached or linked — never pasted into the body (CSS variables and `backdrop-filter` don't survive Gmail/Outlook) |
| **C — Inline digest** | Multi-item markdown briefings/newsletters | Rendered to light-card HTML and inlined directly as the body — safe because it's inline-styles-only |

All three came from reading real senders, not guessing at a house style — see `Examples/` for a verified live example.

## Sending mechanism

The skill also names the tool that actually calls an email API — a template alone doesn't send anything:

| Mechanism | Role |
|:---|:---|
| **Resend API** | Default sender for new automations — `send_email.py` at `My-Documents\My-AI-Tools\MCP-and-APIs\Resend-API\` |
| **Gmail MCP** (`mcp__gmail__*`) | Read/search/label existing mail only — this install has no send tool |
| **AgentMail** | Legacy — sending is paused fleet-wide since the Resend migration |

## About this folder

Reference exemplars for the skill — real output pulled from a live send, kept to verify the skill's claims and to show what "correct" looks like. These are not files the skill reads at runtime.

## Contents

| Path | What it is |
|:---|:---|
| [`Examples/template-c-iam-briefing-verified.html`](./Examples/template-c-iam-briefing-verified.html) | The actual HTML body of a real inline-digest briefing email, pulled from a live inbox. Ground truth for Template C — confirms the footer markup, and is where the two `mdToHtml` bugs documented in the skill (per-item bullets not listifying, `---` rendering as literal text) were found. Sender domain and product name have been genericized. |
| [`Examples/verification-notes.md`](./Examples/verification-notes.md) | What was compared, what matched the skill's original assumptions, and what didn't — written when Template C was added, so the next verification pass has a starting diff instead of starting cold. |

---

<p align="center">
  <a href="../../../README.md">← Resources home</a> ·
  <a href="../../../../Skills/Automation/email-template-mfs/SKILL.md">The skill →</a>
</p>
