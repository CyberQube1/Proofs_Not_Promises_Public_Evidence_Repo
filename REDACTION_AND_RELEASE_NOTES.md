# Redaction and Release Notes

## Publicly Included

- Final locked result tables.
- Redacted QA/readiness/result summaries.
- Paper-facing claim maps and locked-value notes.
- SHA-256 hashes and byte counts for excluded source files.
- Locked AU task rows and source map.
- Complete locked AU run evidence, including raw outputs, scored rows,
  scoring audits, candidate artifacts, Cassius/gate/trust-region evidence,
  sandbox records, and result summaries.
- Evaluation, reproduction, and taskset scripts.
- JSON schemas, scoring rubric, validation notes, and verification helper.
- Runbooks, paper QA notes, proof-bundle planning, policy-corpus scope files,
  legacy pilot outputs, and manuscript source/build artifacts.

## Excluded From Public Pack

The following categories are not included in this public package:

- private source policy documents referenced by the AU source map;
- production credentials or hosted model-provider credentials;
- live production governance services or authority lanes;
- model binaries, Ollama runtime state, or machine-local dependency caches;
- any production-promotion right or live self-modification capability.

## Reason for Exclusion

The pack is intentionally broad enough to support external reproduction by a
reviewer who has the compatible Civitas 6.7B checkout, runtime dependencies,
local Ollama/Gemma lane, and any required source-corpus access. Items excluded
above are operational capabilities or source materials, not paper evidence
tables.
Workspace notes and legacy artifacts are included for inspection, but they do
not override the locked run bundle. If a value differs between a legacy/pilot
file and `run_evidence/au-paper-20260522T023114Z/`, the locked run evidence and
final tables are authoritative for the manuscript.

## Hash-Based Verification

`MANIFEST.sha256` records hashes for files included in this public pack.
`excluded_hashes/SOURCE_FILE_HASHES.tsv` records SHA-256 hashes, byte counts,
and public-release status for source files from the earlier redacted-pack
review. The complete `run_evidence/` directory now includes the locked AU run
evidence used to support the paper tables.

## Public Pack Limitation

This pack is not a standalone executable environment. It is sufficient to
inspect the locked AU evidence and is intended to support rerun attempts by a
reviewer with Civitas 6.7B/runtime access and the local model lane. Replay
reproducibility remains unavailable as a paper result unless a separate rerun
successfully reproduces the locked outputs.
