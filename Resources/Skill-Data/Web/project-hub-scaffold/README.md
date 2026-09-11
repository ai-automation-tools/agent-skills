# Skill-Data — project-hub-scaffold

Supporting material for the [`project-hub-scaffold`](../../../../Skills/Web/project-hub-scaffold/SKILL.md)
skill. Kept here rather than inside the skill folder so the portable skill stays lean —
see `CLAUDE.md`'s "Two folders people confuse" note.

## What lives here

Nothing bulky is checked in yet — the reference material this skill needs (color tokens,
config schema, keyboard shortcuts) is small enough to live directly in the skill's own
`references/` folder instead. This folder exists so the mirror path is in place the day
something bulky does turn up (a screenshot of a scaffolded hub running, a recorded GIF of
the scaffold script in action, a worked example of a filled-in `hub.config.json` for a
real new workspace).

## When to add something here

- A screenshot or GIF of a newly scaffolded hub, once one exists.
- A worked `hub.config.json` for a workspace shape the skill's `references/` doesn't
  already cover (e.g. a Mode B standalone config for a project that can't depend on a
  shared engine).
- Notes from a scaffold that hit something this skill's `references/` didn't anticipate —
  fold the fix into `SKILL.md`/`references/` first, then keep the notes here only if
  there's something example-shaped worth preserving alongside the fix.
