# AU Paper Readiness Program

This folder is the tracked closeout program for making the Civitas 6.7B
governed self-improvement evaluation paper-evidence ready on the Australian
finance lane.

## Scope Lock

The paper lane is:

> Civitas 6.7B governed self-improvement evaluated on an Australian finance
> benchmark grounded in the frozen Praxis `baseline-au-finance` governance
> bundle, including APRA and ASIC source material contained within that
> baseline.

The paper lane is not:

- an EU benchmark
- a claim that APRA and ASIC are standalone active corpora in this harness
- an API/frontier portability claim unless a real API run is separately frozen
- production promotion or live self-modification

## Start Here

| File | Purpose |
| --- | --- |
| `AU_PAPER_READY_ROADMAP.md` | End-to-end work plan and acceptance gates. |
| `AU_PAPER_READY_CHECKLIST.md` | Checkboxes for the blocking evidence work. |
| `PROMPT_SEQUENCE.md` | The controlled 26-prompt sequence from Prompt 12A through final evidence QA. |
| `TRACKER.md` | Current status, owners, blockers, and next prompt. |
| `RED_TEAM_QA.md` | Red-team quality, safety, and evidence-integrity review contract. |
| `QA_AUTHORITY_BINDING.md` | Prompt 12B authority review that gates AU task source-map work. |
| `NEW_BOX_HANDOFF.md` | Repo-local AU runner inputs and the Gemma-box evidence-run handoff. |
| `proof_bundle/` | Shareable paper-proof bundle skeleton and manifest template. |

## Working Rule

Each prompt must leave the AU paper lane closer to verifiable evidence:

1. Close the prompt end to end.
2. Run focused checks that cover the changed contract.
3. Fix defects found during the prompt instead of carrying avoidable paper-lane
   debt.
4. Update the tracker and readiness artifacts when the prompt changes
   evidence status.
5. Keep smoke, pilot, and paper evidence boundaries explicit.

## Current State

As of the AU handoff hardening pass on 2026-05-22:

- the paper-evidence **run package** is ready to commit and move to the Gemma
  VM after `repro/CHECK_AU_PAPER_SETUP.sh` passes
- the **result evidence** is still pending until the verified AU paper run
  clears the paper readiness gate
- the selected AU paper authority lane is frozen and has passed authority QA
- the AU `100/100/50` taskset is frozen for real execution work
- real local Gemma/Ollama execution exists and emitted one scored/audited AU
  pilot row through `gemma4:e2b-it-q8_0`
- that one-row pilot is execution proof only; it is not paper evidence
- the real scorer, Cassius evidence exporter, AU paper runner, and AU paper
  verifier exist, but the full AU candidate/gate/sandbox/evaluation run has not
  been executed yet
- trust-region/replay/canary contracts, final paper tables, and final QA
  entrypoints are set up; actual evidence rows and final QA verdict wait on the
  larger Gemma box run

The next blocking execution step is the full real-local AU run on the new Gemma
box, starting from the frozen AU taskset and `RUN_AU_PAPER.sh` path rather than
another smoke pass.
