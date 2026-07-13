# recipe-validator — Skill-Data

## What the skill does

[`recipe-validator`](../../../../Skills/Cooking/recipe-validator/SKILL.md) validates food recipes for **safety** and **quality**. It checks safe cooking temperatures and dangerous ingredients/techniques (food safety); per-serving sodium, saturated fat, and added sugar against health standards; ingredient quantities and ratios versus comparable recipes; allergen-labeling completeness; and overall recipe coherence — then reports findings **ranked by severity with concrete fixes**, for a single recipe or a whole folder. It's a *hybrid* skill: a deterministic `scripts/scan_recipes.py` does the repeatable checks, the `references/` hold the standards, and the skill body applies judgment.

## About this folder

Example outputs and supporting material for the skill. These are demonstrations, not inputs the skill reads at runtime.

## Contents

| Path | What it is |
|:---|:---|
| `Examples/Example-Report-1/recipe-validation-report_2026-07-08.md` | A full-corpus validation report (192 recipes) produced by the skill — the shape a batch run should output, ranked by severity with verdicts. |
| `Examples/Example-Report-1/scan_2026-07-08.json` | The raw scanner JSON that report was judged from — output of `scripts/scan_recipes.py`. |

## Notes

- These are **reference outputs** kept for demonstration. Live runs write to the skill's own gitignored `reports/` folder, not here.
- Example-Report-1 also documents a scanner-hardening iteration (false-positive classes moved from warnings to notes), so it doubles as a record of how the skill's scanner + references were tuned.
