# Recipe validation report — full corpus (192 recipes) + skill refinement

_192 recipes · 2026-07-08 · My-Recipes (8) + Recipe-of-the-Week (25) + Regions (159) · 1 ❌ needs fixes · rest ⚠️/✅_

Iteration 2. Where iteration 1 hand-judged 13 recipes, this pass ran the scanner over the **entire** `My-Library/Cooking/Recipes` tree, used the results to **harden the scanner + references** against the false-positive classes iteration 1 had to kill by hand, then re-judged. The headline is that the noise iteration 1 killed manually is now killed *in the tool*, so the signal that remains is almost all real.

## Scan signal: before vs. after this iteration's refinements

| Severity | Before | After | What changed |
|---|--:|--:|---|
| 🔴 critical | 4 | **0** | The 4 "criticals" were all home-canning flags on **high-acid** preserves (apple butter, corn relish, dill pickles, pickled beets) — safely water-bath canned. Canning is now a **warning** to verify acidity, not an automatic critical. |
| 🟠 health | 17 | 17 | Nutrition logic untouched (correct) — these are honest rich-dish numbers. |
| 🟡 warning | 284 | **70** | Allergen warnings **258 → 47**: field-less clippings now get one *note* instead of N warnings; keyword false friends masked. |
| 🔵 note | 194 | 269 | Field-less recipes' allergen info moved here as single informational notes. |

The one genuine 🔴 (Classic American Burger) is unchanged and still surfaced.

---

## ❌ Needs fixes

### Classic American Burger — `Regions/Recipes/American/ClassicBurger.md`
- 🔴 **food-safety** · Instructions cook the ground-beef patty **"to medium-rare"** and invite "your desired level of doneness." Ground beef must reach **160 °F** (grinding spreads surface bacteria — incl. E. coli O157:H7 — throughout the patty). The recipe contradicts itself (its own safety note lists 160 °F). **Fix:** cook to an internal **160 °F**; drop/qualify the medium-rare guidance (medium-rare is defensible only for whole-muscle beef). *(This was iteration 1's finding; re-confirmed. The frontmatter here is bold `**Key:** value` lines, now parsed — the review no longer mislabels it as "no allergens field.")*
- 🟡 **allergen** · Declares `gluten, dairy`; omits **egg** (mayonnaise). **Fix:** add `egg`. *(Scanner's `sesame` hit is a false positive — sesame is only an optional bun swap.)*

---

## ⚠️ Pass with notes (themes; representative recipes)

**Genuine allergen-labeling gaps** — the `allergens:` field exists but omits a Big-9 that's actually in the dish. Worth fixing at the source:
- **Pad Thai** — declares `nut` (tree-nut) but has **peanuts** as a core ingredient → add `peanut` (distinct Big-9).
- **Carne Asada Tacos** — marinade uses soy sauce **or** Worcestershire → **soy** (and/or fish from anchovy) present, declared only `gluten` → add `soy`/`fish` conditionally.
- **Shakshuka** — feta present, declares only `egg` → add `dairy`.
- **Moussaka** — béchamel → add **egg** + **gluten** (only `dairy` declared).
- **Tempura** — batter → add **egg**; dipping sauce → **soy** (declares only `gluten, shellfish`).
- **Kansas City BBQ Brisket** — butter in sauce, declares only `soy` → add `dairy`.
- **Soup Dumpling Onion Cups** — shrimp present, not declared → add `shellfish`.
- **Viral Korean Cucumber Salad** — fish sauce → add `fish`.
- **Lamb Tagine**, **Ramen (Tonkotsu)** — sesame present, undeclared → add `sesame`.
- *Judgment calls (report as trace, don't fail):* Worcestershire → fish; soy sauce → gluten; **peanut oil** for frying (Falafel, Texas Chicken-Fried Steak, Wisconsin Cheese Curds, Quebec Poutine) — refined peanut oil is FDA-exempt.

**Nutrition — high but honest for the dish type** (🟠, informational, not failures): Texas Chili (sat fat ~17 g), Jambalaya (sodium ~1,800 mg), Beef Stroganoff (sodium ~959 mg), Chicken Parmigiana (cholesterol ~145 mg), Pad Thai (sodium 1,450 mg), Wisconsin Beer Cheese Soup, Carne Asada, Classic French Croissant (sat fat ~10 g). Each is billed as rich/hearty; recommend the recipe's own lower-sodium options where offered.

**Home-canning / preserving — verify tested ratio + altitude, not unsafe** (🔵/🟡): Apple Butter, Corn Relish, Homemade Dill Pickles, Pickled Beets are all **high-acid** (fruit / cider-vinegar brines) → boiling-water bath is the **correct** method (not the pressure-canner "critical" the raw scanner implied). Remaining note: match a **tested** USDA/NCHFP ratio and adjust process time for altitude >1,000 ft.

**Raw fish — handled correctly:** Sushi (Maki Roll) carries an explicit "use **sushi-grade** fish, frozen to kill parasites" note → passes (an improvement over iteration 1's ceviche, which lacked it). Only flag raw-seafood dishes that *don't* address parasite-destruction freezing.

**Ground-beef doneness cues:** Sloppy Joes / American Goulash brown the beef ("until browned"); Detroit Coney simmers the sauce 45–60 min; Loose Meat cooks "until no pink remains." All safe in practice; the only optional nudge is to state an explicit **160 °F**.

---

## ✅ Pass

The large majority of the 159 Regions recipes and the 25 Recipe-of-the-Week recipes are safe, coherent, and correctly labeled — no findings above a note. They aren't enumerated individually here (the scan JSON has them); the report leads with what needs attention.

---

## Skill refinements shipped this iteration

Driven by the false positives this corpus exposed (the same ones iteration 1 killed by hand), applied to `scripts/scan_recipes.py` + `references/` + `SKILL.md` + `evals/`:

1. **Multi-format frontmatter parsing.** ~40% of the library (81/192) declares metadata in a **markdown table** (`| **allergens** | … |`) or **bold inline lines** (`**Allergens:** …`), not YAML. The scanner now reads all three — so their declared allergens/yield are no longer invisible (this was silently downgrading real gaps like Carne Asada's missing soy/fish to a generic "no labeling" note).
2. **Allergen reporting split by whether a field exists.** Field present but incomplete → per-allergen **warning** (a real gap). No field at all → a single **note** (you can't be "missing" from a non-existent list). This alone cut allergen warnings 258 → 47.
3. **Keyword false-friend masking:** butter beans / plant-based butter / coconut-almond-oat **milk** (not dairy), **oyster mushroom** & **oyster crackers** (not shellfish), and ingredient-**swap lines** ("X → Y", "…if not vegan"). Judgment-call hits (Worcestershire→fish, soy sauce→gluten, refined peanut oil) are deliberately left in, now documented in `food-safety.md §4`.
4. **Home-canning downgraded critical → warning**, with an **acidity-aware** message; `food-safety.md §3` now spells out high-acid (water-bath-safe) vs low-acid (pressure-only).
5. **Correctness fixes:** unbracketed `allergens: a, b, c` was being iterated **character-by-character** (broke the check for e.g. east-asian Tonkotsu Ramen) → fixed; declared tokens with parentheticals ("gluten (tortillas)") normalized; `parse_servings` made range-aware ("4 servings (12 tacos)" → 4, not 8); broth/stock skipped in the raw-protein check ("chicken stock" ≠ raw chicken); "no pink remains" recognized as a doneness cue.
6. **Evals** extended with a high-acid canning case, a table-format allergen case, and a full-corpus noise-floor case, so these don't regress.

## Residual known limitations (for the model to judge, by design)
- A bare "oyster" inside a mushroom list ("cremini, shiitake, **or oyster**", e.g. Risotto ai Funghi) still trips shellfish — read it in context.
- Optional/garnish ingredients (parmesan on aglio e olio, sesame bun swaps) are scanned as present — the model decides whether an optional item counts for labeling.
- Table/bold frontmatter yield for a *preserve* ("4–5 half-pint jars") parses as "servings" — harmless (per-serving math is N/A for canned goods).

### Method notes
- Full corpus scanned; report leads with the one 🔴 and the real allergen gaps, frames nutrition by dish type, and treats high-acid canning as safe. Interim scans (`scan-before-refinements.json`, `scan-final.json`) are in this folder for the before/after diff.
