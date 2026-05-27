# AU Finance V1 Leakage Review

## Verdict

`PASS`

The frozen AU taskset passes the automated duplicate and cross-split
near-duplicate gate, and QA-C accepted the split review after one prompt
wording defect was fixed and all split hashes were regenerated.

## Inputs

| Split | Path | Rows | SHA-256 |
| --- | --- | ---: | --- |
| Train | `train_failures_100.jsonl` | 100 | `6d390bdf8bb3b3dfe209047fb0303886794aa010bcdc004490e380be39c3c3f8` |
| Held-out | `heldout_eval_100.jsonl` | 100 | `154a06208dcea0f7c078c33d80331f9e64c3bb1c0f11145634ea51f4a7450982` |
| Stress | `stress_50.jsonl` | 50 | `023beb5e17be9c50244cd6882ab1297c0f96ed880c858e430ef6c651e57e73c7` |

## Automated Checks

Command:

```bash
python3 paper_eval_6.7b/tasks/au_finance_v1/validate_au_taskset.py \
  --task-file paper_eval_6.7b/tasks/au_finance_v1/train_failures_100.jsonl \
  --task-file paper_eval_6.7b/tasks/au_finance_v1/heldout_eval_100.jsonl \
  --task-file paper_eval_6.7b/tasks/au_finance_v1/stress_50.jsonl
```

Result:

```text
PASS: validated 250 AU paper task row(s)
- heldout_eval: 100
- stress: 50
- train_failures: 100
```

The validator enforces:

- exact split labels per file
- unique task ids
- exact duplicate prompt rejection across splits
- cross-split near-duplicate prompt rejection at normalized similarity `0.92`
  or greater
- selected AU paper corpus and authority bindings
- source refs bound to the AU source map
- final rows with `synthetic_placeholder=false`
- no `PENDING_*`, `placeholder`, or `synthetic_` markers in final rows

## Scenario Matrix Review

| Review item | Result | Notes |
| --- | --- | --- |
| Train and held-out topics are separate | PASS | The builder uses distinct topic matrices per source family and split. |
| Stress pressure is separate from train/held-out pressure | PASS | Stress uses its own adversarial pressure set and topic set. |
| Held-out/stress rows are not candidate inputs | PASS | Existing runner split enforcement still bars these files from failure discovery and candidate generation. |
| Prompts do not print the expected control-action label | PASS | Expected actions are stored in row metadata; prompt text carries only the request pressure. |
| Manual red-team wording review | PASS | `paper_ready/QA_DATASET.md` records the review and fixed wording defect. |

## Blockers

No leakage blocker is open after QA-C. Later row edits must rerun this review
and update frozen hashes.
