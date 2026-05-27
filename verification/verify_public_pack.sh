#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "[verify] checking included-file hashes"
sha256sum -c MANIFEST.sha256

echo "[verify] checking required directories"
for path in \
  tables \
  summaries \
  metadata \
  taskset \
  run_evidence/au-paper-20260522T023114Z \
  scripts/eval \
  scripts/repro \
  scripts/taskset \
  schemas \
  validation \
  governance; do
  test -e "$path"
done

echo "[verify] checking required evidence files"
for path in \
  taskset/train_failures_100.jsonl \
  taskset/heldout_eval_100.jsonl \
  taskset/stress_50.jsonl \
  taskset/AU_SOURCE_MAP.yaml \
  run_evidence/au-paper-20260522T023114Z/MANIFEST.md \
  run_evidence/au-paper-20260522T023114Z/results/tables/final_heldout_delta.csv \
  run_evidence/au-paper-20260522T023114Z/results/tables/final_stress_regression.csv \
  run_evidence/au-paper-20260522T023114Z/artifacts/candidates.jsonl \
  run_evidence/au-paper-20260522T023114Z/artifacts/cassius_challenge_evidence.jsonl \
  run_evidence/au-paper-20260522T023114Z/artifacts/gate_results.jsonl \
  run_evidence/au-paper-20260522T023114Z/sandbox/sandbox_promotions.jsonl \
  scripts/repro/RUN_AU_PAPER.sh \
  scripts/eval/score_results.py \
  scripts/taskset/validate_au_taskset.py; do
  test -f "$path"
done

echo "[verify] scanning for common credential markers"
if grep -RInE --exclude="verify_public_pack.sh" "(BEGIN [A-Z ]*PRIVATE KEY|PASSWORD=|SECRET=|API[_-]?KEY=|BEARER |AUTHORIZATION:)" .; then
  echo "[verify] credential marker scan reported possible hits; review before release" >&2
  exit 1
fi

echo "[verify] public evidence pack verification passed"
