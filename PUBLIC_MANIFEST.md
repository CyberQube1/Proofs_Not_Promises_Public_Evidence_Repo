# Public Manifest

## Package

- Name: Civitas 6.7B AU public evidence pack
- Status: reproduction-oriented release candidate
- Created: 2026-05-24
- Source commit: `0af6f33f6b341e80ec878e88d707892ff1f48250`
- Locked source run: `paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z`

## Included Tables

- `tables/final_behavior_metrics.csv`
- `tables/final_candidate_lifecycle.csv`
- `tables/final_governance_containment.csv`
- `tables/final_heldout_delta.csv`
- `tables/final_stress_regression.csv`

## Included Summaries

- `summaries/MANIFEST.redacted.md`
- `summaries/QA_FINAL_PAPER_EVIDENCE.redacted.md`
- `summaries/FINAL_RESULTS_SUMMARY.redacted.md`
- `summaries/readiness_report.redacted.md`
- `summaries/PUBLIC_READINESS_SUMMARY.md`

## Included Metadata

- `metadata/CLAIM_TO_EVIDENCE_MAP.md`
- `metadata/EVIDENCE_BOUND_RESULTS.md`
- `metadata/TABLE_LOCK_AU_20260522.md`

## Included Reproduction Materials

- `taskset/train_failures_100.jsonl`
- `taskset/heldout_eval_100.jsonl`
- `taskset/stress_50.jsonl`
- `taskset/pilot_train_one.jsonl`
- `taskset/AU_SOURCE_MAP.yaml`
- `taskset/TASKSET_MANIFEST.md`
- `taskset/LEAKAGE_REVIEW.md`
- `run_evidence/au-paper-20260522T023114Z/`
- `scripts/eval/`
- `scripts/repro/`
- `scripts/taskset/`
- `schemas/`
- `validation/`
- `governance/`
- `verification/`
- `method_docs/`
- `manuscript_workspace/`
- `readiness_workspace/`
- `legacy_results/`
- `legacy_artifacts/`
- `policy_corpora/`
- `top_level_files/`

## Excluded Evidence Index

- `excluded_hashes/SOURCE_FILE_HASHES.tsv`

## Release Notes

This package includes the locked AU task rows, run evidence, scripts, schemas,
and result tables needed to inspect the paper's reported values and rerun the
pipeline in a compatible Civitas 6.7B environment. It intentionally excludes
production credentials, hosted model-provider credentials, private source
documents, live authority services, and any production-promotion capability.
The included workspace notes and legacy artifacts are supplied for method
transparency; the paper's locked numerical claims remain bound to the
`run_evidence/au-paper-20260522T023114Z/` bundle and final tables.
