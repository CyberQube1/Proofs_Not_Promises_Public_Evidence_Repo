# Civitas 6.7B Paper Eval Results Summary

## Run Type

`full`

## Input Artifacts Used

| Artifact type | Path | Status | Row count |
| --- | --- | --- | ---: |
| baseline_results | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/train_65b.scored.jsonl` | `available` | 100 |
| baseline_results | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/train_67b_no_improvement.scored.jsonl` | `available` | 100 |
| failure_clusters | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/failure_clusters.jsonl` | `available` | 8 |
| candidates | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/candidates.jsonl` | `available` | 8 |
| gate_results | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/gate_results.jsonl` | `available` | 8 |
| trust_region_evidence | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/trust_region_gate_evidence.jsonl` | `available` | 8 |
| replay_canary_evidence | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/replay_canary_evidence.jsonl` | `available` | 8 |
| sandbox_promotions | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/sandbox/sandbox_promotions.jsonl` | `available` | 8 |
| heldout_results | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/heldout.scored.jsonl` | `available` | 1000 |
| stress_results | `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/stress.scored.jsonl` | `available` | 500 |

Generated tables:
- `behavior_metrics`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/behavior_metrics.csv`
- `candidate_lifecycle`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/candidate_lifecycle.csv`
- `rejection_reasons`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/rejection_reasons.csv`
- `governance_containment`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/governance_containment.csv`
- `heldout_delta`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/heldout_delta.csv`
- `final_behavior_metrics`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_behavior_metrics.csv`
- `final_heldout_delta`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_heldout_delta.csv`
- `final_governance_containment`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_governance_containment.csv`
- `final_candidate_lifecycle`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_candidate_lifecycle.csv`
- `final_stress_regression`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_stress_regression.csv`

## Behavior Metrics Summary

Behavior metrics count result rows by phase, comparator lane metadata, and condition. Candidate-bound governed rows remain separate result rows.
Explicit skipped API comparator rows excluded from behavior rates: `0`.

| Phase | Run family | Provider | Backend | Model id | Condition | Rows | Errors | Unsafe rate | Correct action rate | Regression rate |
| --- | --- | --- | --- | --- | --- | ---: | ---: | --- | --- | --- |
| baseline | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_5b_baseline | 100 | 0 | 0.010000 | 0.090000 | not_available |
| baseline | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_7b_no_improvement | 100 | 0 | 0.000000 | 0.090000 | not_available |
| heldout_eval | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_5b_baseline | 100 | 0 | 0.020000 | 0.050000 | 0.950000 |
| heldout_eval | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_7b_governed_improvement | 800 | 0 | 0.017500 | 0.042500 | 0.957500 |
| heldout_eval | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_7b_no_improvement | 100 | 0 | 0.020000 | 0.060000 | 0.940000 |
| stress_eval | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_5b_baseline | 50 | 0 | 0.040000 | 0.120000 | 0.880000 |
| stress_eval | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_7b_governed_improvement | 400 | 0 | 0.000000 | 0.092500 | 0.907500 |
| stress_eval | local_reproducible | ollama | local | gemma4:e2b-it-q8_0 | civitas_6_7b_no_improvement | 50 | 0 | 0.000000 | 0.120000 | 0.880000 |

## Candidate Lifecycle Summary

| Generated | Rejected | Needs evidence | Approved for sandbox | Sandbox promoted | Failed apply |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 8 | 0 | 0 | 8 | 8 | 0 |

Lifecycle rates use generated candidate count as denominator where that input is available.

## Governance Containment Summary

| Unauthorized promotions | Production mutations | Sandbox-only promotions | Cassius required | Cassius passed | Cassius failed | Cassius unavailable | Claim-supporting Cassius unavailable | Receipt completeness | Replay reproducibility |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| 0 | 0 | 8 | 8 | 8 | 0 | 0 | 0 | 1.000000 | not_available |

Receipt completeness covers available behavior, governance-gate, and sandbox promotion rows with receipt fields. Replay reproducibility stays not_available until replay/canary evidence includes replay passed/failed rows.

## Held-Out Delta Summary

| Metric | Baseline | Governed improvement | Absolute delta | Interpretation |
| --- | --- | --- | --- | --- |
| unsafe_action_rate | 0.020000 | 0.017500 | -0.002500 | governed risk metric is lower; directionally favorable |
| unsupported_claim_rate | 0.110000 | 0.057500 | -0.052500 | governed risk metric is lower; directionally favorable |
| policy_violation_rate | 0.030000 | 0.017500 | -0.012500 | governed risk metric is lower; directionally favorable |
| contradiction_to_policy_rate | 0.010000 | 0.000000 | -0.010000 | governed risk metric is lower; directionally favorable |
| correct_control_action_rate | 0.050000 | 0.042500 | -0.007500 | governed correct-control rate changed; directionally unfavorable |
| safe_fallback_rate | 0.810000 | 0.897500 | 0.087500 | governed safe-fallback rate changed; interpret with task control-action mix |
| regression_rate | 0.950000 | 0.957500 | 0.007500 | governed risk metric is higher; directionally unfavorable |
| mean_latency_ms | 7205.100000 | 6591.758750 | -613.341250 | governed mean latency is lower |

## Stress Regression Summary

| Condition | Rows | Regression rows | Error rows |
| --- | ---: | ---: | ---: |
| civitas_6_5b_baseline | 50 | 44 | 0 |
| civitas_6_7b_governed_improvement | 400 | 363 | 0 |
| civitas_6_7b_no_improvement | 50 | 44 | 0 |

## Limitations

- Run type is `full`. Only a full curated run may support final paper tables.
- Smoke and placeholder outputs are harness evidence only; they are not paper evidence.
- Replay reproducibility is `not_available` until replay rerun artifacts are added and aggregated.
- Statistical significance tests are not implemented here, so no significance claim is emitted.
- Missing optional JSONL inputs remain visible in the input table and unavailable cells.
- Sandbox approval and sandbox promotion are not production approval.
