# Verification notes — Template C added 2026-09-03

## What was checked

Fetched the live "IAM & Security Briefing" email (id `1a057ea31e7b05eb`, from `fleet@send.mikesailab.com`, sent 2026-08-31) via `gmail_get_message`, and read the actual generator: the shared `Format Outputs` code node in `Tools/n8n/workflows/Newsletters/IAM-Security-Briefing-Weekly-AgentMail/IAM-Security-Briefing-Weekly-AgentMail.json`, plus its `Configuration` node and the `Send Email via AgentMail` node.

## Confirmed correct

- Template A's footer is exact, verbatim in the live email: `<hr style="margin-top:24px;border:none;border-top:1px solid #ddd"><p style="color:#888;font-size:12px;margin-top:8px"><strong>AI-Automation-Library</strong> &middot; automation fleet &middot; <a href="...">Browse more &rarr;</a></p>`.

## Wrong or incomplete in the original skill

- The skill assumed the IAM emails used Template A's plain-paragraph notification body. They don't — the entire report is inlined as a light-card HTML document (`#fafaf9` page, white card, `#dc2626` accent for this workflow), a shape the skill didn't document at all. That became Template C.
- The skill's "don't inline reports" rule doesn't apply to Template C — it only uses inline `style="..."` attributes (no CSS custom properties, no `backdrop-filter`), so it survives Gmail intact. Confirmed by looking at it in a real inbox.
- The skill assumed one email = one delivery shape (inline OR attachment). The real email has both: the full report inline as the body, *and* a 29.7 KB `IAM-Security-Briefing_08-29-26.html` attachment.
- The skill cited `_email_footer.py` / `send_agentmail_notification.py` as the source for the whole email. That's only true for the footer. The report body comes from n8n's `Format Outputs` node; delivery is two-stage — n8n POSTs to AgentMail's raw send API and commits the archived `.html` to GitHub, then the Python fleet's `send_agentmail_artifact.py` re-sends the archived copy as the actual `fleet@send.mikesailab.com` email (`--html` = same body, `--file` = attachment), which is what appends the footer.

## Bugs found in the actual renderer (n8n `Format Outputs` node, `mdToHtml` function)

Both are visible directly in `Examples/template-c-iam-briefing-verified.html`:

1. **Per-story detail bullets don't listify.** The agent's prompt template puts `### {headline}` and its `- **Source:** ... / - **Link:** ... / - **What happened:** ...` lines in the same Markdown block (no blank line between them). `mdToHtml` classifies a block by its *first* line only, so the whole block matches the `### ` → `<h3>` branch; `.replace(...)` only swaps that first line, leaving the `- ` bullets underneath as raw unconverted text (literal `- ` prefixes, no `<br>`, no `<ul>`).
2. **`---` rules render as literal text.** A lone `---` block doesn't match `# `, `## `, `### `, or `/^- /m` (no space after the dashes), so it falls into the plain-`<p>` branch and renders as `<p>---</p>` instead of an `<hr>`.

Fixes for both are described in the skill's Template C section. Neither was applied to the n8n workflow itself — that's a separate, deliberately out-of-scope change (`Tools/n8n/workflows/Newsletters/*/*.json`, all 4 sibling workflows share the same code node).

## Not yet checked

- Template B (Portfolio Pilot report) was pulled from source `.html` output, not verified against a live *sent* email — Portfolio Pilot reports are typically consumed as files, not emailed, so there was no live send to check against.
- Template A's plain-notification body (as opposed to its footer) hasn't been checked against a live failure-alert email — only the shared footer has been confirmed.
