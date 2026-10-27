---
name: critical-appraisal
description: Appraise a single scientific paper or claim, asking what question it answers, whether the design can answer it, how much bias could explain the result, whether the statistics hold up, and how far the conclusion generalizes. Uses PICO framing, the hierarchy of evidence, named risk-of-bias tools (RoB 2, ROBINS-I, QUADAS-3), GRADE for bodies of evidence, and a checklist of red flags (p-hacking, spin, outcome switching, small-n surprises). Use when asked "is this study any good", "can I trust this paper", "critique this", "journal club", "what are the limitations", or when a news story cites a study.
---

# Critical appraisal

Appraising a paper is asking, in order: what exactly did they test, could this design
answer it, what else could explain the result, and how far does it reach? Work from the
paper itself, not its abstract's spin or a press release.

## 1. Pin down the claim

Write it as **PICO**: Population (who or what system), Intervention or exposure,
Comparator, Outcome, plus the time frame and the effect measure. Then classify it:
**descriptive** (how common?), **predictive** (does X forecast Y?) or **causal** (does X
change Y?). Causal claims need designs that can support causation.

## 2. Place the design

Roughly, for causal questions, from strongest to weakest: systematic review and
meta-analysis of good RCTs → single RCT → cohort → case-control → cross-sectional → case
series → mechanistic reasoning, animal or cell work, expert opinion. The hierarchy is a
starting point, not a verdict: a large, well-run cohort can beat a small, leaky RCT, and
in vitro work answers a different question rather than a weaker one.

## 3. Look for bias

Use the tool that fits the design, and name it:

| Design | Tool | Key domains |
|:---|:---|:---|
| Randomized trial | RoB 2 | Randomization, deviations from intervention, missing outcome data, outcome measurement, selective reporting |
| Non-randomized intervention study | ROBINS-I (or ROBINS-E for exposures) | Confounding, selection, classification, deviations, missing data, measurement, reporting |
| Diagnostic accuracy | QUADAS-3 (Feb 2026; replaces QUADAS-2, which older reviews still use) | Judged per accuracy estimate, not per study; an Analysis domain replaces flow and timing; overall judgment section |
| Lab and animal work | No single tool; ask | Was the unit right (no pseudoreplication)? Randomized and blinded? Controls? Pre-registered? |

The questions that catch most problems: Who dropped out, and was it balanced? Were
outcome assessors blinded? Was the primary outcome the one registered? What confounders
weren't measured?

## 4. Check the numbers

- **n and power.** A small study with a big surprising effect is more likely to be noise
  or exaggerated (the "winner's curse") than a discovery.
- **Effect size and CI**, not only p. A wide CI that barely excludes zero is weak evidence.
- **Multiplicity.** Many outcomes or subgroups with one "significant" result, uncorrected.
- **Absolute vs relative risk.** "Halves the risk" from 2 in 10,000 to 1 in 10,000.
- **p-values bunched just below 0.05**, unexplained exclusions, analyses that differ from
  the registration: signs of analytic flexibility.

## 5. Read the conclusion against the results

Spin is common: causal words from correlational data, a secondary outcome headlined when
the primary failed, "trend toward significance", animal results phrased as human benefit.
Compare the abstract's conclusion with the results table.

## 6. Generalize carefully

Would the effect hold in a different population, dose, setting or time? Has anyone
replicated it independently? Is the paper retracted or under an expression of concern
(check Crossref or Retraction Watch)? Who funded it, and do the authors declare conflicts?

## 7. For a body of evidence: GRADE

Rate certainty per outcome as high, moderate, low or very low. Start high for RCTs and low
for observational studies; rate down for risk of bias, inconsistency, indirectness,
imprecision and publication bias; rate up for a large effect, a dose-response gradient, or
when plausible confounding would shrink the effect. Give the reason for every step.

## Output

The claim in PICO form; the design and its place; the bias assessment with the tool named;
the numbers that matter; whether the conclusion follows; how far it generalizes; and a
one-line bottom line ("moderate-certainty evidence that X modestly reduces Y in adults;
not tested in children"). Quote the paper for every judgment.
