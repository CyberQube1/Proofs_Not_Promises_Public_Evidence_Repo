# Reproduction Guide

This pack is designed for a reviewer who has access to a compatible Civitas
6.7B checkout and the local model/runtime lane used by the paper run.

## Authoritative Evidence

The manuscript's locked values are bound to:

`run_evidence/au-paper-20260522T023114Z/`

The main paper tables are mirrored in:

`tables/`

Legacy pilot results and workspace notes are included for transparency, but
they are not authoritative for the manuscript's final numerical claims.

## What a Reviewer Can Inspect Directly

- AU task rows: `taskset/`
- Task authoring and leakage controls: `validation/`, `scripts/taskset/`
- Candidate lifecycle artifacts: `run_evidence/.../artifacts/`
- Cassius, gate, trust-region, replay, and sandbox records:
  `run_evidence/.../artifacts/` and `run_evidence/.../sandbox/`
- Raw model outputs: `run_evidence/.../raw/`
- Scored rows: `run_evidence/.../scored/`
- Scoring audits: `run_evidence/.../artifacts/*.scoring_audit.jsonl`
- Final result tables: `run_evidence/.../results/tables/` and `tables/`
- Aggregation/scoring scripts: `scripts/eval/`
- Reproduction wrappers and readiness checks: `scripts/repro/`
- JSON schemas: `schemas/`
- Paper source and QA notes: `manuscript_workspace/`

## What Is Needed to Rerun

A rerun requires:

- the Civitas 6.7B research checkout compatible with these scripts;
- Python dependencies used by the evaluation harness;
- local Ollama/Gemma execution configured as in `scripts/repro/AU_PAPER_ENV.sh`;
- access to any source-corpus references needed by the AU taskset;
- sufficient local compute to execute baseline, no-improvement, governed,
  held-out, and stress lanes.

The pack does not provide production credentials, hosted model-provider
credentials, live authority services, production promotion rights, or model
binary distribution.

## Suggested Verification Order

1. Run `bash verification/verify_public_pack.sh` from this directory.
2. Inspect `run_evidence/au-paper-20260522T023114Z/MANIFEST.md`.
3. Inspect `run_evidence/au-paper-20260522T023114Z/QA_FINAL_PAPER_EVIDENCE.md`.
4. Compare `tables/` against `run_evidence/.../results/tables/`.
5. Inspect task rows and leakage notes under `taskset/` and `validation/`.
6. Inspect scoring logic in `scripts/eval/score_results.py`.
7. Inspect aggregation logic in `scripts/eval/aggregate_results.py`.
8. Inspect candidate, Cassius, gate, trust-region, and sandbox artifacts under
   `run_evidence/.../artifacts/` and `run_evidence/.../sandbox/`.
9. If runtime access is available, use the wrappers in `scripts/repro/` as the
   starting point for rerun attempts.

## Claim Boundary

Successful inspection or rerun of this pack supports only the bounded AU local
Ollama/Gemma evidence lane. It does not establish API portability, EU results,
production promotion, live production self-modification, statistical
significance, replay reproducibility, proven gate selectivity, broad behavioral
superiority, or general safe autonomous self-improvement.
