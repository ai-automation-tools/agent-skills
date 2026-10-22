# 🏭 automated-dev-pipeline

> **Overview page.** The skill itself is [`SKILL.md`](../../../../../skills/core/automation/automated-dev-pipeline/SKILL.md) · [all Core skills](../../../../../README.md#-core-skills)

## What the skill does

[`automated-dev-pipeline`](../../../../../skills/core/automation/automated-dev-pipeline/SKILL.md) sets up and audits scheduled AI agents that do development work unattended: ideas become plans, plans become private repos that grow one verified PR at a time, a single sweep reviews and merges, publishing waits on scripted gates plus a human approval, and keep-current jobs cover every repo afterwards.

## How it works

The diagram lives on the [homepage](https://agent-skills.ai-automation-tools.dev/) (the `automated-dev-pipeline` card links to it):
**[open the interactive version →](https://agent-skills.ai-automation-tools.dev/assets/diagrams/automated-dev-pipeline-workflow.html)** (trace routes, search nodes, switch themes, export)

| Lane | What happens there |
|:---|:---|
| **Build stages** | An idea source feeds ideate, which scores candidates only when the backlog runs low. Incubate turns a plan into a private repo (capped), and its roadmap routine ships one feature, or up to six small docs-or-config gates, per run as a PR (three runs a week while incubating, merged by a daily sweep, gated at the MVP), skipping the session entirely when there's no work |
| **Merge gate** | One PR sweep, on the strongest model, reviews every routine's PRs by branch prefix; the runner merges what it approves after re-running the hard gates. PRs that touch a deploy path or carry a personal commit email wait for the owner |
| **Publish (scripted)** | When every release gate is ticked, a script runs the gates (secret scan, CI, commit emails, live 200s), opens an approval issue, and goes public only after the owner closes it as Completed, re-running the gates and reading the security controls back |
| **Owner decides** | The three places a person acts: held PRs, the approval issue, and the weekly `[Approval needed]` digest |
| **Keep current** | Refresh and review cover every repo, published or not, with a cited source for each change, and send their PRs through the same sweep. Upkeep reports stalls, drift and counts to the digest |

The four rule cards in the interactive version cover what the lanes don't: scripts decide while
prompts judge, irreversible steps belong to a person, the runner closes the feedback loop (run
history, `TRAP:` and `LESSON:` lines, prompt edits by PR), and the single-repo variant, where
stages are folders and a held merge that deploys a site is the publish step.

## Updating the diagram

Both versions come from one source, [`diagrams/pipeline-workflow.json`](diagrams/pipeline-workflow.json),
rendered with [Archify](https://github.com/tt-a1i/archify). Change it in the same PR as any stage
change, then rebuild from the repo root:

```bash
node ~/.claude/skills/archify/bin/archify.mjs finalize workflow \
  resources/skill-data/core/automation/automated-dev-pipeline/diagrams/pipeline-workflow.json \
  site/assets/diagrams/automated-dev-pipeline-workflow.html \
  --quality showcase --out-dir <scratch-folder>
```

Delete the `*.delivery.json` receipt it leaves beside the HTML. Then open the HTML, choose
**Export → SVG · Auto** (it follows the reader's light or dark theme), and save the download over
`skills/core/automation/automated-dev-pipeline/pipeline-flow.svg`.

## Files

Nothing here is read at runtime; the skill is self-contained in its leaf folder.

| Path | What it is |
|:---|:---|
| [`pipeline-flow.svg`](../../../../../skills/core/automation/automated-dev-pipeline/pipeline-flow.svg) | The static diagram. It ships in the skill folder, so an agent can show it to the user |
| [`automated-dev-pipeline-workflow.html`](../../../../../site/assets/diagrams/automated-dev-pipeline-workflow.html) | The interactive version, self-contained. It lives under `site/` so the homepage publishes it, and the skill's card links to it (`diagram` in `site/showcase.json`) |
| [`diagrams/pipeline-workflow.json`](diagrams/pipeline-workflow.json) | The source both are built from |

---

<p align="center">
  <a href="../../../../README.md">← Resources home</a> ·
  <a href="../../../../../skills/core/automation/automated-dev-pipeline/SKILL.md">The skill →</a>
</p>
