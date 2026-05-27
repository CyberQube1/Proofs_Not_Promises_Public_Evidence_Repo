# Failure Discovery Summary

Research-only failure clustering for governed self-improvement training evidence. This phase does not generate candidates, promote artifacts, or mutate production state.

## Inputs

- Result JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/train_67b_no_improvement.scored.jsonl`
- Task JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/train_failures_100.jsonl`
- Result rows read: `100`
- Failure clusters emitted: `8`

## Clusters

| Cluster | Failure type | Count | Severity | Policy corpus | Task buckets |
| --- | --- | ---: | --- | --- | --- |
| `failure-cluster-unsupported_claim-128ae5329d87` | `unsupported_claim` | 5 | `medium` | `au_finance_paper_scope` | `policy_conflict_or_supersession, unsupported_compliance_claim` |
| `failure-cluster-policy_violation-7f2a25a92b55` | `policy_violation` | 2 | `high` | `au_finance_paper_scope` | `policy_conflict_or_supersession` |
| `failure-cluster-contradiction_to_policy-c2668764323e` | `contradiction_to_policy` | 2 | `high` | `au_finance_paper_scope` | `policy_conflict_or_supersession` |
| `failure-cluster-incorrect_escalation-8926c8260e78` | `incorrect_escalation` | 100 | `medium` | `au_finance_paper_scope` | `adversarial_paraphrase, ambiguous_escalation, policy_conflict_or_supersession, repeat_failure_pattern, unsafe_action_bait, unsupported_compliance_claim` |
| `failure-cluster-incorrect_refusal-6cde5c9bc06c` | `incorrect_refusal` | 99 | `medium` | `au_finance_paper_scope` | `adversarial_paraphrase, ambiguous_escalation, policy_conflict_or_supersession, repeat_failure_pattern, unsafe_action_bait, unsupported_compliance_claim` |
| `failure-cluster-evidence_gap-c91009b7c3f2` | `evidence_gap` | 91 | `low` | `au_finance_paper_scope` | `adversarial_paraphrase, ambiguous_escalation, policy_conflict_or_supersession, repeat_failure_pattern, unsafe_action_bait, unsupported_compliance_claim` |
| `failure-cluster-overconfident_answer-63a2776251ac` | `overconfident_answer` | 3 | `medium` | `au_finance_paper_scope` | `policy_conflict_or_supersession, unsupported_compliance_claim` |
| `failure-cluster-repeat_failure_pattern-d7f965cad7e5` | `repeat_failure_pattern` | 16 | `medium` | `au_finance_paper_scope` | `repeat_failure_pattern` |

## Inspectability

Cluster hashes are SHA3-256 digests of canonical cluster content excluding the `cluster_hash` field. Inspect `evidence_refs` and `representative_examples` in the JSONL before using any cluster as a train-split improvement target.
