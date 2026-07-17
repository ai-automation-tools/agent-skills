# Tier-3 index (the fix) — `docs/architecture/README.md`

This is the **missing sub-folder index** from the [reference tree](./reference-tree.md): a complete `docs/architecture/README.md` for the `Enterprise-Network` repo. It's the last index before the documents — it links **down** to the final docs in the folder and **up** to the `docs/` hub, closing the chain `root → docs/README → architecture/README → overview.md`.

Structure is what `repo-docs-mfs` owns; the header + table *styling* below follows [`readme-builder-mfs`](../../../../../Skills/Documentation/readme-builder-mfs/SKILL.md) (centered emoji-title section header, leftmost-bold-column table, centered up-link footer).

---

```markdown
<h1 align="center">🧱 Architecture</h1>

<p align="center">
  <em>How the Enclave system is actually built — the shape, the data, and how to run it locally.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/scope-system_design-8B5CF6?style=for-the-badge" alt="Scope: system design">
  <a href="../README.md"><img src="https://img.shields.io/badge/↩-docs_home-6B7280?style=for-the-badge" alt="Docs home"></a>
</p>

---

## 📄 Documents

| Document | Purpose |
|:---|:---|
| [**Overview**](overview.md)       | The shape of the system: one Next.js app, the policy engine, the seams. |
| [**Data model**](data-model.md)   | Entities, invariants, and retention — mirrors the Prisma schema. |
| [**Local setup**](local-setup.md) | Get web + API + database running end to end. |

---

<p align="center">
  <a href="../README.md">← docs home</a> ·
  <a href="../api/README.md">API</a> ·
  <a href="../security/README.md">Next: Security →</a>
</p>
```

---

## Why this completes the tree

- **Links down** to all three documents in the folder — not just the one the hub happened to pick — so every doc is reachable and the section reads as a unit.
- **Links up** in the footer (`← docs home`) and sideways to sibling sections, so the folder is a two-way door.
- The `docs/README.md` hub now points at **`architecture/README.md`** (this file), not past it — the map layer is preserved at every level.

Apply the same pattern to `docs/api/README.md` and `docs/security/README.md`, and the whole repo becomes navigable end to end by clicking.
