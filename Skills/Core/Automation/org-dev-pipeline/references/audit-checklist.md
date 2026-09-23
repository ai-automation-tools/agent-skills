# Audit checklist

Gather evidence before you conclude anything. Use live `schtasks /query /fo CSV /v` (not
`Get-ScheduledTask`, which misses tasks), the run logs (`= done: N turns, Ns, cost $X` lines),
`git log` on the repos, the sweep config, and the ledger. A doc's description of a
schedule is a claim to verify, not evidence.

## 1. Safety (P0 if any fails)

- [ ] Repo creation goes through the security wrapper, not plain `gh repo create`
- [ ] Every visibility change is followed by a security re-verify
- [ ] The public flip is decided by a script with exit codes, not by a prompt checklist
- [ ] A human approval stands between "gates pass" and "public"
- [ ] The secret scanner is installed, scans all refs, and fails closed when missing
- [ ] Commit-identity gate: only the approved public email or noreply addresses. Check that squash-merge authors pass too
- [ ] No model prompt can change visibility or close the approval issue (a stated rule, plus a deny rule if possible)

## 2. Waste

- [ ] Count sessions per week per job. Does each one usually have work? If not, add a pre-check
- [ ] Is upstream production (ideate) throttled to downstream capacity (the incubation cap × graduation time)?
- [ ] Are two jobs touching the same repo on the same topic? Merge them into one session and one PR
- [ ] Does the merge gate spend its expensive model on PRs a path rule could decide?
- [ ] Do daily jobs stay quiet on a skip?
- [ ] Does a weekly report total the fleet's spend per job (from the log cost lines), with the change from last week?

## 3. Throughput

- [ ] How many sweeps a week? That's the ceiling on items per project per week
- [ ] Is each consumer scheduled after the sweep that merges its input?
- [ ] Estimate the weeks to graduate: open gates ÷ items per week. Is it acceptable?

## 4. Stall detection

- [ ] Are Needs-<owner> items above the gate line reported every week?
- [ ] Are projects with no merged roadmap PR in 21 days flagged as "unblock or retire"?
- [ ] Are PRs older than 10 days on any sweep prefix flagged? Does that list come from the sweep config?

## 5. Drift

- [ ] Is there one schedule table, with everything else linking to it?
- [ ] Do prompts avoid hand-editing counts and badges?
- [ ] grep every doc for each task's schedule and compare it with live `schtasks`
- [ ] Is every task Enabled, with a last result of 0 or never-run? Freshly re-registered tasks show never-run, which is expected
- [ ] Is a task whose Last Run Time is older than its interval plus a day flagged? A task that stops firing keeps its last result of 0, so the result code alone never catches it
- [ ] Is there a documented one-liner to pause and resume the whole fleet?

## 6. Collisions

- [ ] Do long sessions share a start time?
- [ ] Are there two writers on one branch, for example a direct push to the landing page while its upkeep PR is open?

## Output

Write two files. `README.md` holds the findings: TL;DR, current inventory table, findings
ranked P0–P3 each with evidence and a fix, a keep-as-is list, and a remove/combine table.
`NEXT-STEPS.md` holds the plain numbered actions, each with **why / change / where / done
when**, grouped by when to do them, with a summary table at the end.
