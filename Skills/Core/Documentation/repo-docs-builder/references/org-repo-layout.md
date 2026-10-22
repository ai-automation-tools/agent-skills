# The org repo layout

Where every shared kind of content lives in an `ai-automation-tools` repo, and how folders are spelled.
Adopted 2026-10-22. Existing repos are migrated one PR at a time; new repos start here. The analysis
and the per-repo migration list: `Custom-Domains/Public-ai-automation-tools.dev/Docs/Reports/2026-10-22-org-standardization.md`.

## Spelling

- **Every folder is lowercase-kebab**: `docs/`, `user-guides/`, `cli-mcp-config/`. Never `Docs/`,
  `Images/`, `Skills/`, `Src/`, `Chat-Topics/`, `snake_case/`.
- GitHub paths are case-sensitive even though Windows isn't: a link to `docs/ROADMAP.md` 404s on
  GitHub when the folder is committed as `Docs/`. Rename with two moves
  (`git mv Docs docs-tmp && git mv docs-tmp docs`), never one.
- Exempt: names a tool requires (`.github/`, `.claude/`, `.vscode/`, `__tests__/`, `node_modules/`).
- Root and `docs/` control files are UPPERCASE: `README.md`, `AGENTS.md`, `CLAUDE.md`, `LICENSE`,
  `SECURITY.md`, `CONTRIBUTING.md`, `docs/ROADMAP.md`, `docs/CHANGELOG.md`, `docs/UPSTREAMS.md`.
  Every other doc is `lowercase-kebab.md`.

## Where things go

| Content | Path | Rule |
|:---|:---|:---|
| Agent instructions | `AGENTS.md` + `CLAUDE.md` | `AGENTS.md` is canonical (Codex, Gemini CLI, opencode read it); `CLAUDE.md` is a bare `@AGENTS.md` plus Claude-only notes |
| Docs | `docs/` | `README.md` hub, `ROADMAP.md`, `CHANGELOG.md`; `UPSTREAMS.md` once live. Subfolders from this list before inventing one: `setup/`, `guides/`, `architecture/`, `decisions/` (ADRs), `product/`, `diagrams/`, `reports/`, `testing/` |
| Diagrams | `docs/diagrams/` | Source (`.mmd`, `.json`, `.dot`) next to its render (`.svg`, `.png`, `.html`). A script that builds them lives in `scripts/` |
| App / library code | `src/` | A split stack uses `backend/src/` + `frontend/src/` instead |
| Demo or app front end | `site/` | What Pages or Vercel serves. A marketing homepage kept in the repo goes in `homepage/` |
| MCP server | `mcp-server/` when it installs on its own; otherwise inside `src/` | Either way, **`docs/mcp-server.md`** names the entry file, the transport, every tool and the install line. That doc is what the Prompt Library card and the org map read |
| Portable skills | `skills/<name>/SKILL.md` | What the repo ships. `.claude/skills/` is wiring only (installed copies), never the source |
| Portable subagents | `agents/<name>.md` | Same rule; `.claude/agents/` is wiring |
| Prompt templates | `prompts/<group>/<name>.md` | One `README.md` per group. Not under `docs/` |
| Scripts | `scripts/` | Dev and ops scripts. `scripts/setup/` etc. for groups |
| Tests | `tests/` | Not `test/`. A stack that colocates (`*.test.ts` beside the code) may skip the folder |
| README / brand images | `images/` | The app icon and favicon belong to `site/` |
| Settings | `.env.example` committed, `.env` gitignored | Names and where to get each value, never values |

Never committed: `.env*` (except `.env.example`), `artifacts/`, `logs/`, `temp/`, `output/`, build
output (`dist/`, `_site/`, `.next/`), virtualenvs (`.venv/`, `venv/`), old copies (`versions/`, `zip/`,
`.archive/`): git history is the archive.

## Exceptions, stated not discovered

- **Publish-target repos** (`*.github.io`, `<app>-site`, `<app>-demo`) serve from the root; only
  `README.md` is required.
- **`agent-skills`** is a catalog: `skills/<tier>/<category>/<name>/SKILL.md`, tiers and categories
  lowercase too.
- **Agent workspaces** (`Org_Agents`) add work folders (`findings/`, `research/`, `projects/`…) per
  the `agent-workspace-builder` standard; the shared folders above still apply.

## Checking it

A rule nobody checks is a suggestion. Until the org layout check exists, review a new repo against this
table before its first PR merges; `agent-workspace-builder`'s `check-structure.py` already enforces the
workspace half.
