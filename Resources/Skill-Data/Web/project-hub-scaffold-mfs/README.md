# Skill-Data — project-hub-scaffold-mfs

Supporting material for the [`project-hub-scaffold-mfs`](../../../../Skills/Web/project-hub-scaffold-mfs/SKILL.md)
skill. Kept here rather than inside the skill folder so the portable skill stays lean —
see `CLAUDE.md`'s "Two folders people confuse" note.

## What lives here

Nothing bulky is checked in yet — the reference material this skill needs (color tokens,
config schema, keyboard shortcuts) is small enough to live directly in the skill's own
`references/` folder instead. This folder exists so the mirror path is in place the day
something bulky does turn up (a screenshot of a fourth hub running, a recorded GIF of the
scaffold script in action, a worked example of a filled-in `hub.config.json` for a real
new workspace).

## The live example, for now

The three running hubs this skill is modeled on **are** the worked example — read them
directly rather than a frozen copy here, since a copy would drift the next time the
shared engine changes:

| What | Where |
|:---|:---|
| The shared engine (source of truth for the design system + config schema) | `D:\AI_Agents\Documents\My-Documents\My-IT-Tools\HTML-Project-Design\Hub\` |
| Three real `hub.config.json` examples, one per repo shape (`Repos/<group>/`, flat `Repos/`, flat `Repos/`) | `Project-Hub\`, `Project-Hub-IAM\`, `Project-Hub-Finance\` under the same folder |
| Screenshots of the design (pre-build mockups, kept as history — the running app is authoritative if these ever disagree) | `Images\AI-Lab-Design\` and `Images\Screenshots\` under the same folder |
| The audit history — every defect found and fixed, in order, with what was verified | `Docs\ROADMAP.md` under the same folder |

## When to add something here

- A screenshot or GIF of a newly scaffolded (fourth+) hub, once one exists.
- A worked `hub.config.json` for a workspace shape the three existing examples don't
  cover (e.g. a Mode B standalone config for a project outside this machine).
- Notes from a scaffold that hit something this skill's `references/` didn't anticipate —
  fold the fix into `SKILL.md`/`references/` first, then keep the notes here only if
  there's something example-shaped worth preserving alongside the fix.
