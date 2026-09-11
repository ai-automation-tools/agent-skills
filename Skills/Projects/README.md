<h1 align="center">🗂️ Project skills</h1>

<p align="center">
  <em>Skills welded to one repo in the <strong>ai-automation-tools</strong> org —<br>
  they name that repo's files, schema, or protocol, so they mean nothing anywhere else.</em>
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

## 📂 The projects

| Project | Skills in the org today | Where they ship from |
|:---|:---|:---|
| [💬 **agent-chat**](./agent-chat/README.md) | 7 conversation-protocol skills + `humanizer` | `Agent-chat/skills/` |
| [⏱️ **cronsole**](./cronsole/README.md) | `cronsole`, `source-doctor`, + a connect-pack | `cronsole/skills/` and `backend/src/tools/` |
| [📡 **edge-radar**](./edge-radar/README.md) | `edge-radar`, `edge-radar-analysis`, `betting-logic-review` | `Edge-Radar/skills/` |
| [🌐 **project-hub**](./project-hub/README.md) | — (`project-hub-scaffold` is Core) | `project-hub/Skills/` *(travel copy)* |
| [📉 **edge-spectrum**](./edge-spectrum/README.md) | none | — |

Each project's README records what already exists in its own repo and the traps that come with
it — a name collision, a non-`main` default branch, skills that are really slash commands.

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

## 🔁 Canonical here, published there

Where a skill exists both here and in its project repo, **this repo is canonical.** The copy over
there is a travel copy so the skill works for someone who cloned only that repo.

There is no automatic sync, and that is the known failure mode — `project-hub-scaffold` was
already byte-identical in two repos with nothing keeping it that way, and the first divergent
edit would have been silent. So: **edit here, then republish with the install script.** Never
hand-edit a published copy.

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
