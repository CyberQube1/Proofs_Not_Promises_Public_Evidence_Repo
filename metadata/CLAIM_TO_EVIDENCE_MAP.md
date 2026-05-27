# Civitas 6.7B Paper Claim To Evidence Map

## Purpose

Each paper claim must point to artifacts that can confirm, weaken, or block it.
This map now records the claim posture for the verified AU evidence bundle at
`paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z`. Smoke artifacts may
support harness readiness but cannot support paper result claims.

| Claim | Required evidence | AU bundle status | Boundary |
| --- | --- | --- | --- |
| Civitas 6.7B extends the Civitas 4.0 reflexive-governance foundation into a candidate-improvement lifecycle. | 4.0 local manuscript abstract, contribution, Civic Control Stack, architecture sections; 6.7B failure-cluster/candidate/gate/sandbox artifacts. | Supported as a lineage and system-positioning statement. | 4.0 source is not evidence for 6.7B AU behavior metrics. |
| Aegis remains the active-law activation layer adjacent to Civitas 6.7B. | Aegis paper positioning docs and the 6.7B active-law non-claim boundary. | Supported as a paper boundary. | Do not claim active-law activation as the 6.7B contribution. |
| The AU bundle is paper-evidence-ready. | `QA_FINAL_PAPER_EVIDENCE.md`, readiness JSON/Markdown, run manifest. | Supported: final QA verdict and readiness status are `paper_evidence_ready`. | Readiness is evidence admissibility, not broad behavioral superiority. |
| Civitas 6.7B implements a governed improvement lifecycle. | Failure clusters, candidate artifacts, gate rows, sandbox promotion artifacts, held-out/stress artifacts, Figure 1. | Supported for the AU bundle: 8 archived clusters, 8 candidates, 8 gate rows, and 8 sandbox promotions are present with split-labeled results. | Do not generalize beyond the archived AU lifecycle. |
| Governed sandbox approval is Cassius-backed. | Cassius challenge evidence, gate rows, candidate receipt linkage, governance containment summary. | Supported: Cassius required `8`, passed `8`, failed `0`, unavailable claim-supporting `0`. | Gate selectivity is not demonstrated because all 8 candidates were approved. |
| The benchmark preserves split isolation. | Task manifests, task hashes, leakage review, failure discovery inputs, held-out/stress result inputs, Figure 3. | Supported by frozen AU task lane and run inputs: 100 train, 100 held-out, 50 stress task rows. | Keep behavior claims AU-only and post-candidate for held-out/stress. |
| Governed candidate handling reduces selected held-out risk metrics. | Final behavior metrics, final held-out delta table, scored held-out rows, comparator metadata, scorer audits. | Supported narrowly for unsupported-claim, policy-violation, contradiction, and unsafe-action rates against the held-out Civitas 6.5B baseline. | Do not claim broad behavioral superiority because correct-control and regression deltas are unfavorable. |
| Stress risk containment is visible. | Final stress regression table, stress result rows, failure-mode summary. | Mixed: governed stress unsafe-action, policy-violation, and contradiction rates are zero; governed regression rate is `0.907500` against `0.880000` comparator rates. | Report stress regression visibility beside containment metrics. |
| Civitas preserves the production boundary in the paper run. | Final governance containment table, sandbox promotion rows, verifier output, readiness/QA reports. | Supported: production mutation `0`, unauthorized promotion `0`, sandbox-only promotion `8`. | Sandbox promotion is not production promotion. |
| The run is auditable enough for paper review. | Repro manifest, readiness reports, task/registry hashes, model/backend metadata, scoring audits, receipt completeness. | Supported for the evidence bundle with receipt completeness `1.000000`. | Replay reproducibility remains `not_available`. |
| Optional backend portability exists. | Real API or other backend rows, model metadata, backend-specific manifests. | Blocked for this bundle. | Skipped API lane is a non-claim. |

## Supporting Table Wiring

- Behavior claims route through Tables 3 and 4.
- Lifecycle and rejection claims route through Table 5 and rejection artifacts.
- Cassius, sandbox, and production-boundary claims route through Table 6.
- Stress/regression claims route through Table 7.
- Backend/portability claims route through Table 8.

## Claim Review Rule

Every assembled result paragraph must name:

1. the claim row above
2. the run class and comparator
3. the selected artifact paths
4. the limitation or blocker if required pass conditions are not met
