# Target output tree

What a `business-plan-builder` run leaves on disk. Two versions: a full run that cleared the gate, and one that stopped at it.

## Full run — the memo said build

```
clinic-intake-automation/
│
├── README.md                          ← Tier 1. Verdict first. Links down to all five folders.
│
├── research/                          ← pass 1–2 write here, before any reasoning
│   ├── README.md                      ← Tier 2. Source ledger: source · grade · retrieved · what it gave us
│   ├── bls-oes-dental-assistants.md   ← [A] BLS occupational employment, retrieved 2026-08-14
│   ├── ada-practice-survey-2025.md    ← [A] trade association member counts
│   ├── competitor-a-pricing.md        ← [C] vendor pricing page
│   ├── competitor-a-jobs.md           ← [B] careers page, 6 postings captured
│   └── competitor-b-changelog.md      ← [B] release notes, cadence over 18 months
│
├── analysis/                          ← pass 1–3 conclusions; every claim cites research/
│   ├── README.md                      ← Tier 2
│   ├── market-scan.md                 ← pass 1: bottom-up SAM, JTBD, Five Forces (if it earned its place)
│   ├── landscape.md                   ← pass 2: who's here, which segment each took, where the gap is
│   ├── teardown-competitor-a.md       ← pass 2: verdict up top, graded claims, mandatory unknowns section
│   ├── teardown-competitor-b.md
│   └── business-case.md               ← pass 3: the model's findings in prose, citing models/roi.py
│
├── models/                            ← runnable Python. Executed output pasted into the README.
│   ├── README.md                      ← Tier 2 + the real terminal output of each model, dated
│   ├── roi.py                         ← pass 3
│   └── estimate.py                    ← pass 7
│
├── decisions/
│   ├── README.md                      ← Tier 2. One row per memo, with status.
│   └── 2026-08-17-build-clinic-intake.md   ← pass 4. THE GATE.
│
└── build/                             ← exists only because the memo said build
    ├── README.md                      ← Tier 2
    ├── spec.md                        ← pass 5
    ├── adr-001-postgres-over-dynamo.md     ← pass 6, one-way door
    ├── adr-002-buy-auth.md                 ← pass 6, build-vs-buy
    ├── estimate.md                    ← pass 7, narrative around models/estimate.py
    └── build-plan.md                  ← pass 8, slices + when we'd stop
```

**The index chain:** `README.md → analysis/README.md → market-scan.md`, and every folder README's footer climbs back. Three tiers is the ceiling — no folder here is deep enough to need a fourth.

## Stopped at the gate — the memo said no

```
subscription-box-for-x/
│
├── README.md                ← verdict badge reads NO_GO. Opening block says why, in two sentences.
│
├── research/
│   ├── README.md
│   └── … 4 captures
│
├── analysis/
│   ├── README.md
│   ├── market-scan.md
│   ├── landscape.md
│   └── business-case.md
│
├── models/
│   ├── README.md            ← the sweep that killed it, with executed output
│   └── roi.py
│
└── decisions/
    ├── README.md
    └── 2026-08-17-subscription-box.md   ← recommendation: don't build. Falsifiers listed anyway.
```

No `build/` folder, and no link to one from the root index. The root README says plainly that the build layer was not written and why — that's the run working, not an incomplete deliverable.

The memo still carries a "what would change my mind" section. A no-go with falsifiers is a decision you can revisit when the world moves; a no-go without them is just a mood.

---

<p align="center">
  <a href="./README.md">← Examples</a> ·
  <a href="./example-root-README.md">Worked root README →</a>
</p>
