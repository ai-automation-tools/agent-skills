# repo-builder-mfs — Skill-Data

## What the skill does

[`repo-builder-mfs`](../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) is the **end-to-end repo builder** — it scaffolds or reorganizes a whole git repo, project folder, doc library, or Obsidian vault so it's professional and navigable top to bottom, by **composing three skills**: the root README follows [`readme-builder-mfs`](../../../../Skills/Documentation/readme-builder-mfs/SKILL.md) (logo hero + full body), every other README follows [`readme-header-mfs`](../../../../Skills/Documentation/readme-header-mfs/SKILL.md) (centered emoji-title section header) with a `readme-builder-mfs` body/footer, and the docs structure follows [`repo-docs-mfs`](../../../../Skills/Documentation/repo-docs-mfs/SKILL.md) (the recursive README index tree). It adds the layout rule that ties them together: for a **web-app** repo, all web/app artifacts live under `src/` (framework apps) or `site/` (static sites), never scattered at the repo root.

## About this folder

Reference exemplars for the skill — the target end-state layout of a fully built repo. Modeled on the real `Enterprise-Network` repo (`Repos/Draft/Enterprise-Network/Repo`), whose Next.js app lives under `src/` and whose docs form the root → hub → section tree.

## Contents

| Path | What it is |
|:---|:---|
| [`Examples/`](./Examples/README.md) | An annotated target layout for a web-app repo — clean root, app artifacts under `src/`/`site/`, and the linked README index tree the three composed skills produce. |

These are reference exemplars of the target structure — not files the skill loads at runtime. For the component skills' own examples, see their Skill-Data folders alongside this one.
