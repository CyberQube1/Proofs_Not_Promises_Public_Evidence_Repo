# AU Finance V1 Taskset Manifest

## Identity

| Field | Value |
| --- | --- |
| Taskset id | `au_finance_v1` |
| Status | `REQUIRED: draft/pilot/frozen` |
| Paper corpus id | `au_finance_paper_scope` |
| Registry hash | `REQUIRED` |
| Source map hash | `REQUIRED` |
| Schema hash | `REQUIRED` |
| Frozen at | `REQUIRED` |

## Split Files

| Split | Path | Rows | SHA-256 |
| --- | --- | ---: | --- |
| `train_failures` | `train_failures_100.jsonl` | `100` | `REQUIRED` |
| `heldout_eval` | `heldout_eval_100.jsonl` | `100` | `REQUIRED` |
| `stress` | `stress_50.jsonl` | `50` | `REQUIRED` |

## Source Scope

- AU finance baseline only.
- APRA CPS 234 and ASIC RG 234/RG 271/RG 274 task refs must come from
  `AU_SOURCE_MAP.yaml`.
- No EU rows.
- No standalone APRA or ASIC active-corpus claim.

## Validation Evidence

| Check | Command | Result |
| --- | --- | --- |
| Schema, provenance, and split checks | `python3 paper_eval_6.7b/tasks/au_finance_v1/validate_au_taskset.py --task-file ...` | `REQUIRED` |
| Leakage review | `LEAKAGE_REVIEW.md` | `REQUIRED` |
| Paper readiness task check | `bash paper_eval_6.7b/repro/CHECK_PAPER_READINESS.sh --mode paper --tasks ...` | `REQUIRED` |

## Review Signoff

| Review | Reviewer/ref | Timestamp | Notes |
| --- | --- | --- | --- |
| Source authority | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Control-action rubric | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Split leakage | `REQUIRED` | `REQUIRED` | `REQUIRED` |
