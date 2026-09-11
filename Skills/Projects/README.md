<h1 align="center">🗂️ Project skills</h1>

<p align="center">
  <em>Additional skills for one repo in the <strong>ai-automation-tools</strong> org —<br>
  an overlay on top of the skills that repo already owns, not a copy of them.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/tier-project-8B5CF6?style=for-the-badge" alt="Project tier">
  <img src="https://img.shields.io/badge/scope-per--repo-0078D4?style=for-the-badge" alt="Per-repo scope">
  <a href="../Core/"><img src="https://img.shields.io/badge/↔-Core_skills-2ea44f?style=for-the-badge" alt="Core skills"></a>
  <a href="../../README.md"><img src="https://img.shields.io/badge/↩-repository_root-6B7280?style=for-the-badge" alt="Repository root"></a>
</p>

---

## 🧪 The test

One question decides which tier a skill belongs in:

> **Would you invoke this from a repo other than the one it was written for?**

**Yes → [`Skills/Core/`](../Core/).** It is portable, and it goes to user scope where every
session can reach it. `project-hub-scaffold` lives in Core for exactly this reason — you run it
from whatever repo is *getting* a hub, never from `project-hub` itself.

**No → here.** It names one codebase's files, commands, schema, or protocol. Installing it
globally would put six irrelevant skills in your catalog every time you opened an unrelated repo.

The test is about **where you invoke it**, not what it is about. A skill can be *about* one
project and still be Core if you reach for it from outside.

## ➕ These are additional, not a mirror

**Every org repo keeps its own skills.** What lives here is a second, additive layer on top —
skills that belong to a project but were never part of that repo's own set.

| | Lives | Who owns it |
|:---|:---|:---|
| **Shipped** | `<repo>/skills/` | The repo. Product surface — what a consumer of the app gets |
| **Maintainer** | `<repo>/.claude/skills/` *(tracked in git)* | The repo. For contributors working on that codebase |
| **Additional** | **here**, `Skills/Projects/<repo>/` | This repo. Installed as an overlay, on top of both |

So this is not a place to move a repo's skills to, and nothing here replaces one. A repo's own
skills stay in that repo and are edited there.

> [!WARNING]
> **Skills install flat, so an overlay can clobber.** Publishing a skill named `cronsole` into
> cronsole's `.claude/skills` overwrites whatever already sits at that name. Each project README
> below lists what its repo already ships — **read that list as a name-collision checklist before
> naming a new skill here**, and prefix with the project slug when in any doubt. The install
> script marks each row `New` or `Replaced` so a clobber is visible rather than silent.

### The one genuine duplicate

`project-hub-scaffold` is the exception that proves the rule: it exists in **both** this repo
(as a Core skill) and the `project-hub` repo, byte-identical, with nothing keeping it that way.
There, **this repo is canonical** — edit here, then republish with the install script. Never
hand-edit that copy; the first divergent edit would be silent. That is a one-off to resolve, not
the model for this tier.

## 📂 The projects

The middle column is what each repo **already owns** — names you cannot reuse here. The right
column is what this tier adds on top.

| Project | Already in its own repo (names taken) | Added here |
|:---|:---|:-:|
| [💬 **agent-chat**](./agent-chat/README.md) | 7 conversation-protocol skills + `humanizer`, plus 4 maintainer skills | — |
| [⏱️ **cronsole**](./cronsole/README.md) | `cronsole`, `source-doctor`, a connect-pack, plus 2 maintainer skills | — |
| [📡 **edge-radar**](./edge-radar/README.md) | `edge-radar`, `edge-radar-analysis`, `betting-logic-review`, plus 6 maintainer skills | — |
| [🌐 **project-hub**](./project-hub/README.md) | `project-hub-scaffold` *(duplicate of the Core copy)* | — |
| [📉 **edge-spectrum**](./edge-spectrum/README.md) | none | — |

Each project's README records what already exists in its own repo and the traps that come with
it — a name already claimed twice, a non-`main` default branch, skills that are really slash
commands whose names are a user-facing interface.

## 🧭 Where a project skill installs

Not user scope. **Project skills install into the repo they belong to**, so they load only while
you have that repo open:

```powershell
pwsh scripts/install-skills.ps1 -Project cronsole -Destination <clone>/.claude/skills
```

Several org repos deliberately **track** `.claude/skills/` in git (cronsole's `.gitignore` says
so in as many words), so an install there is a commit other contributors get. That is the point —
but it also means a careless install shows up in someone else's diff. Check what the target repo
tracks before you publish into it.

---

## ➕ Adding a project

1. `mkdir Skills/Projects/<repo-slug>/` and write its `README.md` from any existing one.
2. Mirror the folder under `Resources/Skill-Data/Projects/<repo-slug>/` if it needs examples.
3. Add a row to the table above.

Use the repo's own slug, lowercased — `agent-chat`, not `Agent-chat`. Casing across the org is
inconsistent; this tree is not.

---

<p align="center">
  <a href="../../README.md">← Repo home</a>
  ·
  <a href="../Core/">Core skills</a>
  ·
  <a href="../../Docs/USING-SKILLS.md">Authoring guide</a>
</p>
