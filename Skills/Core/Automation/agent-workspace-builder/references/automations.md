# The two weekly automations

Every workspace gets exactly two scheduled jobs. Each is one unattended agent session that
opens at most one pull request per run on its own branch prefix. Neither merges. A review
sweep (or a person) merges.

| | Roadmap job | Upkeep job |
|:---|:---|:---|
| **Purpose** | Build: finish the next roadmap item | Keep current: make what exists accurate |
| **Reads** | `docs/ROADMAP.md`, AGENTS.md, the code | AGENTS.md, `docs/intel/`, `skills/`, `.claude/`, `docs/reference/RESOURCES.md` |
| **Writes** | Whatever the item needs, plus CHANGELOG and the tick | `docs/intel/`, `skills/`, `.claude/` (skills, agents, commands, rules; hooks and settings held), `docs/reference/RESOURCES.md`, `docs/reference/CAPABILITIES.md` (regenerated), CHANGELOG, new `🔭 Later` roadmap items |
| **Never touches** | `docs/intel/`, `skills/`, RESOURCES.md, `.claude/` unless the item is about it | Code, tests, work folders, existing roadmap items, visibility |
| **Branch prefix** | `roadmap/auto-<date>` | `workspace/refresh-<date>` (or `upkeep/auto-<date>` in a new fleet) |
| **Model** | Mid-tier for most fields | Mid-tier with web search |
| **No-op week** | Nothing workable → no PR, report what blocked | Nothing changed → no PR, report what was checked |

The split is the design: **upkeep proposes, roadmap builds.** An upkeep run that finds a
promising MCP server or a missing skill adds a roadmap item under `### 🔭 Later` with the
source link. A later roadmap run (or a person) builds it.

## Shared run contract

Both jobs, every run:

1. **Pre-check before the session.** A script decides whether there's work (an open item
   for roadmap; always true for upkeep, which is weekly research) and whether a previous
   PR from the same job is still open. If one is, the run appends to it instead of
   opening a second.
2. **Fresh worktree** cut from the deploy branch, on the job's branch, deleted afterwards.
3. **Deny list passed in.** The session runs with a fleet deny file: no merging, no repo
   create, delete or visibility change, no closing issues, no force-push, no tool that
   acts on hardware or a live desktop session.
4. **Verify before shipping.** Run the workspace's four checks
   (`check-structure.py`, `validate-skills.py --strict`, `gen-capabilities.py --check`,
   `check-links.py`) plus its tests. Any failure → no PR, leave the tree clean, report.
5. **PR body** names what changed, the sources behind each outside fact, what was run and
   its result, what was skipped and why, and what to review first.
6. **Report** a one-line outcome (`shipped`, `appended`, `quiet`, `failed`) to the run log
   and the notification channel. A crashed session is `failed`, never a quiet week.

## Upkeep job, in parts

One session, one PR, these parts in order, each its own commit:

1. **Intel.** Research what changed in the field since the newest dated entry. Primary
   sources only (advisories, changelogs, standards bodies, official blogs). Every entry
   cites a URL opened this run. Archive entries older than 90 days.
2. **Portable skills (`skills/`).** Fix any skill the new intel makes wrong. Deep-review
   one skill a week in rotation (the least recently changed), checking every tool, flag,
   version and URL it names against upstream docs.
3. **Wired config (`.claude/`).** The same two passes over `.claude/skills/`, `agents/`,
   `commands/` and `rules/`: drift fixes from intel, plus one rotation item a week
   (least recently changed file across all four). Keep frontmatter valid and names stable;
   never delete or rename one (a rename breaks muscle memory and other docs). Hooks,
   `settings.json` and `.mcp.json` only when intel shows they're wrong, and only as a
   held change a person merges. Regenerate `docs/reference/CAPABILITIES.md` if anything
   here changed.
4. **Resources (`docs/reference/RESOURCES.md`).** Re-open every link (or a rotating third
   of a long list), update descriptions that drifted, retire dead or superseded ones with
   a reason, and add up to five new high-quality resources found during this run's
   research: official docs and standards, tools and CLIs, MCP servers, published skills
   and agent configs, learning material. Score each candidate on relevance, maintenance
   (a release or commit in the last year), trust (first-party or known author) and
   licence. Bump `Last updated`.
5. **Proposals.** For any candidate worth wiring in (a skill to adopt, an MCP server to
   add, a gap no skill covers), add one `- [ ]` item under `### 🔭 Later` in
   `docs/ROADMAP.md` with the source link and why. Don't install it.
6. **Standard conformance.** Run the four checks. Fix doc drift they find (a broken link,
   a stale generated file). Structural fixes beyond that become roadmap items.

**Don't manufacture edits.** Every change has a source URL or a repo fact behind it.
Bumping dates or rewording for its own sake is churn.

## Hold paths

A merge gate (the sweep's runner, or branch protection plus CODEOWNERS) holds any PR that
touches these for a person, whichever job opened it:

```text
.claude/settings.json
.claude/hooks/*
.mcp.json
.github/workflows/*   (optional: hold only deploy workflows if CI fixes should flow)
```

Put the hold in the gate's code or config, not in a prompt. "Don't merge hook changes"
in a sweep prompt is a request; a path gate is a guarantee.

## Scheduling

- **Spread the roadmap jobs** across the week (one workspace per evening) so each PR is
  reviewed before the next lands.
- **Run upkeep for all workspaces in one orchestrated slot**, one session per workspace
  in sequence, each isolated so one failure doesn't stop the rest. Give each session a
  deadline (60–90 minutes) and the orchestrator the sum plus margin.
- **Upkeep lands before the sweep that merges skills onward**, so a fixed skill reaches
  any downstream mirror the same week.
- One schedule table, kept by the scheduler's docs. The workspace's AGENTS.md names the
  jobs and their prefixes, never their times.

## Setting a job up

1. Fill `assets/roadmap-prompt.md` and `assets/upkeep-prompt.md` for the workspace: field,
   sources to watch, intel files, hold paths, verify commands, house voice.
2. Register the job with the scheduler and its branch prefix with the merge sweep.
   An unregistered prefix means PRs pile up unmerged with no error.
3. Dry-run: build the worktree and print the session command without spending a session.
4. Run once for real, by hand. Read the PR, the outcome report, and confirm no worktree
   was left behind. Only then trust the schedule.

## Running without a local scheduler

GitHub Actions can host the schedule, but Actions doesn't supply the agent: the job needs
an agent CLI on the runner, an API key or token in repository secrets, and a budget for
pay-per-use tokens. Use `workflow_dispatch` plus a `schedule:` cron, `concurrency:` with
`cancel-in-progress: false`, `permissions: contents: write, pull-requests: write` and
nothing more, and the same deny list via the CLI's settings flag. Committed workflow YAML
is not a working automation until a run has opened a PR.
