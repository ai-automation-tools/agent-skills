# repo-builder-mfs — Examples

Reference exemplars for the [`repo-builder-mfs`](../../../../../Skills/Documentation/repo-builder-mfs/SKILL.md) skill.

## Contents

| Example | What it shows |
|:---|:---|
| [**Target layout**](./target-layout.md) | The end-state of a fully built web-app repo — a clean root, all web/app artifacts under `src/`/`site/`, and the linked README index tree the three composed skills produce. |

## The three composed skills

`repo-builder-mfs` doesn't restate its parts' rules — it orchestrates them. Each has its own Skill-Data folder beside this one:

| Skill | Owns | Skill-Data |
|:---|:---|:---|
| [**readme-builder-mfs**](../../../../../Skills/Documentation/readme-builder-mfs/SKILL.md) | The root README end to end (hero + body + footer). | [`../readme-builder-mfs/`](../../readme-builder-mfs/README.md) |
| [**readme-header-mfs**](../../../../../Skills/Documentation/readme-header-mfs/SKILL.md) | The centered header atop every non-root README. | [`../readme-header-mfs/`](../../readme-header-mfs/README.md) |
| [**repo-docs-mfs**](../../../../../Skills/Documentation/repo-docs-mfs/SKILL.md) | The recursive README index tree (topology). | [`../repo-docs-mfs/`](../../repo-docs-mfs/README.md) |
