# Using Skills

How to install, invoke, and author the custom Agent Skills in this repo.

## What a Skill is

A **Skill** is a reusable, model-invocable capability packaged as a single `SKILL.md` file. It teaches an agent (Claude Code and compatible CLIs) how to perform a specific task well. The agent loads the skill's instructions only when the skill is invoked, so skills keep specialized knowledge out of the base context until it's needed.

Skills sit in **three tiers** under [`../skills/`](../skills), and they do not install to the same place:

```
skills/
├── core/                    # portable — installs to ~/.claude/skills
│   └── <category>/          # e.g. business, documentation, image-gen
│       └── <skill-name>/
│           └── SKILL.md     # YAML frontmatter (name, description) + instructions
├── domain/                  # portable FIELD skills mirrored from the org's agent workspaces —
│   └── <domain>/            # installs to ~/.claude/skills only with -Domain
│       └── <skill-name>/
└── projects/                # ADDITIONAL skills for one org repo — installs into THAT repo,
    │                        # on top of the skills it already owns
    └── <repo-slug>/         # roundtable · cronsole · edge-radar · …
        └── <skill-name>/
            └── SKILL.md
```

One question decides the tier: **would you invoke this from a repo other than the one it was
written for?** Yes → [`Core`](../skills/core/README.md). No → [`Projects`](../skills/projects/README.md).
The test is about where you invoke it, not what it is about — `project-hub-scaffold` is Core
despite being named for an org product, because you run it from whatever repo is *getting* a hub.

Categories inside `core/` just group related skills. Add one when a skill fits none of them.

[`Domain`](../skills/domain/README.md) is the third tier, and you don't author into it. A weekly
harvest mirrors field skills (engineering, security, business, media, API) from the org's agent
workspaces into it, which keeps Core a short list. Install them with
`pwsh scripts/install-skills.ps1 -Domain`, and edit them in their workspace repo.

## Anatomy of a SKILL.md

```markdown
---
name: skill-name
description: One-line summary that tells the agent WHEN this skill applies.
---

Instructions the agent loads on invocation...
```

- **`name`** — kebab-case, unique. This is what you type to invoke it (`/skill-name` in Claude Code).
- **`description`** — the single most important line. The agent reads *only* the description to decide whether to load the skill, so it must clearly state the trigger conditions ("Use when…"). Lead with capability, then triggers.
- **Body** — the full instructions, principles, checklists, and anti-patterns. Loaded only after invocation, so it can be as detailed as needed.

## Installing / making a skill available

Skills are picked up from an agent's skills directory. Three options:

1. **Run the install script (recommended for Claude Code)** — from the repo root, run the bundled installer. It mirrors every Core leaf skill folder into `~/.claude/skills/<name>/` (whole folder, so `scripts/`/`references/`/`prompts/`/`evals/` come along; local `reports/` output never does):

   ```powershell
   pwsh scripts/install-skills.ps1                          # Core tier -> ~/.claude/skills
   pwsh scripts/install-skills.ps1 -Core -Skill recipe-validator   # just one
   pwsh scripts/install-skills.ps1 -List                    # every skill, with its tier
   pwsh scripts/install-skills.ps1 -WhatIf                  # dry run

   # every agent CLI on this machine, through the three folders they share:
   # ~/.claude/skills, ~/.agents/skills and ~/.gemini/config/skills
   pwsh scripts/install-skills.ps1 -AllAgents
   pwsh scripts/install-skills.ps1 -AllAgents -Skill automated-dev-pipeline   # just one, everywhere

   # project tier goes into the repo it belongs to, never user scope
   pwsh scripts/install-skills.ps1 -Project cronsole -Destination D:/repos/cronsole/.claude/skills
   ```

   A bare run installs **Core only**, so a project skill cannot leak into user scope by accident.
   Re-run it after editing any skill. Restart the Claude Code session to reload the catalog.
2. **Point at this repo** — configure your agent's skills path to include this repo's `skills/core/` folder.
3. **Copy an individual skill** — copy a single `<skill-name>/` folder (the leaf folder, not its tier or category) into your agent's skills directory.

> [!NOTE]
> Tier and category folders are a repo-organization convention. Agents discover skills by the leaf `<skill-name>/` folder containing the `SKILL.md`, so when copying one out, copy that leaf — the levels above it don't need preserving.
>
> That flattening is also why **skill names must be unique across the whole repo**, both tiers included: two skills named the same would overwrite each other in the skills directory. The install script throws on a collision rather than letting it happen quietly.

### Where each agent CLI looks

Every CLI below reads the same `<skill-name>/SKILL.md` folder. They differ in where they look,
which other CLIs' folders they also read, and how you call a skill by name. **Reads the
`-AllAgents` copy from** is where the installer's copy reaches it; **also reads** is the CLI's
other user-scope folders, which `-AllAgents` leaves alone. Checked against each CLI's docs on
2026-11-11.

| CLI | Reads the `-AllAgents` copy from | Also reads (user scope) | Project folder | Call it by name |
|:---|:---|:---|:---|:---|
| **Claude Code** | `~/.claude/skills` | — | `.claude/skills` | `/<name>` |
| **Codex** | `~/.agents/skills` (shared) | — (`~/.codex/skills` is legacy; a copy there shows up twice) | `.agents/skills`, from the cwd up to the repo root | `$<name>`, or pick from `/skills` |
| **Kimi Code** | `~/.agents/skills` (shared) | `~/.kimi-code/skills` | `.kimi-code/skills`, `.agents/skills` at the git root | `/skill:<name>` |
| **agy** (Antigravity CLI) | `~/.gemini/config/skills` (shared with the IDE) | `~/.gemini/antigravity-cli/skills`, `~/.gemini/skills` | `.agents/skills` (`.agent/skills` still works) | `/<name>`; `/skills reload` after adding one |
| **Antigravity IDE / App** | `~/.gemini/config/skills` | `~/.gemini/antigravity/skills` (IDE, legacy) | `.agents/skills` | `/<name>` in the App; name it in the prompt in the IDE |
| **opencode** | `~/.claude/skills` and `~/.agents/skills` | `~/.config/opencode/skills` | `.opencode/skills`, `.claude/skills`, `.agents/skills` | loaded through its `skill` tool |
| **Kilo** | `~/.agents/skills`; also `~/.claude/skills` with Claude Code compatibility on | `~/.kilo/skills` | `.kilo/skills`, `.agents/skills` | `/<name>`; `/reload` mid-session |

What follows from the table:

- **All of them load a skill on their own** when a request matches its `description`, so the
  same trigger wording has to work everywhere. Codex can turn that off per skill
  (`allow_implicit_invocation`), Kimi with `disableModelInvocation`.
- **Three folders reach all seven.** `~/.agents/skills` is the shared one: Codex, Kimi,
  opencode and Kilo all read it. agy and the Antigravity IDE share `~/.gemini/config/skills`.
  So `-AllAgents` writes `~/.claude/skills`, `~/.agents/skills` and `~/.gemini/config/skills`,
  each only when a CLI that reads it is installed.
- **opencode still sees two copies**, from `~/.claude/skills` and `~/.agents/skills` (Kilo too,
  with Claude Code compatibility on). Claude Code reads only its own folder, so dropping either
  would cost a CLI its skills. The copies are byte-identical, so nothing conflicts.
- **Copies from before 2026-11-12 are cleaned up.** Older `-AllAgents` runs also wrote
  `~/.gemini/antigravity-cli/skills`, `~/.config/opencode/skills` and `~/.kilo/skills`. The
  next `-AllAgents` run removes the folders there that are named like a skill it installs, and
  leaves anything else in them alone. `-WhatIf` shows what it would remove.
- **Restart or reload after installing.** Claude Code and Kilo re-scan at session start, agy
  on `/skills reload`, and Codex picks up changes on its own (restart it if one doesn't appear).
- **The folder name must match `name:`.** Kilo enforces it; the rest just expect it.

## Invoking a skill

- **Explicitly**: type `/<skill-name>` in Claude Code (e.g. `/repo-docs-builder`). Other CLIs use
  their own syntax; see the last column of the table above.
- **Automatically**: the agent may load a skill on its own when your request matches the skill's `description`. This is why a precise, trigger-rich description matters.

## Authoring a new skill

1. Pick the tier with the invoke-it-anywhere test, then create `skills/core/<category>/<skill-name>/SKILL.md` (in the category that fits, or a new one) or `skills/projects/<repo-slug>/<skill-name>/SKILL.md`.
2. Write the frontmatter — a unique `name` and a description that leads with the capability and names the trigger conditions.
3. Write the body: purpose, when-to-use, principles, a concrete execution checklist, and explicit anti-patterns. Concrete examples beat abstract advice.
4. Keep it self-contained — the agent won't have your surrounding conversation when the skill loads.
5. Add a row to the matching table — the repo [`../README.md`](../README.md) and [`skills/core/README.md`](../skills/core/README.md) for a Core skill, or the project's own README for a project skill.
   A Core skill also needs its overview page at `resources/skill-data/core/<category>/<skill-name>/README.md` (the README rows link to it), a card entry in `site/showcase.json`, and a fresh `python scripts/build-showcase.py` run. If it came from [`SKILL-IDEAS.md`](SKILL-IDEAS.md), strike its row there.
6. If it's worth documenting further (design rationale, longer usage notes), add a doc here in `docs/`.

> [!TIP]
> The [`repo-docs-builder`](../skills/core/documentation/repo-docs-builder/SKILL.md) skill is a good reference implementation — it shows the frontmatter + when-to-use + principles + workflow + anti-patterns structure.

## Testing a skill

- Run `python scripts/validate-skills.py` from the repo root. It checks the frontmatter, the name, the description length, the paths the body cites, the README rows and the `resources/skill-data/` mirror for every skill, and lists every failure it finds. Standard library only, so nothing to install. CI runs the same check on every pull request (`.github/workflows/validate.yml`).
- Run `python scripts/check-links.py` too. It fails on any relative link in a README, `docs/` or the showcase page that points at a path that doesn't exist (case-sensitive), which is what a rename or a move leaves behind. CI runs it in the same workflow.
- If you changed the installer, run `pwsh -NoProfile -File scripts/test-install-skills.ps1`. It installs into a temp directory, never your real skills folder, and fails if the layout isn't flat or a duplicated name doesn't throw. CI runs it too.
- If you changed a script inside a skill, run `python scripts/test-skill-scripts.py` and `pwsh -NoProfile -File scripts/test-skill-scripts.ps1`. They run the helpers that ship in skills against fixture inputs in a temp directory. Adding a helper script? Add its checks to the matching file. CI runs both.
- Invoke it explicitly (`/<skill-name>`) on a real task and confirm the output follows the skill's rules.
- Check auto-invocation. For each Core skill, [`scripts/trigger-cases.json`](../scripts/trigger-cases.json) holds two requests that should load it, in plain user wording with no skill name, and one near miss that shouldn't. `python scripts/check-triggers.py` sends each one to a fresh headless `claude -p` session in an empty folder, so no repo context helps, and reads which skill the session loaded. A request that should load the skill and doesn't means the `description` needs the user's words; a near miss that loads it means the description is too broad. Loading is not fully deterministic, so re-run a failed case before you edit anything: one miss in three runs is noise, a miss every time is a gap. Then tighten the description, reinstall, and re-run that skill (`--skill <name>`). It tests the installed copy and spends tokens, so it isn't in CI.
- Run a skill's evals when it has them: `evals/evals.json` lists realistic prompts, each with the behaviour a grader checks for. Seven Core skills ship them.
