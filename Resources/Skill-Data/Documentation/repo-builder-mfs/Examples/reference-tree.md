# Reference tree — `Acme-Dashboard`

The `Acme-Dashboard` repo implements **Tiers 1 and 2** of the index tree well, and shows exactly where **Tier 3** is missing. This is the concrete example [`repo-builder-mfs`](../../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) §2 (the documentation tree) is modeled on.

## The tree, annotated tier by tier

```
Acme-Dashboard/
├── README.md ......................... TIER 1  (root index — full logo hero)
│     └─ "What's in here" table links DOWN to each top-level folder README:
│           src/ · prisma/ · infra/ · docs/ · tests/
│
├── src/README.md ..................... TIER 2  (code-folder index)
├── prisma/README.md .................. TIER 2
├── infra/README.md ................... TIER 2
├── tests/README.md ................... TIER 2  (+ tests/e2e, tests/load READMEs)
│
└── docs/
    ├── README.md ..................... TIER 2  (the documentation HUB / map)
    │     └─ "Sections" table links DOWN to each docs sub-folder:
    │           architecture/ · api/ · security/ · planning/
    │
    ├── architecture/ ................. ❌ NO README  ← Tier 3 MISSING
    │     ├── overview.md                  hub links straight past the folder
    │     ├── data-model.md                to overview.md — the folder itself
    │     └── local-setup.md               is a dead end when opened
    │
    ├── api/ ......................... ❌ NO README  ← Tier 3 MISSING
    │     └── reference.md
    │
    ├── security/ ................... ❌ NO README  ← Tier 3 MISSING
    │     └── overview.md
    │
    └── planning/
          ├── INDEX.md ............... ✅ TIER 3 present (named INDEX.md, not README.md)
          └── All/                        links down to the numbered strategy docs
```

## What's right

- **Tier 1** — the root `README.md` opens with the logo hero and a `| Area | What lives there |` table whose leftmost cells link to `src/README.md`, `prisma/README.md`, `infra/README.md`, `docs/README.md`, `tests/README.md`. Front door → each top-level folder. ✅
- **Tier 2** — `docs/README.md` is the hub, with a `| Section | What's inside |` table linking to each docs sub-folder. It also carries an up-link footer back to the repository root. ✅

## Where the chain breaks (Tier 3)

`docs/README.md` links `architecture/` **straight to `architecture/overview.md`**, because `docs/architecture/` has **no `README.md`** — it just holds `overview.md`, `data-model.md`, and `local-setup.md` with no index. Same for `api/` and `security/`. Only `planning/` has its own index (and it's named `INDEX.md`).

The consequences the skill flags:

- Opening the `architecture/` folder shows a bare file list — **no index, a dead end.**
- The hub is forced to **link past the folder** to one hand-picked document, so the reader never sees the section as a unit or discovers `data-model.md` / `local-setup.md` from the map.

## The fix

Give each multi-document sub-folder its own Tier-3 `README.md`, then repoint the hub at the index instead of the leaf:

```diff
- | [**🧱 architecture/**](architecture/overview.md) | System overview, data model, local setup. |
+ | [**🧱 architecture/**](architecture/README.md)   | System overview, data model, local setup. |
```

See [`tier3-architecture-README.md`](./tier3-architecture-README.md) for the completed index that closes the chain `root → docs/README → architecture/README → overview.md`.
