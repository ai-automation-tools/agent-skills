#!/usr/bin/env python3
"""
Tests for the deterministic Python helpers that ship inside skills.

Covers skills/core/cooking/recipe-validator/scripts/scan_recipes.py: frontmatter
and table metadata parsing, servings, nutrition thresholds, the allergen
cross-check (including its false-friend masking), the raw-protein doneness check,
the danger patterns, and the CLI end to end over a temp folder of fixture recipes.

The PowerShell helpers (project-hub-scaffold, cronsole-windows-jobs) are covered by
scripts/test-skill-scripts.ps1. Standard library only; exits 1 on any failure.
CI runs it in validate.yml.

Usage:
  python scripts/test-skill-scripts.py
"""
import importlib.util
import json
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SCANNER = REPO / "skills/core/cooking/recipe-validator/scripts/scan_recipes.py"

spec = importlib.util.spec_from_file_location("scan_recipes", SCANNER)
scan = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scan)

failures = []


def check(cond, msg):
    print(("ok   " if cond else "FAIL ") + msg)
    if not cond:
        failures.append(msg)


def run(text, name="recipe.md"):
    return scan.check_recipe(Path(name), text)


def findings(result, category=None, severity=None):
    return [f for f in result["findings"]
            if (category is None or f["category"] == category)
            and (severity is None or f["severity"] == severity)]


def recipe(allergens="[gluten, dairy, egg]", ingredients="- 2 cups flour\n- 1 cup milk\n- 2 eggs",
           instructions="1. Whisk and bake 25 minutes until golden brown.", nutrition=None, yield_="4 servings"):
    fm = "---\n"
    if allergens is not None:
        fm += f"allergens: {allergens}\n"
    if yield_ is not None:
        fm += f"yield: {yield_}\n"
    fm += "---\n"
    body = f"# Test Dish\n\n## Ingredients\n{ingredients}\n\n## Instructions\n{instructions}\n"
    if nutrition:
        body += "\n## Nutrition\n| Nutrient | Amount |\n|---|---|\n" + "\n".join(
            f"| {k} | {v} |" for k, v in nutrition.items()) + "\n"
    return fm + body


# --- parsing helpers -------------------------------------------------------
check(scan.parse_servings("6-8 servings") == 7, "parse_servings: a range resolves to its midpoint")
check(scan.parse_servings("4 servings (12 tacos)") == 4, "parse_servings: the first number wins over trailing counts")
check(scan.parse_servings(None, "**Servings:** 6") == 6, "parse_servings: falls back to an inline Servings line")
check(scan.parse_servings(None, "no yield here") is None, "parse_servings: no number means None")
check(scan.as_list("gluten, soy; egg") == ["gluten", "soy", "egg"], "as_list: an unbracketed scalar splits on , and ;")
check(scan.as_list(["a"]) == ["a"] and scan.as_list(None) == [], "as_list: lists pass through, None is empty")

fields, _ = scan.parse_frontmatter("---\nallergens: [gluten, \"soy\"]\nyield: 4\n---\n# T\n")
check(fields == {"allergens": ["gluten", "soy"], "yield": "4"}, "parse_frontmatter: YAML block with a bracketed list")
fields, _ = scan.parse_frontmatter("| Field | Value |\n|---|---|\n| **allergens** | gluten (tortillas) |\n| **servings** | 4 |\n")
check(fields.get("allergens") == "gluten (tortillas)" and fields.get("yield") == "4",
      "parse_frontmatter: table metadata is read and servings aliases yield")

# --- a clean recipe --------------------------------------------------------
clean = run(recipe(nutrition={"Sodium": "300 mg", "Saturated Fat": "2 g"}))
check(clean["servings"] == 4, "clean recipe: servings parsed")
check(not findings(clean, severity="warning") and not findings(clean, severity="critical")
      and not findings(clean, severity="health"), "clean recipe: no warnings, health flags or criticals")
check(clean["max_severity"] in ("ok", "note"), "clean recipe: max severity is ok or note")

# --- nutrition thresholds --------------------------------------------------
heavy = run(recipe(nutrition={"Sodium": "1,000 mg", "Saturated Fat": "5 g"}))
msgs = [f["message"] for f in findings(heavy, "nutrition", "health")]
check(any(m.startswith("Very high sodium") for m in msgs), "nutrition: 1,000 mg sodium is very high (comma parsed)")
check(any(m.startswith("Elevated sat fat") for m in msgs), "nutrition: 5 g saturated fat is elevated")
check(findings(run(recipe()), "nutrition", "note") != [], "nutrition: no table gives an estimate-it note")

# --- allergens --------------------------------------------------------------
undeclared = run(recipe(allergens="[gluten]", ingredients="- 2 cups flour\n- 2 tbsp butter"))
allergen_warn = findings(undeclared, "allergen", "warning")
check(len(allergen_warn) == 1 and "dairy" in allergen_warn[0]["message"], "allergens: undeclared butter warns dairy, only dairy")

friends = run(recipe(allergens="[peanut]", ingredients="- 2 tbsp peanut butter\n- 1 can butter beans\n- 1 cup oyster mushrooms\n- 1 cup oat milk"))
check(not findings(friends, "allergen", "warning"), "allergens: peanut butter, butter beans, oyster mushrooms, oat milk raise no false flags")

wheat = run(recipe(allergens="[wheat, dairy, egg]"))
check(not findings(wheat, "allergen", "warning"), "allergens: a declared wheat covers detected gluten")

table = run("| **allergens** | gluten (tortillas) |\n| **servings** | 4 |\n\n# Tacos\n\n## Ingredients\n- 8 tortillas\n\n## Instructions\n1. Warm 2 minutes.\n")
check(not findings(table, "allergen", "warning"), "allergens: a parenthetical note in a table declaration still matches")

no_field = run(recipe(allergens=None))
check(not findings(no_field, "allergen", "warning") and len(findings(no_field, "allergen", "note")) == 1,
      "allergens: no allergens field gives one note, not per-allergen warnings")

# --- raw protein -------------------------------------------------------------
raw = dict(allergens="[]", ingredients="- 1 lb chicken thighs\n- salt")
check(findings(run(recipe(instructions="1. Sear 10 minutes per side.", **raw)), "food-safety", "warning") != [],
      "raw protein: chicken with no temp or doneness cue warns")
check(not findings(run(recipe(instructions="1. Roast 30 minutes to 165°F.", **raw)), "food-safety"),
      "raw protein: an internal temperature clears it")
check(not findings(run(recipe(allergens="[]", ingredients="- 2 cups cooked chicken\n- 4 cups chicken stock",
                              instructions="1. Simmer 10 minutes.")), "food-safety"),
      "raw protein: cooked chicken and chicken stock are not raw protein")

# --- danger patterns ---------------------------------------------------------
garlic = run(recipe(allergens="[]", ingredients="- 10 garlic cloves\n- 1 cup olive oil",
                    instructions="1. Cover the garlic in oil and store in a jar at room temperature for 2 weeks."))
check(any("botulism" in f["message"] for f in findings(garlic, "food-safety", "critical")), "danger: garlic in oil at room temperature is critical")
check(garlic["max_severity"] == "critical", "danger: max severity reports critical")
canning = run(recipe(allergens="[]", ingredients="- 4 lb cucumbers\n- 2 cups vinegar",
                     instructions="1. Process the jars in a boiling-water bath 10 minutes."))
check(findings(canning, "food-safety", "warning") != [] and not findings(canning, "food-safety", "critical"),
      "danger: home canning is a warning, not critical")

# --- CLI end to end ----------------------------------------------------------
with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    (root / "Mains").mkdir()
    (root / "Mains" / "pancakes.md").write_text(recipe(), encoding="utf-8")
    (root / "Mains" / "garlic-oil.md").write_text(recipe(allergens="[]", ingredients="- garlic\n- oil",
        instructions="1. Keep the garlic in oil on the counter at room temperature."), encoding="utf-8")
    (root / "README.md").write_text("# Not a recipe\n", encoding="utf-8")
    (root / "Templates").mkdir()
    (root / "Templates" / "template.md").write_text(recipe(), encoding="utf-8")
    out = root / "report.json"
    proc = subprocess.run([sys.executable, str(SCANNER), str(root), "--out", str(out)],
                          capture_output=True, text=True, encoding="utf-8")
    check(proc.returncode == 0, "cli: exits 0 over a fixture folder")
    report = json.loads(out.read_text(encoding="utf-8")) if out.exists() else {}
    check(report.get("scanned") == 2, "cli: skips README.md and Templates/, scans the two recipes")
    check(report.get("recipes_with_critical") == ["Test Dish"] and report["recipes"][0]["max_severity"] == "critical",
          "cli: the critical recipe is listed and sorted first")
    check(json.loads(proc.stdout) == report, "cli: stdout and --out carry the same report")

    empty = root / "empty"
    empty.mkdir()
    proc = subprocess.run([sys.executable, str(SCANNER), str(empty)], capture_output=True, text=True)
    check(proc.returncode == 1, "cli: an empty folder exits 1")

if failures:
    print(f"\n{len(failures)} check(s) failed.")
    sys.exit(1)
print("\nAll skill-script checks passed.")
