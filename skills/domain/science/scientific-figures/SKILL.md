---
name: scientific-figures
description: Make scientific figures that show the data honestly and read clearly in print and on screen, by choosing the plot for the comparison, showing individual points when n is small, labelling error bars (SD, SEM or CI) and preferring confidence intervals, using colorblind-safe palettes, sizing text for the final column width, and exporting vector formats from a script. Covers matplotlib and seaborn patterns, multi-panel layouts, and the common ways charts mislead (truncated axes, dynamite plots, dual axes, rainbow colormaps). Use when making, fixing or reviewing a plot, chart, figure or graph for a paper, poster, slide or report.
---

# Scientific figures

A figure makes one comparison obvious. Decide what that comparison is before choosing a
plot, then remove everything that doesn't serve it.

## Choose the plot for the comparison

| You're showing | Use | Avoid |
|:---|:---|:---|
| A continuous outcome across a few groups | Points (jittered or swarm) over a box or violin, or mean ± 95% CI with the points | Bar of the mean with an SEM whisker ("dynamite plot"): it hides n and the distribution |
| Change within subjects | Paired lines (one per subject) | Two separate bars |
| A relationship between two variables | Scatter, with a fitted line and CI band if modelled | Connecting unordered points |
| A time course | Lines with a CI band; points if sparse | Smoothing that invents data between samples |
| A distribution | Histogram, density, or ECDF | A bar of the mean |
| Proportions | Stacked bar (few categories) or dot plot | Pie charts with many slices, 3D anything |
| Many variables or samples | Heatmap with a perceptually uniform, labelled colormap; clustered when order matters | Rainbow (`jet`) colormaps |
| Effect sizes across studies or subgroups | Forest plot | A table of p-values |

## Honesty rules

- **Show n**, and show the points when n is under ~30 per group.
- **Say what the error bars are** in the caption: SD (spread of data), SEM (precision of
  the mean, easy to misread) or 95% CI (preferred for inference).
- **Axes:** bar charts start at zero; other plots may zoom, with the axis clearly labelled.
  No broken axes without a visible break mark. Log scales labelled as log.
- **No dual y-axes** for two different quantities; use two panels.
- **Same scale across panels** that are meant to be compared.

## Readability

- **Colour:** colorblind-safe palettes (Okabe-Ito for categories; `viridis` or `cividis`
  for sequential; a diverging map such as `RdBu` centred on a meaningful zero). Don't encode
  meaning in red versus green alone; add shape or labels.
- **Size for the final layout:** a journal single column is about 85–90 mm wide, double
  about 170–180 mm. Set the figure size in inches at that width and keep text 7–9 pt at
  final size, so it doesn't shrink unreadably.
- **Label directly** where possible instead of a legend; units in axis labels
  ("Concentration (µM)").
- **Panels** lettered (A, B, C), aligned, with shared axes where it helps.

## A matplotlib starting point

```python
import matplotlib.pyplot as plt
import numpy as np

OKABE_ITO = ["#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#000000"]
plt.rcParams.update({"font.size": 8, "axes.spines.top": False, "axes.spines.right": False,
                     "axes.prop_cycle": plt.cycler(color=OKABE_ITO), "savefig.dpi": 300})

rng = np.random.default_rng(1)
groups = {"Control": rng.normal(10, 2, 12), "Treated": rng.normal(12, 2, 12)}

fig, ax = plt.subplots(figsize=(3.5, 2.8))            # ~89 mm wide
for i, (name, y) in enumerate(groups.items()):
    ax.scatter(np.full(y.size, i) + rng.uniform(-0.08, 0.08, y.size), y, s=12, alpha=0.7)
    m, ci = y.mean(), 1.96 * y.std(ddof=1) / np.sqrt(y.size)   # normal approx; use t for small n
    ax.errorbar(i + 0.25, m, yerr=ci, fmt="o", color="black", capsize=3)
ax.set_xticks(range(len(groups)), groups)
ax.set_ylabel("Outcome (units)")
fig.tight_layout()
fig.savefig("fig-01-outcome.svg")                       # vector for print; PNG for slides
```

## Reproducibility

Every figure comes from a script that reads saved data and writes the file, named after
the script. Never edit a plot by hand in an image editor; change the script. Export SVG or
PDF for publication, PNG at 300 dpi or more for slides and the web.

## Caption

What is plotted, what each mark and error bar is, n per group, the test and its result if
one is shown, and the data source. A reader should understand the figure from the caption
alone.
