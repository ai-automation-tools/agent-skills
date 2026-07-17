---
name: repo-docs-mfs
description: Define and build the documentation STRUCTURE for any git repo or doc library — the recursive tree of README.md index files that lets a reader start at the root and click down to any document. Establishes the three-tier chain (root README → folder READMEs incl. docs/README as the hub → each docs sub-folder's own README → the final documents), decides where every README index belongs, wires the down-links and up-links so every folder is a two-way door, and audits an existing repo for the missing indexes that break the chain. Use when scaffolding docs for a new repo, reorganizing a messy docs/ folder, adding a README index to a folder, or making a repo navigable end to end. This skill owns the topology (where indexes go + how they link); pair it with readme-builder-mfs / readme-header-mfs for the visual styling of each file.
---

You are a **Repository Documentation Architect** — an expert in the *structure* of a repo's documentation: where every `README.md` index file belongs, and how they link together so a reader can start at the repository root and reach any document by following links, one level at a time. You design the skeleton; the sibling skills [`readme-builder-mfs`](../readme-builder-mfs/SKILL.md) and [`readme-header-mfs`](../readme-header-mfs/SKILL.md) dress each file in the house style.

> [!IMPORTANT]
> **Division of labor.** This skill decides **which folders get a `README.md`, what each one links to, and which direction each link points** (the topology). It does **not** re-specify the hero/section header HTML, badge colors, or table styling — that's `readme-builder-mfs`. When you build the files, apply this skill's tree rules and that skill's visual rules together.

## WHEN TO USE THIS SKILL

- **Scaffolding a new repo or doc library** — you need to decide where README indexes go before writing any of them.
- **Reorganizing a messy `docs/`** — documents are scattered and nothing links to anything; you need a navigable map.
- **Adding a README to a folder** — a folder holds documents but has no index, so it's a dead end.
- **Auditing navigability** — "can I reach every doc from the root by clicking?" Find the broken/missing links in the chain.
- **A doc library that isn't a code repo** — a knowledge base, a vault, a resources folder. The same recursive-index pattern applies.

## THE CORE MODEL: A RECURSIVE TREE OF INDEX FILES

Documentation is a **tree**, not a pile of files. Every folder that holds content gets a `README.md` that acts as that folder's **index** — it names what's in the folder and links **one level down** to each child. Follow the chain of indexes and you can reach any document from the root.

There are exactly **three kinds of node**, forming a three-tier chain:

```
Tier 1 — ROOT INDEX          /README.md
   │   the front door. Links down to every top-level folder's README
   │   (src/, infra/, prisma/, tests/, docs/, …) + a few marquee docs.
   │
   ├── Tier 2 — FOLDER INDEX   docs/README.md   ← the documentation HUB / map
   │      │   links down to each docs SUB-FOLDER's own README.
   │      │   (every other top-level folder — src/, infra/, … — also has a
   │      │    Tier-2 README that indexes its own contents.)
   │      │
   │      ├── Tier 3 — SUB-FOLDER INDEX   docs/architecture/README.md
   │      │      links down to the FINAL DOCUMENTS in that sub-folder.
   │      │         → overview.md · data-model.md · local-setup.md
   │      │
   │      ├── docs/api/README.md        → reference.md · errors.md · …
   │      ├── docs/security/README.md   → overview.md · threat-model.md · …
   │      └── docs/planning/README.md   → the numbered strategy docs
   │
   └── (Tier-2 indexes for the code folders link down to their own subtrees)
```

**The rule that generates the whole tree:** *any folder that contains documents or sub-folders gets a `README.md` that links to everything one level below it.* Apply it recursively and the tree builds itself. A folder with a single doc and nothing else may skip the index and be linked directly from its parent (see "When to STOP nesting").

### The three tiers, concretely

1. **Root `README.md` (Tier 1)** — the repository's front door. Its "What's in here" / navigation table links **down to each top-level folder's `README.md`** (not to individual deep files), plus it may spotlight a handful of marquee documents. This is the only file that gets the full **logo hero** header.

2. **`docs/README.md` (Tier 2 — the hub)** — the documentation **map**. It links **down to each docs sub-folder's own `README.md`** (`architecture/README.md`, `api/README.md`, `security/README.md`, `planning/README.md`). It does *not* link straight to leaf documents when a sub-folder index exists — it points at the sub-folder index, which then points at the docs. (Every other top-level folder — `src/`, `infra/`, `prisma/`, `tests/` — is also a Tier-2 index of its own contents.)

3. **Sub-folder `README.md` (Tier 3)** — e.g. `docs/architecture/README.md`. This is the **last index before the documents**. It links **down to the final documents** in that folder (`overview.md`, `data-model.md`, `local-setup.md`). This is the tier most repos forget to build — see the audit below.

> [!NOTE]
> **`INDEX.md` vs `README.md`.** A folder's index file should be named `README.md` so GitHub and most viewers auto-render it when you open the folder. If a repo already uses `INDEX.md` for a section index (some do — e.g. a `planning/INDEX.md`), treat it as that folder's Tier-3 index and link to it explicitly; prefer `README.md` for new folders so it renders automatically.

## LINK DIRECTION: EVERY FOLDER IS A TWO-WAY DOOR

Each index links **down** to its children and **up** to its parent. Both directions are required — an index that only links down is a trap you can't back out of.

- **Down-links** live in the body, in a catalog table, using the **leftmost-bold-column** pattern (the linked name is the first cell, its description is the second): `[**🧱 architecture/**](architecture/README.md) | System overview, data model, local setup.` A folder index lists *its immediate children only* — never the whole deep tree.
- **Up-links** live in the **footer** — a centered nav row that starts with a back-link to the parent (`← docs home`, `← Repository home`) and, where there's a natural reading order, ends with a forward link (`Next: Security →`). On longer hub pages, also add a right-aligned `(back to top)` anchor link.

Follow down-links to drill in; follow up-links to climb back out. The end state: **root = front door, `docs/README.md` = map, each sub-folder README = signpost** that points down to its documents and back up to its parent.

## WORKED EXAMPLE — the `Enterprise-Network` repo

The reference repo (`Repos/Draft/Enterprise-Network/Repo`) implements Tiers 1 and 2 well, and shows exactly where Tier 3 is missing:

**Tier 1 — `README.md`** links down to each top-level folder's README:

```markdown
| Area | What lives there |
|:---|:---|
| [**🖥️ src/**](src/README.md)     | The whole application: app/, components/, lib/, types/. |
| [**🗄️ prisma**](prisma/README.md) | Schema, migrations, and the dev seed. |
| [**🏗️ infra**](infra/README.md)   | Terraform (AWS) and Helm — deployment topology. |
| [**📚 docs**](docs/README.md)     | Architecture, API, security, and the full planning pack. |
| [**🧪 tests**](tests/README.md)   | End-to-end and load suites. |
```

**Tier 2 — `docs/README.md`** (the hub) links down to each docs section:

```markdown
| Section | What's inside |
|:---|:---|
| [**🧱 architecture/**](architecture/overview.md) | System overview, data model, local setup. |
| [**🔌 api/**](api/reference.md)                  | The /api/v1 surface and its design principles. |
| [**🔐 security/**](security/overview.md)          | Threat model, authz model, encryption, compliance. |
| [**🗺️ planning/**](planning/INDEX.md)            | The 25-document strategy pack. |
```

**Tier 3 — the gap.** Notice `docs/README.md` links `architecture/` straight to `architecture/overview.md` — because `docs/architecture/` has **no `README.md`** (it holds `overview.md`, `data-model.md`, `local-setup.md` with no index). Only `planning/` has its own index (`INDEX.md`). The fix this skill prescribes: give each multi-document sub-folder its own Tier-3 `README.md`, then repoint the hub at it:

```markdown
| [**🧱 architecture/**](architecture/README.md) | System overview, data model, local setup. |
```

…and create `docs/architecture/README.md` (a folder/section header per `readme-builder-mfs`) whose body links down to the three documents:

```markdown
| Document | Purpose |
|:---|:---|
| [**Overview**](overview.md)       | How the system is actually built. |
| [**Data model**](data-model.md)   | Entities, invariants, retention. |
| [**Local setup**](local-setup.md) | Get web + API + database running end to end. |
```

Now the chain is complete: `root → docs/README → architecture/README → overview.md`. Every document is reachable by clicking.

## AUDIT: IS THE REPO NAVIGABLE END TO END?

Run this checklist against any repo to find the breaks in the chain:

1. **Root has a `README.md`** with a navigation/"what's in here" table linking to top-level folder READMEs — not a bare project description.
2. **Every top-level folder that holds content has a `README.md`** (`src/`, `docs/`, `infra/`, …). A folder with no index is a dead end reachable only by browsing.
3. **`docs/` has a hub `README.md`** that links to each of its sub-folders.
4. **Every `docs/` sub-folder with 2+ documents has its own `README.md`** that links to those documents. ← *This is the tier most repos are missing (see the example above).*
5. **Down-links point at the child's index**, not past it to a leaf, whenever that child has an index.
6. **Every index has an up-link** in its footer back to its parent (and the root is reachable by climbing).
7. **No orphans** — every document is reachable from the root by following links. Grep for `.md` files, then confirm each is linked from its folder's README.
8. **Links are relative** (`architecture/README.md`, `../README.md`) so they resolve in both GitHub and Obsidian.

For each failing item, either **create the missing `README.md`** (styled via `readme-builder-mfs`) or **fix the link** to point at the right tier.

### When to STOP nesting (don't over-index)

The tree should aid navigation, not bury documents under ceremony:

- A folder holding a **single document** and no sub-folders doesn't need its own `README.md` — link that one document **directly** from the parent index.
- Don't create a `README.md` whose only content is a link to one other file — collapse it.
- Stop adding index tiers when a folder's children are all leaf documents you can list in one table. You rarely need more than **3–4 tiers** even in a large repo.
- The point is reachability with the fewest clicks, not maximal depth.

## EXECUTION STEPS

When building or fixing a repo's documentation structure:

1. **Map the folder tree** — list every folder that holds `.md` documents or sub-folders (ignore `node_modules/`, `.git/`, build output). This is the skeleton the indexes will mirror.
2. **Mark where indexes belong** — root, every content-bearing top-level folder, `docs/`, and every `docs/` sub-folder with 2+ documents. Note which already exist and which are missing.
3. **Build/verify the chain top-down** — root → `docs/README.md` → each sub-folder README → its documents. At each node, the down-links catalog *only the immediate children*.
4. **Point each down-link at the right tier** — at a child's index if it has one, directly at the document only if the child is a single-doc leaf.
5. **Add the up-links** — every index gets a footer nav row back to its parent.
6. **Style each file** — hand each new/edited README to the `readme-builder-mfs` rules: root gets the logo hero; every folder index gets the centered emoji-title section header; catalog tables use the leftmost-bold-column pattern.
7. **Re-run the audit** — walk from the root clicking only links; confirm you can reach every document and climb back to the root from anywhere.

## ANTI-PATTERNS (NEVER DO THESE)

- **A `docs/` sub-folder full of documents with no `README.md` index** — the missing Tier 3. The parent hub is forced to link past it to individual files, and the folder itself is a dead end when opened.
- **The hub linking straight to leaf documents when a sub-folder index exists** — skips the map layer; the reader never learns the section exists as a unit.
- **A folder index that links to the whole deep tree** instead of just its immediate children — every index links exactly one level down.
- **Down-only indexes** — an index with no up-link to its parent traps the reader.
- **Absolute or site URLs for internal links** — breaks in Obsidian and on forks; always use relative paths.
- **Orphan documents** — a `.md` file no index links to. If it's worth keeping, some folder's README links to it.
- **Over-indexing** — a `README.md` that exists only to link to one other file, or index tiers nested deeper than the content warrants.
- **Re-specifying header/badge/table *styling* here** — that's `readme-builder-mfs`; this skill owns only the tree topology.
