# Upstreams

Every external standard, tool and platform the skill library depends on, what the repo assumes
about each, and where to check whether that assumption still holds. The biweekly **Agent-Skills
Upstream Check** routine (`upstream/auto-*` PRs) works from this file. Keep it current by hand
too: a new install target, CI action or third-party asset is a new row.

**Not in scope here:**

- Whether each skill's *advice* is still current in its field. The monthly **Agent-Skills
  Monthly Skill Review** owns that, for `Skills/Core` and `Skills/Projects`.
- `Skills/Domain/`. Those are byte-identical mirrors of the org agent workspaces, refreshed by the
  weekly **Skill Harvest**; fix them at the source.

The upstream check also keeps the **showcase site and indexes in step with the catalog** (see
its prompt). That isn't an upstream, so it has no row here.

**Last checked** is filled in by the routine, and only with a date it actually read the
source. `—` means never checked.

## The skill format

| Upstream | What the repo assumes | Code | Check at | Last checked |
|:---|:---|:---|:---|:---|
| **Agent Skills format (Claude Code)** | A skill is a folder with a `SKILL.md`: YAML frontmatter first, `name` (kebab-case, equal to its folder) and `description` (the validator enforces 40–1,024 characters), then Markdown instructions; optional `scripts/`, `references/` and other folders loaded on demand. Personal skills in `~/.claude/skills/<name>/`, project skills in `<repo>/.claude/skills/<name>/`; invoked as `/skill-name` | `scripts/validate-skills.py`, `Docs/USING-SKILLS.md`, `CLAUDE.md`, every `SKILL.md` | docs.claude.com/en/docs/claude-code/skills; docs.claude.com/en/docs/agents-and-tools/agent-skills; github.com/anthropics/claude-code/blob/main/CHANGELOG.md | — |
| **Open Agent Skills spec** | The same frontmatter is portable to other agents that read the open spec, so one leaf folder installs everywhere | `Docs/USING-SKILLS.md`, `README.md` | agentskills.io; github.com/anthropics/skills | — |

## Install targets

| Upstream | What the repo assumes | Code | Check at | Last checked |
|:---|:---|:---|:---|:---|
| **Codex + Kimi** | Global skills read from `~/.agents/skills` (shared); `~/.codex/skills` is Codex's legacy path | `scripts/install-skills.ps1` (`-AllAgents`), `Docs/USING-SKILLS.md` | developers.openai.com/codex (skills docs); github.com/openai/codex/releases; Kimi CLI docs | — |
| **Antigravity CLI (agy) and IDE** | CLI reads `~/.gemini/skills`; the IDE reads `~/.gemini/config/skills` | `scripts/install-skills.ps1`, `Docs/USING-SKILLS.md` | antigravity.google/docs; github.com/google-gemini/gemini-cli/releases | — |
| **opencode** | Global skills in `~/.config/opencode/skills` | `scripts/install-skills.ps1`, `Docs/USING-SKILLS.md` | opencode.ai/docs; github.com/sst/opencode/releases | — |
| **Kilo** | Global skills in `~/.kilo/skills`; skipped unless installed | `scripts/install-skills.ps1` | kilo.ai/docs; github.com/Kilo-Org/kilocode/releases | — |

## Tooling and CI

| Upstream | What the repo assumes | Code | Check at | Last checked |
|:---|:---|:---|:---|:---|
| **Python** | `validate-skills.py` is stdlib-only (`re`, `sys`, `pathlib`); CI uses `python-version: '3.x'` | `scripts/validate-skills.py`, `.github/workflows/validate.yml` | python.org/downloads (status of each version); github.com/actions/setup-python/releases | — |
| **PowerShell 7** | `install-skills.ps1` runs under `pwsh` | `scripts/install-skills.ps1` | learn.microsoft.com/powershell/scripting/install/powershell-support-lifecycle | — |
| **GitHub Actions** | `actions/checkout@v4`, `actions/setup-python@v5`, `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4` | `.github/workflows/*.yml` | each action's GitHub releases; github.blog/changelog (label: actions) | — |

## Showcase site

| Upstream | What the site assumes | Code | Check at | Last checked |
|:---|:---|:---|:---|:---|
| **GitHub Pages** | `site/` published by the Pages workflow, custom domain `agent-skills.ai-automation-tools.dev` in `site/CNAME`, HTTPS (the `.dev` TLD is HSTS-preloaded, so no certificate means no site) | `.github/workflows/pages.yml`, `site/CNAME` | docs.github.com/en/pages; github.blog/changelog (label: pages) | — |
| **Google Fonts** | `fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300..700&family=Geist+Mono:wght@400..600&display=swap`, with preconnects | `site/index.html` | developers.google.com/fonts/docs/css2; fonts.google.com (Geist, Instrument Serif) | — |
| **Org consent gate** | `<script src="https://ai-automation-tools.dev/consent.js" defer>`, served by the org landing page repo; it gates any future analytics | `site/index.html` | the landing repo's `consent.js` and `docs/UPSTREAMS.md` | — |

Flag breaking changes, removals, EOL runtimes and security advisories only. There's no package
manifest, so nothing here is Dependabot's.
