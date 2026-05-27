#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AU_ENV="${AU_PAPER_ENV_FILE:-${REPO_ROOT}/paper_eval_6.7b/repro/AU_PAPER_ENV.sh}"
if [[ -f "${AU_ENV}" ]]; then
  # shellcheck source=/dev/null
  source "${AU_ENV}"
fi
CRATE="${REPO_ROOT}/civitas_V.6.7"
RUN_ID="${1:-au-paper-$(date -u +%Y%m%dT%H%M%SZ)}"
RUN_DIR="${REPO_ROOT}/paper_eval_6.7b/repro/runs/${RUN_ID}"
MODEL_ID="${MODEL_ID:-gemma4:e2b-it-q8_0}"
MODEL_VERSION="${MODEL_VERSION:-local-tag-required}"
ACTIVE_LAW_HASH="${ACTIVE_LAW_HASH:?set ACTIVE_LAW_HASH from au_finance_paper_scope}"
POLICY_GRAPH_HASH="${POLICY_GRAPH_HASH:?set POLICY_GRAPH_HASH from au_finance_paper_scope}"
TRUST_REGION_HASH="${TRUST_REGION_HASH:?set TRUST_REGION_HASH from au_finance_paper_scope}"
TASK_ROOT="${REPO_ROOT}/paper_eval_6.7b/tasks/au_finance_v1"
REGISTRY="${REPO_ROOT}/paper_eval_6.7b/policy_corpora/policy_corpus_registry.yaml"
AGGREGATOR="${REPO_ROOT}/paper_eval_6.7b/scripts/aggregate_results.py"
SCORER="${REPO_ROOT}/paper_eval_6.7b/scripts/score_results.py"
REPLAY_CANARY_EXPORTER="${REPO_ROOT}/paper_eval_6.7b/scripts/export_replay_canary_evidence.py"
SETUP_CHECKER="${REPO_ROOT}/paper_eval_6.7b/repro/CHECK_AU_PAPER_SETUP.sh"
NOW="${RUN_TIMESTAMP:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"

# The checked-out Cargo config can carry a host-local target-dir. Paper runs
# keep their Cargo build directory inside the selected run unless overridden.
export CARGO_TARGET_DIR="${CIVITAS_67B_AU_PAPER_CARGO_TARGET_DIR:-${RUN_DIR}/cargo-target}"

case "${MODEL_VERSION}" in
  ""|record-ollama-tag-before-run|local-tag-required|not_loaded|unavailable)
    printf 'MODEL_VERSION must be the actual Ollama model digest/tag before a paper run.\n' >&2
    exit 2
    ;;
esac

mkdir -p "${RUN_DIR}/inputs" "${RUN_DIR}/raw" "${RUN_DIR}/scored" \
  "${RUN_DIR}/artifacts" "${RUN_DIR}/results" "${RUN_DIR}/sandbox"
bash "${SETUP_CHECKER}" \
  --require-run-env \
  --require-ollama \
  --report-dir "${RUN_DIR}/results"
cp "${REGISTRY}" "${RUN_DIR}/inputs/policy_corpus_registry.yaml"
cp "${TASK_ROOT}/train_failures_100.jsonl" "${RUN_DIR}/inputs/train_failures_100.jsonl"
cp "${TASK_ROOT}/heldout_eval_100.jsonl" "${RUN_DIR}/inputs/heldout_eval_100.jsonl"
cp "${TASK_ROOT}/stress_50.jsonl" "${RUN_DIR}/inputs/stress_50.jsonl"

model_flags=(
  --execution-mode real_local
  --ollama-host "${OLLAMA_HOST:-http://localhost:11434}"
  --timeout-seconds "${OLLAMA_TIMEOUT_SECONDS:-120}"
  --model-provider ollama
  --backend-kind local
  --model-id "${MODEL_ID}"
  --model-version "${MODEL_VERSION}"
  --run-family local_reproducible
  --temperature "${TEMPERATURE:-0}"
  --max-tokens "${MAX_TOKENS:-512}"
  --seed "${SEED_NOTE:-ollama-seed-unavailable}"
  --deterministic-mode "${DETERMINISTIC_MODE:-false}"
)

cd "${CRATE}"
cargo run --bin civitas-67b-eval -- baseline \
  "${model_flags[@]}" \
  --tasks "${RUN_DIR}/inputs/train_failures_100.jsonl" \
  --condition civitas_6_5b_baseline \
  --run-id "${RUN_ID}-train-65b" \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/raw/train_65b.raw.jsonl"
cargo run --bin civitas-67b-eval -- baseline \
  "${model_flags[@]}" \
  --tasks "${RUN_DIR}/inputs/train_failures_100.jsonl" \
  --condition civitas_6_7b_no_improvement \
  --run-id "${RUN_ID}-train-67b-no-improvement" \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/raw/train_67b_no_improvement.raw.jsonl"

cd "${REPO_ROOT}"
python3 "${SCORER}" \
  --raw-results "${RUN_DIR}/raw/train_65b.raw.jsonl" \
  --tasks "${RUN_DIR}/inputs/train_failures_100.jsonl" \
  --scored-results "${RUN_DIR}/scored/train_65b.scored.jsonl" \
  --audit "${RUN_DIR}/artifacts/train_65b.scoring_audit.jsonl" \
  --summary "${RUN_DIR}/results/TRAIN_65B_SCORING_SUMMARY.md" \
  --timestamp "${NOW}"
python3 "${SCORER}" \
  --raw-results "${RUN_DIR}/raw/train_67b_no_improvement.raw.jsonl" \
  --tasks "${RUN_DIR}/inputs/train_failures_100.jsonl" \
  --scored-results "${RUN_DIR}/scored/train_67b_no_improvement.scored.jsonl" \
  --audit "${RUN_DIR}/artifacts/train_67b_no_improvement.scoring_audit.jsonl" \
  --summary "${RUN_DIR}/results/TRAIN_67B_SCORING_SUMMARY.md" \
  --timestamp "${NOW}"

cd "${CRATE}"
cargo run --bin civitas-67b-eval -- failure_discovery \
  --results "${RUN_DIR}/scored/train_67b_no_improvement.scored.jsonl" \
  --tasks "${RUN_DIR}/inputs/train_failures_100.jsonl" \
  --clusters "${RUN_DIR}/artifacts/failure_clusters.jsonl" \
  --summary "${RUN_DIR}/results/FAILURE_SUMMARY.md"
cargo run --bin civitas-67b-eval -- candidate_generation \
  --clusters "${RUN_DIR}/artifacts/failure_clusters.jsonl" \
  --current-config-hash "${CONFIG_HASH_BEFORE:-au-paper-real-local-config-bound-in-results}" \
  --active-law-hash "${ACTIVE_LAW_HASH}" \
  --policy-graph-hash "${POLICY_GRAPH_HASH}" \
  --trust-region-hash "${TRUST_REGION_HASH}" \
  --generation-run-id "${RUN_ID}-candidate-generation" \
  --generation-condition civitas_6_7b_no_improvement \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/artifacts/candidates.jsonl"
cargo run --bin civitas-67b-eval -- cassius_evidence \
  --candidates "${RUN_DIR}/artifacts/candidates.jsonl" \
  --artifact-ref "run:${RUN_ID}" \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/artifacts/cassius_challenge_evidence.jsonl"
cargo run --bin civitas-67b-eval -- trust_region_evidence \
  --candidates "${RUN_DIR}/artifacts/candidates.jsonl" \
  --trust-region-hash "${TRUST_REGION_HASH}" \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/artifacts/trust_region_gate_evidence.jsonl"
cargo run --bin civitas-67b-eval -- governance_gate \
  --candidates "${RUN_DIR}/artifacts/candidates.jsonl" \
  --active-law-hash "${ACTIVE_LAW_HASH}" \
  --policy-graph-hash "${POLICY_GRAPH_HASH}" \
  --trust-region-hash "${TRUST_REGION_HASH}" \
  --trust-region-evidence "${RUN_DIR}/artifacts/trust_region_gate_evidence.jsonl" \
  --cassius-challenge-evidence "${RUN_DIR}/artifacts/cassius_challenge_evidence.jsonl" \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/artifacts/gate_results.jsonl"
cargo run --bin civitas-67b-eval -- sandbox_promote \
  --candidates "${RUN_DIR}/artifacts/candidates.jsonl" \
  --gate-results "${RUN_DIR}/artifacts/gate_results.jsonl" \
  --baseline-config "${RUN_DIR}/inputs/policy_corpus_registry.yaml" \
  --sandbox-output-dir "${RUN_DIR}/sandbox" \
  --timestamp "${NOW}"
cargo run --bin civitas-67b-eval -- heldout_eval \
  "${model_flags[@]}" \
  --tasks "${RUN_DIR}/inputs/heldout_eval_100.jsonl" \
  --sandbox-state "${RUN_DIR}/sandbox/sandbox_state.json" \
  --run-id "${RUN_ID}-heldout" \
  --output "${RUN_DIR}/raw/heldout.raw.jsonl"
cargo run --bin civitas-67b-eval -- stress_eval \
  "${model_flags[@]}" \
  --tasks "${RUN_DIR}/inputs/stress_50.jsonl" \
  --sandbox-state "${RUN_DIR}/sandbox/sandbox_state.json" \
  --run-id "${RUN_ID}-stress" \
  --output "${RUN_DIR}/raw/stress.raw.jsonl"

cd "${REPO_ROOT}"
python3 "${SCORER}" \
  --raw-results "${RUN_DIR}/raw/heldout.raw.jsonl" \
  --tasks "${RUN_DIR}/inputs/heldout_eval_100.jsonl" \
  --scored-results "${RUN_DIR}/scored/heldout.scored.jsonl" \
  --audit "${RUN_DIR}/artifacts/heldout.scoring_audit.jsonl" \
  --summary "${RUN_DIR}/results/HELDOUT_SCORING_SUMMARY.md" \
  --timestamp "${NOW}"
python3 "${SCORER}" \
  --raw-results "${RUN_DIR}/raw/stress.raw.jsonl" \
  --tasks "${RUN_DIR}/inputs/stress_50.jsonl" \
  --scored-results "${RUN_DIR}/scored/stress.scored.jsonl" \
  --audit "${RUN_DIR}/artifacts/stress.scoring_audit.jsonl" \
  --summary "${RUN_DIR}/results/STRESS_SCORING_SUMMARY.md" \
  --timestamp "${NOW}"
python3 "${REPLAY_CANARY_EXPORTER}" \
  --sandbox-state "${RUN_DIR}/sandbox/sandbox_state.json" \
  --heldout-results "${RUN_DIR}/scored/heldout.scored.jsonl" \
  --stress-results "${RUN_DIR}/scored/stress.scored.jsonl" \
  --run-id "${RUN_ID}" \
  --timestamp "${NOW}" \
  --output "${RUN_DIR}/artifacts/replay_canary_evidence.jsonl"
python3 "${AGGREGATOR}" \
  --baseline-results "${RUN_DIR}/scored/train_65b.scored.jsonl" \
  --baseline-results "${RUN_DIR}/scored/train_67b_no_improvement.scored.jsonl" \
  --failure-clusters "${RUN_DIR}/artifacts/failure_clusters.jsonl" \
  --candidates "${RUN_DIR}/artifacts/candidates.jsonl" \
  --gate-results "${RUN_DIR}/artifacts/gate_results.jsonl" \
  --trust-region-evidence "${RUN_DIR}/artifacts/trust_region_gate_evidence.jsonl" \
  --replay-canary-evidence "${RUN_DIR}/artifacts/replay_canary_evidence.jsonl" \
  --sandbox-promotions "${RUN_DIR}/sandbox/sandbox_promotions.jsonl" \
  --heldout-results "${RUN_DIR}/scored/heldout.scored.jsonl" \
  --stress-results "${RUN_DIR}/scored/stress.scored.jsonl" \
  --run-type full \
  --out-dir "${RUN_DIR}/results"

python3 - "${RUN_DIR}" "${RUN_ID}" "${NOW}" "${MODEL_ID}" "${MODEL_VERSION}" \
  "${ACTIVE_LAW_HASH}" "${POLICY_GRAPH_HASH}" "${TRUST_REGION_HASH}" <<'PY'
from __future__ import annotations

import hashlib
import pathlib
import subprocess
import sys

run_dir = pathlib.Path(sys.argv[1])
run_id, timestamp, model_id, model_version = sys.argv[2:6]
active_law_hash, policy_graph_hash, trust_region_hash = sys.argv[6:9]
repo_root = pathlib.Path(__file__).resolve().parents[0] if "__file__" in globals() else pathlib.Path.cwd()


def sha256(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git(*args: str) -> str:
    return subprocess.run(["git", *args], capture_output=True, text=True, check=False).stdout.strip() or "unavailable"


inputs = run_dir / "inputs"
lines = [
    "# Civitas 6.7B AU Paper Run Manifest",
    "",
    f"- Run id `{run_id}`",
    f"- Timestamp `{timestamp}`",
    "- Run type `full`",
    f"- Git commit hash `{git('rev-parse', 'HEAD')}`",
    f"- Git branch `{git('branch', '--show-current')}`",
    f"- Working tree status `{'dirty' if git('status', '--short') != 'unavailable' and git('status', '--short') else 'clean'}`",
    "",
    "## Model Identity",
    "",
    "- Model provider `ollama`",
    "- Backend kind `local`",
    "- Run family `local_reproducible`",
    f"- Model ID `{model_id}`",
    f"- Model version `{model_version}`",
    "- API backend status `excluded`",
    "- temperature `0` unless overridden in the result rows",
    "- seed/determinism settings are preserved in every result row",
    "",
    "## AU Authority",
    "",
    f"- Active-law hash `{active_law_hash}`",
    f"- Policy graph hash `{policy_graph_hash}`",
    f"- Trust-region hash `{trust_region_hash}`",
    f"- Registry snapshot hash `{sha256(inputs / 'policy_corpus_registry.yaml')}`",
    f"- Train task file hash `{sha256(inputs / 'train_failures_100.jsonl')}`",
    f"- Held-out task file hash `{sha256(inputs / 'heldout_eval_100.jsonl')}`",
    f"- Stress task file hash `{sha256(inputs / 'stress_50.jsonl')}`",
    "",
    "## Output Artifacts",
    "",
    "- Raw and scored rows under `raw/` and `scored/`",
    "- Failure clusters, candidates, Cassius evidence, trust-region evidence, replay/canary evidence, and gate rows under `artifacts/`",
    "- Sandbox overlays and promotions under `sandbox/`",
    "- Tables, summaries, verifier output, and readiness reports under `results/`",
    "",
    "## Claim Boundary",
    "",
    "- AU finance baseline only; APRA/ASIC remain baseline-contained source subsets.",
    "- Production mutation count must remain `0`.",
    "- Unauthorized promotion count must remain `0`.",
    "- Sandbox approvals and overlays are not production promotion.",
    "- API portability and EU coverage are excluded.",
]
(run_dir / "MANIFEST.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
PY

bash "${REPO_ROOT}/paper_eval_6.7b/repro/VERIFY_AU_PAPER_RESULTS.sh" "${RUN_DIR}"
bash "${REPO_ROOT}/paper_eval_6.7b/repro/CHECK_PAPER_READINESS.sh" \
  --mode paper \
  --registry "${RUN_DIR}/inputs/policy_corpus_registry.yaml" \
  --tasks "${RUN_DIR}/inputs/train_failures_100.jsonl" \
  --tasks "${RUN_DIR}/inputs/heldout_eval_100.jsonl" \
  --tasks "${RUN_DIR}/inputs/stress_50.jsonl" \
  --cassius-evidence "${RUN_DIR}/artifacts/cassius_challenge_evidence.jsonl" \
  --run-dir "${RUN_DIR}" \
  --out-dir "${RUN_DIR}/results"

printf 'AU paper run complete: %s\n' "${RUN_DIR}"
printf 'Results summary: %s\n' "${RUN_DIR}/results/RESULTS_SUMMARY.md"
printf 'Readiness report: %s\n' "${RUN_DIR}/results/readiness_report.md"
