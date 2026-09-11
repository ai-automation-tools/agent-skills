# Worked example — root README

The Tier-1 index from a fictional full run, showing the verdict-first structure, honest badges, and inline claim tags.

> [!WARNING]
> Every number below is invented for illustration. "Clinic Intake Automation" is not a real product and the competitors are not real companies. Do not cite anything on this page.

---

```markdown
<a id="readme-top"></a>

<h1 align="center">📈 Clinic Intake Automation</h1>

<p align="center">
  <em>Pulls patient intake forms off paper and into the practice management system, for small dental practices.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/verdict-BUILD-2ea44f?style=for-the-badge" alt="Verdict: build">
  <img src="https://img.shields.io/badge/evidence-mixed-F59E0B?style=for-the-badge" alt="Evidence: mixed">
  <img src="https://img.shields.io/badge/stage-build_planned-8B5CF6?style=for-the-badge" alt="Stage: build planned">
</p>

---

## 🎯 The call

**Build a single-practice pilot, priced at $240/mo, and sell it by hand to twenty
practices before writing a second integration.**

The call rests on one thing: that a practice will pay a per-month fee rather than
absorb intake as front-desk time. At $240/mo the model breaks even at 63 practices
`[est: models/roi.py]`; below $180/mo it never does at our CAC. That price sits
above the $150–200 band where the two closest tools cluster `[fact, C, pricing
pages, 2026-08-14]`, so we are betting the workflow saving is legible enough to
justify a premium.

**Read the full reasoning:** [Build clinic intake automation](decisions/2026-08-17-build-clinic-intake.md)

## 💡 The idea

Small dental practices still take intake on paper, then a front-desk staffer
retypes it into the practice management system. The idea is a tablet form that
writes straight into the PMS through its API, so the retyping stops.

| | |
|:---|:---|
| **Decision on the table** | Build a pilot in H1 2027, or drop it? |
| **Analysed** | 2026-08-17 |
| **Depth** | Full analysis — all eight passes |
| **Sources captured** | 11 |

## 🗂️ What's in here

| Folder | What's inside |
|:---|:---|
| [**📚 research/**](research/README.md) | 11 source captures — BLS employment counts, the ADA practice survey, two competitor pricing pages, job postings, and 18 months of one changelog. |
| [**🔍 analysis/**](analysis/README.md) | Bottom-up SAM of $38–71M, two teardowns, and the business case. The landscape file explains why the SMB gap is real but not empty. |
| [**🧮 models/**](models/README.md) | `roi.py` and its sweep. Price owns the answer; churn is second and CAC barely moves it. |
| [**⚖️ decisions/**](decisions/README.md) | The memo. Two-way door, ~$40k and six weeks to unwind. |
| [**🔨 build/**](build/README.md) | Spec with a seven-item Won't list, two ADRs, a 9–16 week estimate, and a five-slice plan. |

## ⚠️ What this analysis does not know

- **Neither competitor's revenue, churn, or realized price.** Both are private and
  have never disclosed. Everything we have is list price off a public page `[C]`.
  If the decision hinged on their actual numbers we would need channel checks or a
  paid data provider, and that is a scope call, not a gap I can close.
- **Whether practices switch PMS often enough to strand an integration.** No public
  source counts PMS migrations. Tagged `[assum]` throughout, and it is the second
  falsifier in the memo.
- **Realized intake time per patient.** The 4–7 minute figure is from two vendor
  case studies `[C]` and one forum thread `[D]`. We should time it in the pilot
  rather than keep citing it.

---

<p align="center">
  <a href="decisions/README.md">The decision →</a> ·
  <a href="analysis/README.md">The analysis</a> ·
  <a href="models/README.md">The numbers</a>
</p>
```

---

## What to notice

- **The verdict is in the first badge and the first heading.** Nobody has to click into `decisions/` to learn the answer.
- **The evidence badge says `mixed`, not `sourced`.** Half the inputs are `[assum]`. Saying so in the header is what keeps the tags honest everywhere else.
- **The key assumption appears on the front page**, with the number that flips it and the model file that produced it. That's the sentence a reader can argue with.
- **The unknowns section names three real gaps** and routes each one, rather than listing generic caveats. This is the section that stops somebody inventing the missing numbers next quarter.
- **Table cells carry findings, not filenames.** "Bottom-up SAM of $38–71M" beats "market analysis documents."

---

<p align="center">
  <a href="./README.md">← Examples</a> ·
  <a href="./target-output-tree.md">← Target output tree</a>
</p>
