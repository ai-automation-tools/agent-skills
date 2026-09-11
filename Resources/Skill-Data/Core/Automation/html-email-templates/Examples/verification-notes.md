# Verification notes — Template C added 2026-09-03

## What was checked

Fetched a live inline-digest briefing email sent by a workflow-tool node (n8n-style "Format Outputs" code node feeding a markdown-to-HTML step), plus its send pipeline.

## Confirmed correct

- Template A's footer is exact, verbatim in the live email: `<hr style="margin-top:24px;border:none;border-top:1px solid #ddd"><p style="color:#888;font-size:12px;margin-top:8px"><strong>Automation Fleet</strong> &middot; automation fleet &middot; <a href="...">Browse more &rarr;</a></p>`.

## Wrong or incomplete in the original skill

- The skill assumed this class of email used Template A's plain-paragraph notification body. It didn't — the entire report was inlined as a light-card HTML document (`#fafaf9` page, white card, colored accent per workflow), a shape the skill hadn't documented at all. That became Template C.
- The skill's "don't inline reports" rule doesn't apply to Template C — it only uses inline `style="..."` attributes (no CSS custom properties, no `backdrop-filter`), so it survives Gmail intact. Confirmed by looking at it in a real inbox.
- The skill assumed one email = one delivery shape (inline OR attachment). The real email had both: the full report inline as the body, *and* an HTML attachment.
- The skill cited a shared footer helper as the source for the whole email. That's only true for the footer — the report body came from a separate workflow-tool code node; delivery was two-stage (the workflow tool posts to a send API and archives the HTML, then a follow-up script re-sends the archived copy as the actual email, appending the footer).

## Bugs found in the actual renderer (`mdToHtml`-style markdown→HTML function)

Both are visible directly in `Examples/template-c-iam-briefing-verified.html`:

1. **Per-item detail bullets don't listify.** The prompt template that generates the markdown puts `### {headline}` and its `- **Source:** ... / - **Link:** ... / - **What happened:** ...` lines in the same Markdown block (no blank line between them). `mdToHtml` classifies a block by its *first* line only, so the whole block matches the `### ` → `<h3>` branch; `.replace(...)` only swaps that first line, leaving the `- ` bullets underneath as raw unconverted text (literal `- ` prefixes, no `<br>`, no `<ul>`).
2. **`---` rules render as literal text.** A lone `---` block doesn't match `# `, `## `, `### `, or `/^- /m` (no space after the dashes), so it falls into the plain-`<p>` branch and renders as `<p>---</p>` instead of an `<hr>`.

Fixes for both are described in the skill's Template C section.

## Not yet checked

- Template B (report document) was pulled from source `.html` output, not verified against a live *sent* email — this template's reports are typically consumed as files, not emailed, so there was no live send to check against.
- Template A's plain-notification body (as opposed to its footer) hasn't been checked against a live failure-alert email — only the shared footer has been confirmed.
