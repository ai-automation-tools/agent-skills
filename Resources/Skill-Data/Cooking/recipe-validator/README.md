# recipe-validator — Skill-Data

Example outputs and supporting material for the [`recipe-validator`](../../../../Skills/Cooking/recipe-validator/SKILL.md) skill. These are demonstrations, not inputs the skill reads at runtime.

## Contents

| Path | What it is |
|:---|:---|
| `Examples/Example-Report-1/recipe-validation-report_2026-07-08.md` | A full-corpus validation report (192 recipes) produced by the skill — the shape a batch run should output, ranked by severity with verdicts. |
| `Examples/Example-Report-1/scan_2026-07-08.json` | The raw scanner JSON that report was judged from — output of `scripts/scan_recipes.py`. |

## Notes

- These are **reference outputs** kept for demonstration. Live runs write to the skill's own gitignored `reports/` folder, not here.
- Example-Report-1 also documents a scanner-hardening iteration (false-positive classes moved from warnings to notes), so it doubles as a record of how the skill's scanner + references were tuned.
