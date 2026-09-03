# repo-builder-mfs — Examples

Reference exemplars for the [`repo-builder-mfs`](../../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) skill, grouped by the concern each one illustrates. These are exemplars of the target look and structure, not runtime inputs.

## 🎨 Header blocks (house style)

Worked hero-header blocks in the target style — the exemplars the header pattern (SKILL.md §3) is modeled on. Each `.md` is the raw header block only (top anchor through the closing `---`).

| Example | Source repo | Notable traits |
|:---|:---|:---|
| [**taskhub-header.md**](./taskhub-header.md) | `taskconsole` | `MVP_Prototype` amber status; six-badge tech row (React · TS · Node · .NET · Postgres · theme). |
| [**agent-chat-header.md**](./agent-chat-header.md) | `agent-arena` | `experimental` amber status; `View Demo` nav; MCP/SQLite/Python stack. |
| [**ai-automation-library-header.md**](./ai-automation-library-header.md) | `artifact-library` | `View Catalog` nav; `Active` red status; extra descriptive paragraph before the `---`. |

## 🗂️ Docs topology (the README index tree)

The recursive index tree the skill prescribes (SKILL.md §2), drawn from a worked `Acme-Dashboard` example.

| Example | What it shows |
|:---|:---|
| [**Reference tree**](./reference-tree.md) | The `Acme-Dashboard` docs tree annotated tier by tier — where the index files sit, which link down to what, and exactly where Tier 3 is missing. |
| [**Tier-3 index (the fix)**](./tier3-architecture-README.md) | A completed `docs/architecture/README.md` — the missing sub-folder index that links down to the final documents and closes the `root → docs → architecture → overview.md` chain. |

## 🏗️ Repo layout

The clean-root rule (SKILL.md §1) applied end to end.

| Example | What it shows |
|:---|:---|
| [**Target layout**](./target-layout.md) | The end-state of a fully built web-app repo — a clean root, all web/app artifacts under `src/`/`site/`, and the linked README index tree. |

---

<p align="center">
  <a href="../README.md">← repo-builder-mfs Skill-Data home</a>
</p>
