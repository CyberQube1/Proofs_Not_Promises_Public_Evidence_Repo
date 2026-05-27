# AU Finance V1 Taskset Manifest

## Identity

| Field | Value |
| --- | --- |
| Taskset id | `au_finance_v1` |
| Status | `frozen_after_QA-C` |
| Paper corpus id | `au_finance_paper_scope` |
| Registry SHA-256 | `913bffd4bff4e296a61ea5cfd8f3d96a899910117f0524068a94b1ce4f84ecdc` |
| Source map SHA-256 | `295ee38e2167320edd12a35c3c57b666bc5a4426c0ad24e32bea4f5049ae153e` |
| Task schema SHA-256 | `71fa3a81d37723d16842889e2d9a7fd86947ab3b3f62e056954a0d5177559675` |
| Materializer | `build_taskset.py` |

`frozen_after_QA-C` means the full `100/100/50` task files exist, validate,
and passed the dataset red-team review in
`../../paper_ready/QA_DATASET.md`. Later row edits must be rematerialized,
revalidated, and rehashed before pilot or full paper runs.

## Split Files

| Split | Path | Rows | SHA-256 |
| --- | --- | ---: | --- |
| `train_failures` | `train_failures_100.jsonl` | 100 | `6d390bdf8bb3b3dfe209047fb0303886794aa010bcdc004490e380be39c3c3f8` |
| `heldout_eval` | `heldout_eval_100.jsonl` | 100 | `154a06208dcea0f7c078c33d80331f9e64c3bb1c0f11145634ea51f4a7450982` |
| `stress` | `stress_50.jsonl` | 50 | `023beb5e17be9c50244cd6882ab1297c0f96ed880c858e430ef6c651e57e73c7` |

## Bucket Counts

| Split | Unsafe action | Unsupported claim | Ambiguous escalation | Policy conflict | Adversarial paraphrase | Repeat failure |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `train_failures` | 20 | 16 | 16 | 16 | 16 | 16 |
| `heldout_eval` | 20 | 16 | 16 | 16 | 16 | 16 |
| `stress` | 10 | 8 | 8 | 8 | 8 | 8 |

## Source Scope

- AU finance baseline only.
- APRA CPS 234 and ASIC RG 234/RG 271/RG 274 task refs come from
  `AU_SOURCE_MAP.yaml`.
- No task row uses EU metadata.
- No task row uses the unresolved standalone APRA or ASIC registry lanes.
- Source policy documents are not copied into this task folder.

## Validation Evidence

The curation candidate passed:

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

`LEAKAGE_REVIEW.md` records the current automated and task-matrix review.

## QA

QA-C accepted:

- policy-basis phrasing against allowed AU source families
- governed-agent character rather than policy recall
- post-fix task prompt quality
- train/held-out/stress separation and leakage controls
