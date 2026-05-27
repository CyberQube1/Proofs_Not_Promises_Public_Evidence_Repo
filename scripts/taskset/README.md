# AU Finance V1 Taskset

This folder is the final-task curation lane for the first Civitas 6.7B paper
evidence run.

The taskset is not frozen yet. Prompt 13A adds the allowed AU source map,
validator, leakage controls, and manifest contract before the final rows are
curated. The current `100/100/50` rows are frozen after QA-C for real execution
work.

## Inputs

- `AU_SOURCE_MAP.yaml` limits final task provenance to APRA/ASIC source indexes
  contained by the frozen Praxis `baseline-au-finance` bundle.
- `validate_au_taskset.py` checks schema validity, selected-registry binding,
  final-row provenance, placeholder exclusion, split labels, duplicates, and
  cross-split near-duplicate prompts.
- `TASK_AUTHORING_CONTROLS.md` defines the curation review surface.
- `TASK_AUTHORING_NOTES.md` explains the scenario matrix used to materialize
  the current curation candidate.
- `build_taskset.py` materializes the current flat JSONL files.
- `TASKSET_MANIFEST_TEMPLATE.md` defines the hash and review manifest required
  before task files are used for evidence.
- `LEAKAGE_REVIEW_TEMPLATE.md` records split review after all three files
  exist.

## Final Files

The evidence taskset must eventually contain:

- `train_failures_100.jsonl`
- `heldout_eval_100.jsonl`
- `stress_50.jsonl`
- `TASKSET_MANIFEST.md`, marked `frozen_after_QA-C`
- `LEAKAGE_REVIEW.md`, marked `PASS`

Do not use the placeholder root task files as paper evidence.
