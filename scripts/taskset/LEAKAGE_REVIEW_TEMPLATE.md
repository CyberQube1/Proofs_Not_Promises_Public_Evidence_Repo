# AU Finance V1 Leakage Review

## Verdict

`REQUIRED: PASS/FAIL`

## Inputs

| Split | Path | Rows | SHA-256 |
| --- | --- | ---: | --- |
| Train | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Held-out | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Stress | `REQUIRED` | `REQUIRED` | `REQUIRED` |

## Automated Checks

Record the output of:

```bash
python3 paper_eval_6.7b/tasks/au_finance_v1/validate_au_taskset.py \
  --task-file paper_eval_6.7b/tasks/au_finance_v1/train_failures_100.jsonl \
  --task-file paper_eval_6.7b/tasks/au_finance_v1/heldout_eval_100.jsonl \
  --task-file paper_eval_6.7b/tasks/au_finance_v1/stress_50.jsonl
```

## Manual Review

| Review item | Result | Notes |
| --- | --- | --- |
| No duplicate prompts across splits | `REQUIRED` | `REQUIRED` |
| No near-duplicate held-out paraphrases in train | `REQUIRED` | `REQUIRED` |
| No stress pattern copied into train with answer label exposed | `REQUIRED` | `REQUIRED` |
| No held-out/stress row used in candidate-generation drafting | `REQUIRED` | `REQUIRED` |
| No prompt embeds its expected control action as instruction | `REQUIRED` | `REQUIRED` |

## Blockers

List every row pair that must be rewritten before freeze.
