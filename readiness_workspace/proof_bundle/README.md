# AU Paper Proof Bundle Skeleton

This folder defines the shareable proof bundle layout for the final Australian
finance paper evidence run. It is a skeleton until the full AU run completes.

The bundle is evidence linkage, run artifacts, and verification metadata. It
must not contain secrets, private API keys, copied policy PDFs, or production
mutation artifacts.

## Intended Share Layout

| Path | Contents |
| --- | --- |
| `01_scope_authority/` | Claim boundary, AU registry snapshot, authority map, source refs, registry hash. |
| `02_tasks/` | Frozen AU task files, taskset manifest, task hashes, split leakage audit. |
| `03_configs_models/` | Frozen 6.5B/6.7B configs, model metadata, decode settings, scorer config refs. |
| `04_raw_runs/` | Raw baseline, held-out, stress, and execution receipts. |
| `05_scoring/` | Scored rows, rubric, scorer reports, adjudication audit. |
| `06_candidates_governance/` | Failure clusters, candidates, Cassius evidence, gate results, trust/replay evidence. |
| `07_sandbox_eval/` | Sandbox overlays, sandbox state, promotions, governed held-out/stress outputs. |
| `08_tables_figures/` | Aggregated CSVs, uncertainty outputs, paper tables, figures if used. |
| `09_verification/` | Run manifest, verifier output, readiness reports, hash checks. |
| `10_claims/` | Paper-facing claim summary and limitation notes derived from verified evidence. |

## Release Rules

- Copy or materialize only reviewed final evidence into this layout.
- Prefer manifests and content hashes over duplicated source-of-truth policy
  documents.
- Retain raw JSONL and scored JSONL artifacts used to create tables.
- Keep smoke and pilot artifacts visibly separate from the full paper bundle.
- Do not claim paper evidence unless `09_verification/` contains a passing
  paper verifier and a readiness report with `paper_evidence_ready`.

## Manifest

Start the final bundle manifest from `BUNDLE_MANIFEST_TEMPLATE.md`. Replace
every required marker with frozen artifact paths and hashes before release.
