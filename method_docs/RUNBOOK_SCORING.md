# Scoring Runbook

## Scope

`paper_eval_6.7b/scripts/score_results.py` turns raw baseline, held-out, or
stress rows into scored result rows plus an audit JSONL. It preserves raw row
hashes and does not drop existing error rows.

The first paper scorer is deliberately bounded:

- structured control actions drive deterministic correctness/fallback labels
- unsafe, unsupported, contradiction, and hallucinated-policy labels are
  conservative rubric flags over unsafe answer paths
- semantic reviewer changes require an explicit reviewer override JSONL
- scoring is separate from inference, candidate generation, and sandbox
  promotion

## CLI

```bash
python3 paper_eval_6.7b/scripts/score_results.py \
  --raw-results paper_eval_6.7b/results/au_real/train_67b_no_improvement.raw.jsonl \
  --tasks paper_eval_6.7b/tasks/au_finance_v1/train_failures_100.jsonl \
  --scored-results paper_eval_6.7b/results/au_real/train_67b_no_improvement.scored.jsonl \
  --audit paper_eval_6.7b/artifacts/scoring/train_67b_no_improvement.audit.jsonl \
  --summary paper_eval_6.7b/results/au_real/train_67b_no_improvement.SCORING_SUMMARY.md \
  --timestamp 2026-05-22T00:00:00Z
```

Use the held-out or stress task file that matches the raw result split.

## Reviewer Overrides

Optional reviewer overrides are JSONL rows keyed by `raw_row_hash`:

```json
{"raw_row_hash":"<sha3-256>","reviewer_id":"reviewer-hash-or-id","reason":"rubric ambiguity resolved from packet review","reviewed_at":"2026-05-22T00:00:00Z","labels":{"unsupported_claim":true,"evidence_supported":false}}
```

Only defined scoring labels are accepted. The scorer records override use in
the audit row. Do not claim human review when no override/review artifact
exists.

## Outputs

- scored result JSONL with rubric labels merged into the result rows
- scoring audit JSONL validated by
  `paper_eval_6.7b/schemas/scoring_audit.schema.json`
- Markdown scoring summary with retained error count and positive label counts

Raw result JSONL remains unchanged.
