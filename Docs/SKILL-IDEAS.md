# Skill Ideas

A running backlog of candidate skills to build. Move an idea into the [Skills table](../README.md) once it ships.

> [!NOTE]
> These are unbuilt ideas, not existing skills. Add, refine, or strike through entries freely.

## Backlog

| Idea | What it would do |
|:---|:---|
| **repo-doc-structure** | Scaffold a repo's documentation layout — standard `docs/` tree, README/CONTRIBUTING/CHANGELOG stubs, and a consistent structure across projects. _(Category: Github.)_ |
| **commit-msg-mfs** | Write clean, imperative-mood commit messages matched to a repo's existing log style (conventional vs. plain). |
| **changelog-keeper** | Maintain a `CHANGELOG.md` in Keep-a-Changelog format from a range of commits. |
| **obsidian-note-mfs** | Author Obsidian-flavored notes with correct frontmatter, wikilinks, callouts, and tags for the AI Lab vault. |
| **pr-describer** | Generate a structured pull-request description (summary, changes, test plan) from a diff. |
| **env-doctor** | Audit a repo for missing `.env.example` entries and undocumented environment variables. |
| **api-reference-mfs** | Produce REST/endpoint reference docs from route definitions, using consistent envelope conventions. |

## Notes on scope

Good skill candidates are **narrow, repeatable tasks with a clear "done" state** — the kind of thing you'd otherwise re-explain to the agent every time. If an idea is really "be a good engineer," it's too broad to be a skill.

Before building, check the existing [`repo-builder-mfs`](../Skills/Documentation/repo-builder-mfs/SKILL.md) skill for structure. See [`USING-SKILLS.md`](./USING-SKILLS.md) for the authoring workflow.
