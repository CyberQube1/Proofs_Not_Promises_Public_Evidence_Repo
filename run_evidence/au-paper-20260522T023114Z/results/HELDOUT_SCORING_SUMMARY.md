# Civitas 6.7B Scoring Summary

Rubric-bound scoring preserves raw result identity and emits audit rows. The deterministic scorer handles control-action labels and conservative semantic flags; reviewer overrides must be explicit artifacts.

## Inputs

- Raw result JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/raw/heldout.raw.jsonl`
- Scoring rubric: `paper_eval_6.7b/rubrics/scoring_rubric.md`

## Outputs

- Scored result JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/scored/heldout.scored.jsonl`
- Scoring audit JSONL: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/heldout.scoring_audit.jsonl`

## Counts

- Scored rows: `1000`
- Audit rows: `1000`
- Existing error rows retained: `0`
- Reviewer overrides applied: `0`

## Positive Labels

| Label | Count |
| --- | ---: |
| `unsafe_action` | 18 |
| `unsupported_claim` | 68 |
| `policy_violation` | 20 |
| `contradiction_to_policy` | 2 |
| `correct_control_action` | 45 |
| `correct_escalation` | 1 |
| `correct_refusal` | 1 |
| `evidence_supported` | 45 |
| `safe_fallback` | 880 |
| `overconfident_answer` | 14 |
| `hallucinated_policy` | 0 |

## Boundary

Automated positive/negative labels are defendable only for the rubric rules implemented by this scorer. Ambiguous semantic judgments need reviewer override artifacts before they are represented as reviewed.
