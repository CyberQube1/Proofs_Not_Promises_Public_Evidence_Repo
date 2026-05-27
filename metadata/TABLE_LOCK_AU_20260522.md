# Civitas 6.7B AU Table Lock - 2026-05-22

## Selected Bundle

- Run directory:
  `paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z`
- QA verdict: `paper_evidence_ready`
- Lane: `local_reproducible` / `ollama` / `local` /
  `gemma4:e2b-it-q8_0`
- Scope: AU finance only

## Selected Table Artifacts

The paper result skeleton uses these verified table artifacts:

- `results/tables/final_behavior_metrics.csv`
- `results/tables/final_heldout_delta.csv`
- `results/tables/final_governance_containment.csv`
- `results/tables/final_candidate_lifecycle.csv`
- `results/tables/final_stress_regression.csv`
- `results/tables/behavior_metrics.csv` for task-count and latency cells not
  emitted by the long-form final behavior table

It also binds interpretation to:

- `QA_FINAL_PAPER_EVIDENCE.md`
- `results/readiness_report.md`
- `results/RESULTS_SUMMARY.md`
- `artifacts/cassius_challenge_evidence.jsonl`
- `artifacts/gate_results.jsonl`
- `artifacts/trust_region_gate_evidence.jsonl`
- `artifacts/replay_canary_evidence.jsonl`
- `sandbox/sandbox_promotions.jsonl`

## Locked AU Values

| Category | Locked value |
| --- | --- |
| Curated task rows | 100 train, 100 held-out, 50 stress |
| Production mutation count | 0 |
| Unauthorized promotion count | 0 |
| Sandbox-only promotion count | 8 |
| Cassius required / passed | 8 / 8 |
| Cassius unavailable claim-supporting count | 0 |
| Receipt completeness rate | 1.000000 |
| Replay reproducibility rate | `not_available` |
| Candidate lifecycle | 8 generated, 0 rejected, 8 sandbox-approved, 8 sandbox-promoted |

## Locked Held-Out Interpretation

| Metric | Civitas 6.5B baseline | Governed path | Direction |
| --- | ---: | ---: | --- |
| `unsafe_action_rate` | 0.020000 | 0.017500 | favorable selected-risk delta |
| `unsupported_claim_rate` | 0.110000 | 0.057500 | favorable selected-risk delta |
| `policy_violation_rate` | 0.030000 | 0.017500 | favorable selected-risk delta |
| `contradiction_to_policy_rate` | 0.010000 | 0.000000 | favorable selected-risk delta |
| `correct_control_action_rate` | 0.050000 | 0.042500 | unfavorable |
| `regression_rate` | 0.950000 | 0.957500 | unfavorable |

## Locked Stress Interpretation

- Governed stress `unsafe_action_rate = 0.000000`.
- Governed stress `policy_violation_rate = 0.000000`.
- Governed stress `contradiction_to_policy_rate = 0.000000`.
- Governed stress `regression_rate = 0.907500`.
- Baseline and no-improvement stress `regression_rate = 0.880000`.

## Table-Lock Exclusions

Do not fill paper result tables from smoke outputs, skipped API rows, EU rows,
unverified recomputations, or production-promotion assumptions. Do not convert
the `paper_evidence_ready` verdict into a significance, portability, replay,
or broad superiority claim.
