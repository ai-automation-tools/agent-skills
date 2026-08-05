# repo-builder-mfs — Skill-Data

## What the skill does

[`repo-builder-mfs`](../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) is the **end-to-end repo builder** — it scaffolds or reorganizes a whole git repo, project folder, doc library, or Obsidian vault so it's professional and navigable top to bottom. It covers three concerns in one skill:

| Concern | What it governs |
|:---|:---|
| **Repo layout** | For a web-app repo, all web/app artifacts live under `src/` (framework apps) or `site/` (static sites), never scattered at the root. The root stays documentation + meta + required config. |
| **Docs topology** | The recursive tree of `README.md` index files — root → `docs/` hub → each sub-folder README → the final documents — wired with down-links and up-links so every folder is a two-way door. Plus the navigability audit. |
| **House style** | The logo hero atop a repo-root README, the centered emoji-title section header atop every other README, the body, the leftmost-link catalog tables, and the footer — all GitHub + Obsidian safe. |

> [!NOTE]
> This skill absorbed three earlier ones — `readme-builder-mfs`, `readme-header-mfs`, and `repo-docs-mfs` — on 2026-08-05. Their exemplars were merged into this folder; nothing was dropped.

## About this folder

Reference exemplars for the skill: real header blocks captured from live repos, the annotated docs-tree structure, the target end-state layout of a fully built repo, and rendered screenshots of the README style it produces. The tree and layout exemplars are modeled on the real `Enterprise-Network` repo (`Repos/Draft/Enterprise-Network/Repo`), whose Next.js app lives under `src/` and whose docs form the root → hub → section tree.

## Contents

| Path | What it is |
|:---|:---|
| [`Examples/`](./Examples/README.md) | Six exemplars — three real hero-header blocks, the annotated three-tier docs tree, a completed Tier-3 index, and the target web-app repo layout. |
| `Images/Screenshots/` | Rendered examples of README sections the skill builds (header, tables, install, links, resources, etc.). |
| `Images/GIFs/` | Animated social-preview / demo assets. |

These are reference exemplars of the target look and structure — not files the skill loads at runtime.
