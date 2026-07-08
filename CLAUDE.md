# CLAUDE.md — My Custom Skills

> **Repo:** `github.com/michaelschecht/My-Custom-Skills` (private) · **Owner:** Mike (`mikeschecht@gmail.com`, GH `michaelschecht`) · **Branch:** `main` (this repo does **not** use the lab-wide `mike_desktop` convention).
> **Ecosystem context:** this repo is one entry in the Agent-Skills index at [`../README.md`](../README.md). That index is background; **this file is authoritative for work inside `My-Custom-Skills/`.**

## Your role

You maintain **Mike's personal collection of Agent Skills** — reusable, model-invocable capabilities packaged as `SKILL.md` files. Your job is to **manage this repo**: author new skills, validate existing ones, keep supporting resources organized, and keep the docs/index in sync. Prioritize correct, portable, well-structured skills over commentary. Be direct.

A **Skill** = a single `SKILL.md` (YAML frontmatter + instructions) that an agent loads *only when invoked*, keeping specialized knowledge out of base context until needed. In Claude Code, skills surface as `/skill-name`.

---

## Repository layout

```
My-Custom-Skills/
├── README.md                       # public index — Skills table by category + Docs table
├── CLAUDE.md                       # this file
├── .gitignore
├── Docs/
│   ├── USING-SKILLS.md             # install / invoke / author guide
│   └── SKILL-IDEAS.md              # backlog of candidate skills
├── Skills/
│   └── <Category>/                 # e.g. Cooking, Documentation, Image-Gen
│       └── <skill-name>/           # the LEAF folder — this is the portable unit
│           ├── SKILL.md            # required: frontmatter + instructions
│           ├── scripts/            # optional: deterministic helpers (Python, etc.)
│           ├── references/         # optional: standards/knowledge the body cites
│           ├── prompts/            # optional: prompt templates the skill follows
│           ├── evals/              # optional: TRACKED test-case definitions
│           └── reports/            # optional: gitignored RUN OUTPUT (never committed)
└── Resources/
    ├── Skill-Data/
    │   └── <Category>/<skill-name>/  # per-skill supporting data, MIRRORS the Skills tree
    │       ├── README.md             #   (examples, screenshots, sample outputs, notes)
    │       ├── Examples/ · Images/   #   heavy/reference assets that shouldn't bloat the skill
    └── Links/                        # curated external references for skill-building
```

**Current categories:** `Cooking`, `Documentation`, `Image-Gen`. Add a new category folder under `Skills/` only when a skill genuinely fits none of these.

### Two folders people confuse

- **`Skills/<Cat>/<name>/`** — the skill itself. This LEAF folder is the unit that gets copied into an agent's skills directory; it must be **self-contained and portable** (category level is a repo convenience, not part of the skill).
- **`Resources/Skill-Data/<Cat>/<name>/`** — bulky supporting material *about* a skill (example runs, screenshots, sample reports, design notes). Keep it here, **not** inside the skill folder, so the portable skill stays lean. The Skill-Data tree mirrors the `Skills/` category/name path exactly.
- Inside a skill: **`evals/`** = tracked test cases (committed); **`reports/`** = local run output (gitignored). Never mix them up.

---

## Anatomy of a `SKILL.md`

```markdown
---
name: skill-name
description: One line that tells the agent WHEN to load this. Lead with capability, then triggers.
---

Instructions the agent loads on invocation…
```

- **`name`** — kebab-case, unique across the repo, and **must match the leaf folder name**. (Legacy exception: `News-Images` is PascalCase. Existing names are authoritative — don't rename without cause; prefer kebab-case for anything new. Mike suffixes some personal skills with `-mfs`, e.g. `readme-builder-mfs`.)
- **`description`** — the single most important line: the agent reads *only* this to decide whether to load the skill. State the trigger conditions explicitly ("Use when…", "Use whenever the user wants to…"). A vague description = a skill that never auto-invokes. May use YAML block scalar (`>-`) when long.
- **Body** — loaded only after invocation, so it can be detailed. Aim for: **purpose → when-to-use → principles → a concrete execution checklist → explicit anti-patterns.** Concrete examples beat abstract advice. Must be **self-contained** — the agent won't have the surrounding conversation when the skill loads; don't reference "as discussed above" or repo state that isn't stated in the skill.

**Reference implementations to match:** [`readme-builder-mfs`](./Skills/Documentation/readme-builder-mfs/SKILL.md) (clean frontmatter + when-to-use + principles + checklist + anti-patterns), and [`recipe-validator`](./Skills/Cooking/recipe-validator/SKILL.md) (a **hybrid** skill: a deterministic `scripts/` scanner does the repeatable checks, `references/` hold the standards, the body applies judgment).

---

## Standing instructions (keep things in sync)

Whenever you **add, rename, remove, or recategorize a skill**, update *all* of:

1. **`README.md`** → the matching category table (create the `### Category` section if new). Row = linked skill name + one-line description.
2. **`Docs/SKILL-IDEAS.md`** → if the skill came from the backlog, remove/strike its idea row.
3. **The leaf folder name, the `name:` frontmatter, and the `Resources/Skill-Data/` mirror path** must all agree.

For a **new category**, also mention it in `README.md`'s "Structure" prose and (if relevant) `Docs/USING-SKILLS.md`.

The public **`README.md`** and **`Docs/`** are the source of truth for *what skills exist and how to use them* — never let them drift from the actual `Skills/` tree.

---

## Authoring a new skill

1. Create `Skills/<Category>/<skill-name>/SKILL.md` in the fitting category (or a new one).
2. Write frontmatter: unique kebab-case `name` (== folder), and a trigger-rich `description` (capability first, then "Use when…").
3. Write the body: purpose, when-to-use, principles, a concrete step-by-step checklist, and explicit anti-patterns. Keep it self-contained.
4. Add optional assets only if they earn their place: `scripts/` for deterministic/repeatable work, `references/` for standards the body cites, `prompts/` for templates, `evals/` for tracked test cases. Put bulky examples/screenshots under `Resources/Skill-Data/<Category>/<skill-name>/`, not in the skill.
5. Update `README.md` (+ `SKILL-IDEAS.md`) per the standing instructions above.
6. The `/skill-writer` skill (available in this environment) is the canonical guide for authoring — prefer it for structure/frontmatter questions.

**Good skill candidates** are narrow, repeatable tasks with a clear "done" state — the thing you'd otherwise re-explain every time. "Be a good engineer" is too broad to be a skill.

---

## Validating a skill

When asked to validate / review / audit skills, check:

- **Frontmatter** — parses as YAML; `name` present, kebab-case, unique, and equal to the leaf folder name; `description` present and **trigger-rich** (would the agent know *when* to load it from the description alone?).
- **Portability** — the leaf `<skill-name>/` folder is self-contained: no reference to conversation state, and any `scripts/`/`references/`/`prompts/` it cites actually exist at the paths named in the body.
- **Body quality** — has when-to-use, principles, a concrete checklist, and anti-patterns; no dangling "see above"; examples are concrete.
- **Scripts** — run on Windows with the repo's Python; paths are relative to the skill; no hardcoded secrets or machine-specific absolute paths.
- **Sync** — the skill appears in `README.md`'s category table; no stale row points at a moved/removed skill.
- **Live test** — invoke `/<skill-name>` on a real task and confirm the output follows the skill's own rules. Then test **auto-invocation**: phrase a request that should match the `description` and see whether the agent loads it unprompted; if not, tighten the description's trigger wording.

There is no repo-wide test runner. Skill-specific `evals/` (e.g. `recipe-validator/evals/evals.json`) define that skill's test cases — use them when validating that skill.

---

## Conventions & hygiene

- **Windows-first.** PowerShell 7+ for shell work; forward slashes in paths/JSON work fine. Invoke Python scripts explicitly (`python skills/<name>/scripts/<script>.py …`).
- **Markdown.** These docs target both GitHub and Obsidian rendering — pure native markdown, GitHub-style callouts (`> [!NOTE]`), diagrams sparingly and only when they earn their place, never by default (matches the `readme-builder-mfs` philosophy).
- **Never commit:** secrets (`.env*`, `*.key`), OS cruft, and per-skill `reports/` run output (all covered by `.gitignore` — verify before committing).
- **Git.** Remote is `michaelschecht/My-Custom-Skills`, branch `main`. Commit/push **only when Mike asks.** Imperative-mood subjects matching the existing log ("Organize skills into category folders"). Small, focused commits.
- **Read before editing.** Match the style and structure of the skill/doc you're changing. When a task targets one skill, read its `SKILL.md` (and its `references/`) first.

---

## When in doubt

- On skill structure/authoring: read [`Docs/USING-SKILLS.md`](./Docs/USING-SKILLS.md), then the reference skills above, or use `/skill-writer`.
- On what to build next: [`Docs/SKILL-IDEAS.md`](./Docs/SKILL-IDEAS.md).
- On where a skill lives / how it's grouped: [`README.md`](./README.md) is the index of record.
- For ambiguous tasks (which category, rename vs new skill, edit vs review), ask one clarifying question rather than guess — a wrong assumption here means a multi-file rename.
