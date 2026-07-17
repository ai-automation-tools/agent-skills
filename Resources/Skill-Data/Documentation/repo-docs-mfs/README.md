# repo-docs-mfs — Skill-Data

## What the skill does

[`repo-docs-mfs`](../../../../Skills/Documentation/repo-docs-mfs/SKILL.md) defines and builds the documentation **structure** for any git repo or doc library — the recursive tree of `README.md` index files that lets a reader start at the repository root and click **down** to any document: root README → `docs/` hub → each sub-folder's own README → the final documents, with **up-links** in every footer so each folder is a two-way door. It owns the *topology* (where indexes go + how they link) and pairs with its sibling skills `readme-builder-mfs` / `readme-header-mfs`, which own the *visual styling* of each file.

## About this folder

Reference exemplars for the skill — the annotated three-tier tree it prescribes, and a filled-in Tier-3 index that completes a broken chain. Modeled on the real `Enterprise-Network` repo (`Repos/Draft/Enterprise-Network/Repo`), where Tiers 1–2 are built and Tier 3 is the missing piece the skill fixes.

## Contents

| Path | What it is |
|:---|:---|
| [`Examples/`](./Examples/README.md) | The annotated reference tree plus a completed Tier-3 sub-folder index. |

These are reference exemplars of the target structure — not files the skill loads at runtime.
