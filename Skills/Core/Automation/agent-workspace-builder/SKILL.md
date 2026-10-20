---
name: agent-workspace-builder
description: Create, adopt, or audit a specialized agent workspace repo, a GitHub repo that gives an AI or CLI agent one field's skills, agents, commands, rules, hooks and docs (security, business analysis, full-stack dev, media, API research), and set up the two weekly automations that keep it alive, a roadmap job and an upkeep job. Lays down the standard layout (AGENTS.md canonical, CLAUDE.md importing it, a docs tree with only README, ROADMAP and CHANGELOG at its root, a generated capability reference, a curated RESOURCES.md list, portable skills apart from the wired .claude/ ones) plus scripts that check it in CI. Use whenever the user wants a new agent workspace or agent repo for a topic, wants an existing one brought up to the standard, asks to standardize several agent repos, wants a weekly roadmap or upkeep routine for one, wants a finished one taken public by a gated release job, or asks why a workspace's docs, skills or resources list went stale.
---

# Agent workspace builder

An **agent workspace** is a repo you open an agent in to do one kind of work. Its `.claude/`
(or another client's equivalent) carries skills, reviewer agents, commands, rules, hooks and
permissions pointed at that field, and its doctrine names the one failure an LLM is most
likely to commit there. It is a destination, not a template: people work *in* it.

This skill does three jobs:

| Job | What you get |
|:---|:---|
| **Create** | A new workspace repo that meets the standard on its first commit |
| **Adopt** | An existing workspace moved onto the standard without losing history, content or links |
| **Keep alive** | Two weekly scheduled jobs per workspace (roadmap and upkeep), each opening one PR; optionally a release job that takes a finished workspace public behind scripted gates and the owner's approval |

Read this file first, then the reference for the job:

| Job | Read |
|:---|:---|
| What the standard requires, file by file | `references/workspace-standard.md` |
| The roadmap and upkeep jobs: scope, schedule, hold paths, prompts; the optional release job | `references/automations.md` |
| Starting files to copy and fill | `assets/`: `AGENTS.md`, `CLAUDE.md`, `SECURITY.md`, `docs-README.md`, `RESOURCES.md`, `env.example`, `ci.yml`, `roadmap-prompt.md`, `upkeep-prompt.md` |
| The checks CI runs | `scripts/` (below) |

## The standard in one screen

```text
<workspace>/
├── README.md              house-style root README (repo-docs-builder)
├── AGENTS.md              THE doctrine, vendor-neutral; every client reads it
├── CLAUDE.md              `@AGENTS.md` import + Claude-only notes, nothing copied
├── SECURITY.md            how to report a problem; what the guardrails are
├── .env.example           secret NAMES, committed; real values in .env (gitignored)
├── .claude/               wired config: skills/ agents/ commands/ rules/ hooks/ settings.json + settings.md
├── skills/                PORTABLE skills (vendor-neutral SKILL.md) + README.md catalog
├── docs/
│   ├── README.md          docs index        ┐
│   ├── ROADMAP.md         the backlog       ├ the only three files at the docs root
│   ├── CHANGELOG.md       what changed      ┘
│   ├── reference/         CAPABILITIES.md (generated) · RESOURCES.md (curated) · other reference
│   ├── intel/             dated, sourced changes in the field (upkeep writes it)
│   └── <topic>/           methodology/, guides/, plans/ … anything else, in a subfolder
├── scripts/               check-structure.py · validate-skills.py · gen-capabilities.py · check-links.py
│                          + envfile.py (loads .env for scripts and MCP servers)
└── .github/workflows/ci.yml   runs the four checks, plus the repo's own tests
```

Plus whatever the field needs (`scope/`, `findings/`, `research/`, `src/`): the standard governs
the shared frame, never the work folders.

## Principles

1. **One fact, one home.** AGENTS.md is the doctrine; CLAUDE.md imports it with a bare
   `@AGENTS.md` line (prose like "see AGENTS.md" loads only that sentence). Counts live in
   the generated `docs/reference/CAPABILITIES.md`, never hand-typed into a README.
2. **Scripts decide, prompts judge.** Layout rules are an exit code
   (`scripts/check-structure.py`), not a paragraph. Writing, reviewing and choosing
   resources are judgment, and stay in the prompts.
3. **Wired and portable are different products.** `.claude/skills/` is what this
   workspace's own sessions load. `skills/` is vendor-neutral and installs into any agent.
   Never move one into the other.
4. **Every outside claim carries a source and a date.** Intel entries, RESOURCES.md rows
   and any version or deprecation note in a skill cite a URL that was opened this run.
5. **Discovery proposes, it doesn't install.** Upkeep may fix and improve what's there.
   A new third-party skill, MCP server or tool becomes a roadmap item, never a silent
   install. Unreviewed third-party code is never run.
6. **Guardrail changes wait for a person.** Edits to `.claude/settings.json`, hooks or
   `.mcp.json` widen what an agent may do. Automations may propose them; a person merges.
7. **Lean beats complete.** No empty `evals/`, `templates/` or `roadmap/` folders "for
   later". A folder exists when something lives in it.
8. **Secrets live in `.env`, names in `.env.example`.** Not in shell profiles or user
   environment variables: a workspace that's published or cloned elsewhere must say what it
   needs in a file that travels with it. `.env` is gitignored; `.env.example` is committed
   with names and where to get each value, never a value. Scripts and MCP servers read
   `.env` through `scripts/envfile.py`.
9. **Proceed unless vetoed.** The owner's attention is the scarcest input. Only five kinds
   of decision wait for an answer (money, credentials, going public, outward actions,
   widening permissions); everything else is a proposal with a default and a date seven
   days out, applied automatically unless the owner objects. Subjective gates ("the owner
   says it's in daily use") become measured ones (`scripts/usage.py`). Details:
   `references/automations.md`, *Autonomy*.

## Procedure: create a new workspace

1. **Pin the parameters** (ask only for what you can't infer): repo name and owner, field
   and sub-fields, the one failure mode the doctrine targets, supported clients, visibility
   (default private), deploy branch and working branch, scheduler, notification channel.
2. **Create the repo** through whatever wrapper the owner uses to create repos and verify
   security settings. A plain `gh repo create` leaves secret scanning and push protection
   to chance. Commit with a noreply identity if it could ever go public.
3. **Lay down the frame** from `assets/`: `AGENTS.md`, `CLAUDE.md`, `SECURITY.md`,
   `docs/README.md`, `docs/reference/RESOURCES.md`, `.env.example` (from `env.example`),
   `.github/workflows/ci.yml`, and copy all six `scripts/` from this skill. Fill every `⟨placeholder⟩`; a left-over one fails review.
4. **Build the wired config.** Start with 3–6 `.claude/skills/` for the field's core
   workflows, one read-only reviewer agent that attacks the workspace's own output, a
   command per repeatable deliverable, `rules/` for the non-negotiables, and a
   `settings.json` with deny rules for anything destructive or outward-facing.
   Explain every allow, ask and deny in `.claude/settings.md`.
5. **Seed the portable skills**: two or three field skills that don't overlap the wired
   ones, cataloged in `skills/README.md`.
6. **Write the docs with `repo-docs-builder`** (if installed; otherwise follow its house
   style): root README, `docs/README.md` index linking every subfolder, `docs/ROADMAP.md`
   in the roadmap standard with a Go-live split (`## After public release` if it's headed
   public, `## After go-live` if it stays private), and `docs/CHANGELOG.md` with the first entry.
7. **Seed RESOURCES.md and intel** by research, not memory: 15–30 resources across the
   categories in the standard, each opened this session; one dated intel file per stream.
8. **Generate and check**: `python scripts/gen-capabilities.py`, then
   `check-structure.py`, `validate-skills.py --strict`, `check-links.py`. All exit 0.
9. **Set up both automations** per `references/automations.md`, dry-run each, then run
   each once for real and read the PR before trusting the schedule.

## Procedure: adopt an existing workspace

1. **Inventory first, change nothing.** List what's there: agent docs, `.claude/` contents,
   docs and where they sit, scripts, CI, open PRs, and every scheduled job that writes to
   the repo, plus the paths those jobs' prompts hardcode. Run `check-structure.py --root
   <repo>` from this skill to get the gap list.
2. **Check the branch is clean and current** with the deploy branch. Work on the repo's
   normal working branch and ship by PR.
3. **Move, don't copy.** `git mv` every doc that leaves the docs root into a subfolder
   (`CAPABILITIES.md` → `docs/reference/`, reference docs → `docs/reference/`, guides and
   methodology → their own folder). On Windows a case-only rename (`Docs/` → `docs/`)
   needs two steps: `git mv Docs docs-tmp`, then `git mv docs-tmp docs`.
4. **Make AGENTS.md canonical.** Move the doctrine out of CLAUDE.md into AGENTS.md
   verbatim, then reduce CLAUDE.md to the import line plus genuinely Claude-only notes.
   Don't rewrite the doctrine while moving it; content edits are a separate change.
5. **Replace the shared scripts** with this skill's copies and point CI at all four. A
   workspace with its own capability generator (an API registry, say) keeps it and just
   writes to `docs/reference/CAPABILITIES.md`. A copy made on Windows loses the executable
   bit; if the repo runs ruff (EXE001), restore it with `git update-index --chmod=+x scripts/<name>.py`.
6. **Fix every link** the moves broke: `check-links.py` finds them inside the repo; grep
   outside it too (scheduled job prompts, sibling indexes, other repos' docs).
7. **Add what's missing**: `SECURITY.md`, `RESOURCES.md` (researched), `docs/intel/README.md`.
8. **Log it**: one CHANGELOG entry naming every move, then regenerate CAPABILITIES and
   run all four checks. Open the PR; never merge it yourself.
9. **Repoint the automations** in the same pass. A prompt that still names `Docs/` or
   `docs/CAPABILITIES.md` will quietly do nothing, or recreate the old file.

## Procedure: audit

Run the four scripts, then read for what they can't see: doctrine in CLAUDE.md that never
moved, a RESOURCES.md full of links nobody opened, intel older than a month, a wired skill
whose tool flags have changed, an automation whose prompt names a path that moved, PRs
from either job sitting unmerged. Report findings ranked by what an agent in the workspace
would get wrong because of each one.

## Scripts

Copy all six into the workspace's `scripts/`. Each is stdlib-only Python 3.11+ and has a
`--self-check`.

| Script | Checks |
|:---|:---|
| `scripts/check-structure.py` | Required files, docs-root rule, `@AGENTS.md` import, lowercase `docs/`, RESOURCES.md has a date (warns when stale), and the env rule: `.env` gitignored, `.env.example` tracked with no secret values, every `${VAR}` in `.mcp.json` named in it |
| `scripts/validate-skills.py` | Every `.claude/skills/` and `skills/` SKILL.md against the Agent Skills spec; command and agent frontmatter |
| `scripts/gen-capabilities.py` | Writes `docs/reference/CAPABILITIES.md` from `.claude/` and `skills/`; `--check` fails CI when stale |
| `scripts/check-links.py` | Every relative link in every Markdown file resolves |
| `scripts/usage.py` | Not run in CI (needs local logs): counts sessions and active days in this clone from Claude Code's transcripts; `--check --min-days 10` is the measured "in daily use" gate |
| `scripts/envfile.py` | Not a check: loads `.env` (`load_env()` for scripts; `envfile.py -- <cmd>` to launch an MCP server with it; `--names` lists names, never values) |

## Anti-patterns

- **Copying AGENTS.md into CLAUDE.md** "so Claude sees it". The import does that, and the
  copy drifts by the next week.
- **A docs root that grows.** Every new doc at `docs/` makes the index longer and the
  three files that matter harder to find. Subfolder it.
- **RESOURCES.md from memory.** A list of links nobody opened is where dead URLs and
  hallucinated repos come from. Every row has a verified date.
- **Upkeep that builds features.** Upkeep keeps what exists accurate and proposes the
  rest as roadmap items. The roadmap job builds. Mixing them makes both PRs unreviewable.
- **Automations that merge their own PRs** or edit guardrails without a person.
- **Scaffolding the master checklist.** Issue templates, `evals/`, `VERSION` and a
  capability JSON registry are worth adding when a job reads them, not before.
