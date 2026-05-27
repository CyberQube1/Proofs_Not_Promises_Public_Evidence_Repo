#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
TASKS="${1:-${REPO_ROOT}/paper_eval_6.7b/tasks/train_failures_100.jsonl}"
RESULT_DIR="${2:-${REPO_ROOT}/paper_eval_6.7b/results/baseline_smoke}"
TIMESTAMP="${CIVITAS_67B_BASELINE_TIMESTAMP:-2026-05-21T00:00:00Z}"

mkdir -p "${RESULT_DIR}"

cd "${REPO_ROOT}/civitas_V.6.7"

cargo run --quiet --bin civitas-67b-eval -- \
  baseline \
  --tasks "${TASKS}" \
  --condition civitas_6_5b_baseline \
  --run-id baseline-smoke-civitas-6-5b \
  --timestamp "${TIMESTAMP}" \
  --output "${RESULT_DIR}/civitas_6_5b_baseline.jsonl"

cargo run --quiet --bin civitas-67b-eval -- \
  baseline \
  --tasks "${TASKS}" \
  --condition civitas_6_7b_no_improvement \
  --run-id baseline-smoke-civitas-6-7b-no-improvement \
  --timestamp "${TIMESTAMP}" \
  --output "${RESULT_DIR}/civitas_6_7b_no_improvement.jsonl"
