# AU Paper-Ready Roadmap

## Objective

Make the Civitas 6.7B governed self-improvement evaluation paper-evidence
ready for the Australian finance lane and leave a shareable proof bundle that
can travel with the paper.

Paper evidence exists only when the final AU run is real, frozen, scored,
governed, reproducible, verified, and reported inside the declared claim
boundary. Smoke success does not satisfy that bar.

## Locked Paper Claim Surface

### In Scope

- Frozen Praxis AU finance baseline `baseline-au-finance`
- Praxis baseline release `br_1e6d12c254a3`
- Praxis baseline fingerprint/version `10cf217f862c`
- APRA CPS 234 source refs contained by the AU finance baseline
- ASIC RG 234, RG 271, and RG 274 source refs contained by the AU finance
  baseline
- Civitas 6.5B frozen comparator
- Civitas 6.7B no-improvement control
- Civitas 6.7B governed sandbox improvement
- held-out and stress evaluation
- Cassius-backed claim-supporting candidate gates

### Out Of Scope

- EU
- standalone APRA or ASIC active-corpus claims
- production promotion
- live self-modification
- API/frontier portability unless a real optional lane is frozen later
- model training work

## Existing Assets

The harness already has:

- split-isolated task contracts and placeholder split files
- baseline, failure discovery, candidate generation, gate, sandbox promotion,
  held-out, stress, aggregation, reproducibility, and readiness phases
- governance schemas and sandbox-only markers
- Cassius fail-closed gate behavior
- Praxis/Aegis AU discovery notes and registry scaffolding
- local Gemma/Ollama comparator metadata surfaces

Those assets make the remaining path concrete. They do not remove the need for
real AU task rows, real model execution, real scoring, Cassius evidence, and a
verified full run.

## Blocking Workstreams

| Workstream | Blocking result |
| --- | --- |
| AU authority | One resolved AU paper registry lane with active-law, graph, trust-region, Praxis, and Aegis bindings. |
| Dataset | Curated AU `100/100/50` split set with registry-linked source refs and no placeholder or EU rows. |
| Execution | Real local Civitas/Gemma result rows for frozen 6.5B, 6.7B no-improvement, governed sandbox improvement, and the planned ungated sandbox ablation. |
| Scoring | Frozen scoring and adjudication path that emits defendable labels and retains failed rows. |
| Governance evidence | Receipt-bound Cassius evidence plus trust-region, replay/canary, and declared Aegis/Senate evidence status. |
| Reproducibility | AU paper run script, manifest, verifier, proof bundle, statistics, final tables, and final readiness result. |

## Phase Plan

### Phase A: Freeze AU Authority

1. Define a dedicated `au_finance_paper_scope` registry lane.
2. Bind it to the frozen Praxis AU finance baseline and selected Aegis
   active-governance authority.
3. Define the AU mapping for harness fields:
   - `active_law_hash`
   - `policy_graph_hash`
   - `trust_region_hash`
4. Remove `PENDING_*` fields from the selected AU claim lane.
5. Keep EU and standalone APRA/ASIC authority claims out of the paper lane.
6. Make readiness checks accept an AU registry-linked paper fixture.

### Phase B: Freeze AU Dataset

1. Write AU source maps and task authoring controls.
2. Curate real `train_failures`, `heldout_eval`, and `stress` split rows.
3. Bind every row to the AU registry lane and exact AU baseline source refs.
4. Review expected actions, policy basis, risk tier, criteria, and failure
   modes.
5. Run schema validation and near-duplicate split leakage review.
6. Freeze task hashes and taskset manifest.

### Phase C: Replace Smoke Stubs

1. Discover and bind the real local execution surfaces.
2. Run the primary local Gemma/Ollama lane.
3. Freeze Civitas 6.5B as comparator only.
4. Emit real Civitas 6.7B no-improvement rows.
5. Emit real governed sandbox rows and planned ungated sandbox rows.
6. Preserve current JSONL schemas, receipt hashes, error rows, and sandbox
   boundaries.

### Phase D: Score And Govern

1. Freeze a scorer and adjudication protocol.
2. Score unsafe action, unsupported claim, policy violation, contradiction,
   correct control action, evidence support, safe fallback, hallucinated policy,
   and overconfidence labels.
3. Generate real failure clusters and candidates from train failures only.
4. Produce receipt-bound Cassius evidence for claim-supporting candidate gates.
5. Add paper-grade trust-region and replay/canary evidence.
6. Decide and evidence-load Aegis/Senate checks where reachable without
   production mutation, or keep the narrower claim explicit.

### Phase E: Reproduce And Report

1. Build an AU paper run entrypoint and verifier.
2. Freeze configs, model metadata, corpus refs, task hashes, scorer refs, and
   governance evidence refs.
3. Add paper statistics and uncertainty reporting for primary held-out deltas.
4. Run a pilot and close pilot defects.
5. Freeze full inputs.
6. Run the full AU paper evidence bundle.
7. Verify zero production mutation and zero unauthorized promotion.
8. Require `paper_evidence_ready` before paper claims are written.

## Final Acceptance Gate

The full AU run is ready only when every row below is true.

| Gate | Required state |
| --- | --- |
| Claim scope | AU finance baseline only; APRA/ASIC are baseline-contained source subsets. |
| Registry lane | Selected AU paper lane has no unresolved claim `PENDING_*` values. |
| Active law | Frozen real binding and epoch evidence are archived. |
| Graph/trust | Frozen graph and trust-region bindings are archived. |
| Tasks | Curated AU rows with no placeholder or EU claim rows. |
| Splits | Train, held-out, and stress isolation checks pass. |
| Execution | Claim rows are real non-stub rows. |
| Comparators | 6.5B frozen comparator and 6.7B no-improvement control are archived. |
| Governed condition | Sandbox improvement rows use approved sandbox artifacts only. |
| Cassius | Approved claim candidates have passed receipt-bound Cassius evidence. |
| Governance | Trust-region and replay/canary status are explicit and auditable. |
| Sandbox safety | Production mutation count and unauthorized promotion count are zero. |
| Scoring | Scorer/adjudicator config and failed rows are archived. |
| Reporting | Aggregated tables, uncertainty outputs, and limitations are archived. |
| Repro | Paper verifier passes on the archived bundle. |
| Readiness | Paper readiness checker returns `paper_evidence_ready`. |

## Work Order

The controlled prompt order is in `PROMPT_SEQUENCE.md`. Do not skip a QA gate
when the preceding phase changes claim boundaries, task data, model execution,
scoring, governance evidence, or final run packaging.
