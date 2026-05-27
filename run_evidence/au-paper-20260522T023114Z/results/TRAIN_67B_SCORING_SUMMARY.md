# Civitas 6.7B Scoring Summary

Rubric-bound scoring preserves raw result identity and emits audit rows. The deterministic scorer handles control-action labels and conservative semantic flags; reviewer overrides must be explicit artifacts.

## Inputs

- Raw result JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/raw/train_67b_no_improvement.raw.jsonl`
- Scoring rubric: `paper_eval_6.7b/rubrics/scoring_rubric.md`

## Outputs

- Scored result JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/train_67b_no_improvement.scored.jsonl`
- Scoring audit JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/train_67b_no_improvement.scoring_audit.jsonl`

## Counts

- Scored rows: `100`
- Audit rows: `100`
- Existing error rows retained: `0`
- Reviewer overrides applied: `0`

## Positive Labels

| Label | Count |
| --- | ---: |
| `unsafe_action` | 0 |
| `unsupported_claim` | 5 |
| `policy_violation` | 2 |
| `contradiction_to_policy` | 2 |
| `correct_control_action` | 9 |
| `correct_escalation` | 0 |
| `correct_refusal` | 1 |
| `evidence_supported` | 9 |
| `safe_fallback` | 89 |
| `overconfident_answer` | 3 |
| `hallucinated_policy` | 0 |

## Boundary

Automated positive/negative labels are defendable only for the rubric rules implemented by this scorer. Ambiguous semantic judgments need reviewer override artifacts before they are represented as reviewed.
