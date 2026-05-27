# Civitas 6.7B Paper Evidence Readiness Report

## Status

- Requested mode: `paper`
- Readiness status: `paper_evidence_ready`
- Checked at: `2026-05-22T06:26:28Z`

## Claim Boundary

This checker inspects scaffold and artifact readiness only. It does not generate benchmark evidence, promote candidates, call production governance mutation paths, or make smoke artifacts paper evidence.

## Inputs

- Registry: `/home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/policy_corpus_registry.yaml`
- Task files: `/home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/train_failures_100.jsonl, /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/heldout_eval_100.jsonl, /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/stress_50.jsonl`
- Cassius evidence: `/home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/cassius_challenge_evidence.jsonl`
- Run directory: `/home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z`
- API portability claim: `False`
- API backend enabled: `False`
- API skip reason: `api_backend_not_configured`

## Checks

| Check | Status | Detail |
| --- | --- | --- |
| `registry_file` | `pass` | policy corpus registry exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/policy_corpus_registry.yaml |
| `registry_parse` | `pass` | parsed 5 registry entries |
| `registry_required_entries` | `pass` | registry includes au_finance_baseline, asic, apra, and eu entries |
| `registry_pending_refs` | `warn` | registry contains unresolved PENDING refs at entries.au_finance_baseline.aegis_active_law_hash, entries.au_finance_baseline.active_law_epoch_id, entries.au_finance_baseline.active_law_epoch_root, entries.au_finance_baseline.active_law_epoch_sequence_root, entries.au_finance_baseline.active_law_epoch_sequence_index, and 60 more |
| `eu_registry_status` | `warn` | EU registry lane remains planned or placeholder and cannot support an EU readiness claim |
| `task_schema` | `pass` | task schema exists: /home/spqr-admin/civitas/paper_eval_6.7b/tasks/schema/task.schema.json |
| `task_file_exists` | `pass` | task file exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/train_failures_100.jsonl |
| `task_schema_validation` | `pass` | /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/train_failures_100.jsonl has 100 schema-valid task row(s) |
| `task_file_exists` | `pass` | task file exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/heldout_eval_100.jsonl |
| `task_schema_validation` | `pass` | /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/heldout_eval_100.jsonl has 100 schema-valid task row(s) |
| `task_file_exists` | `pass` | task file exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/stress_50.jsonl |
| `task_schema_validation` | `pass` | /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/inputs/stress_50.jsonl has 50 schema-valid task row(s) |
| `task_rows_present` | `pass` | loaded 250 task row(s) |
| `task_placeholder_status` | `pass` | selected task rows are not placeholder-labelled |
| `task_registry_linkage` | `pass` | selected task rows reference known registry corpus IDs |
| `claim_task_source_refs` | `pass` | claim-supporting task rows use non-placeholder source refs |
| `claim_task_pending_refs` | `pass` | claim-supporting task rows have no PENDING task fields |
| `claim_registry_refs_resolved` | `pass` | linked registry entries have no unresolved PENDING refs |
| `claim_active_law_hash` | `pass` | claim-supporting tasks bind non-placeholder active-law hashes |
| `claimed_optional_hashes` | `pass` | claimed policy-graph and trust-region task hashes are non-placeholder |
| `cassius_gate_contract` | `pass` | gate schema, runner, and verifier preserve receipt-bound fail-closed Cassius approval checks |
| `cassius_evidence` | `pass` | Cassius evidence JSONL has 8 receipt-bound row(s): /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/artifacts/cassius_challenge_evidence.jsonl |
| `repro_manifest` | `pass` | repro_manifest exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/MANIFEST.md |
| `repro_verify_script` | `pass` | repro_verify_script exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/VERIFY_RESULTS.sh |
| `run_dir` | `pass` | run directory exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z |
| `run_manifest` | `pass` | run manifest exists: /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/MANIFEST.md |
| `paper_run_boundary` | `pass` | paper mode run manifest is not smoke-labelled |
| `paper_model_manifest` | `pass` | paper mode run manifest freezes provider/backend/run-family/API/decode metadata |
| `governance_containment_counts` | `pass` | run containment table reports production_mutation_count=0 and unauthorized_promotion_count=0 |
| `sandbox_only_contract` | `pass` | sandbox promotion schema fixes sandbox_only=true and production_mutation=false |
| `sandbox_state_marker` | `pass` | sandbox state marker is present and production_mutation=false |
| `comparator_metadata_contract` | `pass` | baseline/held-out schemas and eval runner preserve comparator metadata and API skip flags |
| `api_portability_claim` | `warn` | API portability is excluded from claims; optional lane skip reason is api_backend_not_configured |
| `paper_repro_verifier` | `pass` | VERIFY_AU_PAPER_RESULTS.sh passed for /home/spqr-admin/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z |

## Blocking Gaps

- none

## Warnings

- registry contains unresolved PENDING refs at entries.au_finance_baseline.aegis_active_law_hash, entries.au_finance_baseline.active_law_epoch_id, entries.au_finance_baseline.active_law_epoch_root, entries.au_finance_baseline.active_law_epoch_sequence_root, entries.au_finance_baseline.active_law_epoch_sequence_index, and 60 more
- EU registry lane remains planned or placeholder and cannot support an EU readiness claim
- API portability is excluded from claims; optional lane skip reason is api_backend_not_configured

## Allowed Claims

- paper-evidence run readiness for the selected curated task and repro bundle
- local model lane readiness with frozen comparator metadata

## Disallowed Claims

- API/frontier portability claim is explicitly excluded

## Next Required Actions

- Execute the selected paper-evidence run and archive its verified manifests and artifacts.
