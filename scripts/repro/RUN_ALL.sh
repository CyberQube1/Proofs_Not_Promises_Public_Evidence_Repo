#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CRATE_DIR="${REPO_ROOT}/civitas_V.6.7"
RUN_TYPE="${CIVITAS_67B_REPRO_RUN_TYPE:-smoke}"
RUN_ID="${1:-repro-smoke-$(date -u +%Y%m%dT%H%M%SZ)}"
TIMESTAMP="${CIVITAS_67B_REPRO_TIMESTAMP:-2026-05-21T00:00:00Z}"
RUN_DIR="${SCRIPT_DIR}/runs/${RUN_ID}"
OUTPUT_ROOT="${RUN_DIR}"
TRAIN_TASKS="${REPO_ROOT}/paper_eval_6.7b/tasks/train_failures_100.jsonl"
HELDOUT_TASKS="${REPO_ROOT}/paper_eval_6.7b/tasks/heldout_eval_100.jsonl"
STRESS_TASKS="${REPO_ROOT}/paper_eval_6.7b/tasks/stress_50.jsonl"
BASELINE_CONFIG="${CRATE_DIR}/Cargo.toml"
ACTIVE_LAW_HASH="${CIVITAS_67B_REPRO_ACTIVE_LAW_HASH:-repro-smoke-active-law-hash}"
POLICY_GRAPH_HASH="${CIVITAS_67B_REPRO_POLICY_GRAPH_HASH:-repro-smoke-policy-graph-hash}"
TRUST_REGION_HASH="${CIVITAS_67B_REPRO_TRUST_REGION_HASH:-repro-smoke-trust-region-hash}"
export CARGO_TARGET_DIR="${CIVITAS_67B_REPRO_CARGO_TARGET_DIR:-${RUN_DIR}/cargo-target}"

if [[ "${RUN_TYPE}" == "smoke" ]]; then
  printf 'running Civitas 6.7B reproducibility smoke bundle: %s\n' "${RUN_ID}"
else
  printf 'running Civitas 6.7B reproducibility bundle with explicit run type: %s\n' "${RUN_TYPE}"
fi

mkdir -p \
  "${RUN_DIR}/baseline" \
  "${RUN_DIR}/failure_clusters" \
  "${RUN_DIR}/candidates" \
  "${RUN_DIR}/gate_results" \
  "${RUN_DIR}/sandbox_promotions" \
  "${RUN_DIR}/heldout_results" \
  "${RUN_DIR}/stress_results" \
  "${RUN_DIR}/results"

sha3_file() {
  python3 - "$1" <<'PY'
import hashlib
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
print(hashlib.sha3_256(path.read_bytes()).hexdigest())
PY
}

jsonl_rows() {
  python3 - "$1" <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
print(sum(1 for line in path.read_text(encoding="utf-8").splitlines() if line.strip()))
PY
}

cargo_eval() {
  cargo run --quiet --manifest-path "${CRATE_DIR}/Cargo.toml" --bin civitas-67b-eval -- "$@"
}

BASELINE_65="${RUN_DIR}/baseline/civitas_6_5b_baseline.jsonl"
BASELINE_67="${RUN_DIR}/baseline/civitas_6_7b_no_improvement.jsonl"
SCORED_TRAIN="${RUN_DIR}/baseline/civitas_6_7b_no_improvement.scored_smoke.jsonl"
CLUSTERS="${RUN_DIR}/failure_clusters/train_smoke.clusters.jsonl"
CLUSTER_SUMMARY="${RUN_DIR}/failure_clusters/train_smoke.summary.md"
CANDIDATES="${RUN_DIR}/candidates/train_smoke.candidates.jsonl"
GATE_RESULTS="${RUN_DIR}/gate_results/train_smoke.gate_results.jsonl"
SANDBOX_DIR="${RUN_DIR}/sandbox_promotions"
SANDBOX_PROMOTIONS="${SANDBOX_DIR}/sandbox_promotions.jsonl"
SANDBOX_STATE="${SANDBOX_DIR}/sandbox_state.json"
HELDOUT_RESULTS="${RUN_DIR}/heldout_results/heldout_smoke.jsonl"
STRESS_RESULTS="${RUN_DIR}/stress_results/stress_smoke.jsonl"
RESULTS_DIR="${RUN_DIR}/results"
CONFIG_HASH_BEFORE="$(sha3_file "${BASELINE_CONFIG}")"

cargo_eval baseline \
  --tasks "${TRAIN_TASKS}" \
  --condition civitas_6_5b_baseline \
  --run-id "${RUN_ID}-civitas-6-5b" \
  --timestamp "${TIMESTAMP}" \
  --output "${BASELINE_65}"

cargo_eval baseline \
  --tasks "${TRAIN_TASKS}" \
  --condition civitas_6_7b_no_improvement \
  --run-id "${RUN_ID}-civitas-6-7b-no-improvement" \
  --timestamp "${TIMESTAMP}" \
  --output "${BASELINE_67}"

# Baseline smoke rows are intentionally clean. Failure discovery needs scored
# failure evidence, so write a synthetic scored copy inside this smoke run only.
python3 - "${BASELINE_67}" "${SCORED_TRAIN}" <<'PY'
import json
import pathlib
import sys

source = pathlib.Path(sys.argv[1])
target = pathlib.Path(sys.argv[2])
changed = 0
with source.open(encoding="utf-8") as reader, target.open("w", encoding="utf-8") as writer:
    for line in reader:
        if not line.strip():
            continue
        row = json.loads(line)
        if row.get("task_bucket") == "unsupported_compliance_claim":
            row["unsupported_claim"] = True
            row["evidence_supported"] = False
            row["notes"] = (
                row.get("notes", "")
                + "; synthetic repro smoke scoring fixture exposes one train failure"
            )
            changed += 1
        writer.write(json.dumps(row, separators=(",", ":")) + "\n")
if changed == 0:
    raise SystemExit("synthetic smoke scoring fixture did not find a train failure row")
PY

cargo_eval failure_discovery \
  --results "${SCORED_TRAIN}" \
  --tasks "${TRAIN_TASKS}" \
  --clusters "${CLUSTERS}" \
  --summary "${CLUSTER_SUMMARY}"

cargo_eval candidate_generation \
  --clusters "${CLUSTERS}" \
  --current-config-hash "${CONFIG_HASH_BEFORE}" \
  --active-law-hash "${ACTIVE_LAW_HASH}" \
  --policy-graph-hash "${POLICY_GRAPH_HASH}" \
  --trust-region-hash "${TRUST_REGION_HASH}" \
  --generation-run-id "${RUN_ID}-candidate-generation" \
  --generation-condition civitas_6_7b_no_improvement \
  --timestamp "${TIMESTAMP}" \
  --output "${CANDIDATES}"

cargo_eval governance_gate \
  --candidates "${CANDIDATES}" \
  --active-law-hash "${ACTIVE_LAW_HASH}" \
  --policy-graph-hash "${POLICY_GRAPH_HASH}" \
  --trust-region-hash "${TRUST_REGION_HASH}" \
  --cassius-not-required \
  --timestamp "${TIMESTAMP}" \
  --output "${GATE_RESULTS}"

cargo_eval sandbox_promote \
  --candidates "${CANDIDATES}" \
  --gate-results "${GATE_RESULTS}" \
  --baseline-config "${BASELINE_CONFIG}" \
  --sandbox-output-dir "${SANDBOX_DIR}" \
  --timestamp "${TIMESTAMP}"

cargo_eval heldout_eval \
  --tasks "${HELDOUT_TASKS}" \
  --sandbox-state "${SANDBOX_STATE}" \
  --run-id "${RUN_ID}-heldout" \
  --output "${HELDOUT_RESULTS}"

cargo_eval stress_eval \
  --tasks "${STRESS_TASKS}" \
  --sandbox-state "${SANDBOX_STATE}" \
  --run-id "${RUN_ID}-stress" \
  --output "${STRESS_RESULTS}"

python3 "${REPO_ROOT}/paper_eval_6.7b/scripts/aggregate_results.py" \
  --baseline-results "${BASELINE_65}" \
  --baseline-results "${BASELINE_67}" \
  --failure-clusters "${CLUSTERS}" \
  --candidates "${CANDIDATES}" \
  --gate-results "${GATE_RESULTS}" \
  --sandbox-promotions "${SANDBOX_PROMOTIONS}" \
  --heldout-results "${HELDOUT_RESULTS}" \
  --stress-results "${STRESS_RESULTS}" \
  --run-type "${RUN_TYPE}" \
  --out-dir "${RESULTS_DIR}"

read -r PRODUCTION_MUTATION_COUNT UNAUTHORIZED_PROMOTION_COUNT SANDBOX_ONLY_COUNT <<EOF
$(python3 - "${RESULTS_DIR}/tables/governance_containment.csv" <<'PY'
import csv
import sys

with open(sys.argv[1], encoding="utf-8", newline="") as handle:
    row = next(csv.DictReader(handle))
print(
    row["production_mutation_count"],
    row["unauthorized_promotion_count"],
    row["sandbox_only_promotion_count"],
)
PY
)
EOF

GIT_COMMIT="$(git -C "${REPO_ROOT}" rev-parse HEAD)"
GIT_BRANCH="$(git -C "${REPO_ROOT}" branch --show-current)"
if [[ -z "${GIT_BRANCH}" ]]; then
  GIT_BRANCH="detached-head"
fi
if [[ -z "$(git -C "${REPO_ROOT}" status --porcelain)" ]]; then
  WORKTREE_STATUS="clean"
else
  WORKTREE_STATUS="dirty"
fi
CIVITAS_VERSION="$(
  python3 - "${CRATE_DIR}/Cargo.toml" <<'PY'
import pathlib
import sys

for line in pathlib.Path(sys.argv[1]).read_text(encoding="utf-8").splitlines():
    if line.startswith("version = "):
        print(line.split('"')[1])
        break
PY
)"
SANDBOX_STATE_HASH="$(sha3_file "${SANDBOX_STATE}")"
MANIFEST="${RUN_DIR}/MANIFEST.md"

cat > "${MANIFEST}" <<EOF
# Civitas 6.7B Reproducibility Run Manifest

## Run Identity

| Field | Value |
| --- | --- |
| Run id | \`${RUN_ID}\` |
| Timestamp | \`${TIMESTAMP}\` |
| Run type | \`${RUN_TYPE}\` |
| Operator/environment notes | Local research-only sandbox bundle; smoke default uses deterministic adapters and no secrets |

## Repo Identity

| Field | Value |
| --- | --- |
| Git commit hash | \`${GIT_COMMIT}\` |
| Git branch | \`${GIT_BRANCH}\` |
| Working tree status | \`${WORKTREE_STATUS}\` |
| Civitas version | \`${CIVITAS_VERSION}\` |
| Eval harness version | \`civitas-67b-paper-eval-repro-v1\` |

## Input Hashes

| Input | SHA3-256 or bound value |
| --- | --- |
| Train task file hash | \`$(sha3_file "${TRAIN_TASKS}")\` |
| Held-out task file hash | \`$(sha3_file "${HELDOUT_TASKS}")\` |
| Stress task file hash | \`$(sha3_file "${STRESS_TASKS}")\` |
| Baseline config hash | \`${CONFIG_HASH_BEFORE}\` |
| Active law hash | \`${ACTIVE_LAW_HASH}\` |
| Policy graph hash | \`${POLICY_GRAPH_HASH}\` |
| Trust-region hash | \`${TRUST_REGION_HASH}\` |
| Sandbox state file hash | \`${SANDBOX_STATE_HASH}\` |

## Model Identity

| Field | Value |
| --- | --- |
| Model backend | \`deterministic_baseline_stub\` |
| Model provider | \`deterministic_stub\` |
| Backend kind | \`stub\` |
| Run family | \`smoke_stub\` |
| Model ids | \`civitas-6.5b-frozen-baseline-stub\`, \`civitas-6.7b-no-improvement-stub\`, \`civitas-6.7b-governed-improvement-sandbox-stub\` |
| Model version / settings | \`not_loaded\`; result rows freeze temperature, max tokens, seed marker, and deterministic mode |
| API backend status | API portability lane not configured; API skip metadata belongs in any optional API run and no API key is stored here |
| Local/API mode | Local deterministic research stub |
| Backend notes | No live model backend, Cassius live invocation, production Aegis API, or Senate API was invoked |

## Command Sequence

The command entrypoint was:

\`\`\`bash
bash paper_eval_6.7b/repro/RUN_ALL.sh ${RUN_ID}
\`\`\`

The entrypoint ran:

1. \`baseline\` over \`${TRAIN_TASKS}\` for \`civitas_6_5b_baseline\`
2. \`baseline\` over \`${TRAIN_TASKS}\` for \`civitas_6_7b_no_improvement\`
3. Synthetic smoke scoring copy \`${SCORED_TRAIN}\` inside this run directory
4. \`failure_discovery --results ${SCORED_TRAIN} --tasks ${TRAIN_TASKS}\`
5. \`candidate_generation --clusters ${CLUSTERS}\`
6. \`governance_gate --candidates ${CANDIDATES} --cassius-not-required\`
7. \`sandbox_promote --sandbox-output-dir ${SANDBOX_DIR}\`
8. \`heldout_eval --tasks ${HELDOUT_TASKS} --sandbox-state ${SANDBOX_STATE}\`
9. \`stress_eval --tasks ${STRESS_TASKS} --sandbox-state ${SANDBOX_STATE}\`
10. \`aggregate_results.py --out-dir ${RESULTS_DIR}\`

## Output Artifacts

| Artifact | Path | Rows | SHA3-256 |
| --- | --- | ---: | --- |
| Civitas 6.5B baseline results | \`${BASELINE_65}\` | $(jsonl_rows "${BASELINE_65}") | \`$(sha3_file "${BASELINE_65}")\` |
| Civitas 6.7B no-improvement results | \`${BASELINE_67}\` | $(jsonl_rows "${BASELINE_67}") | \`$(sha3_file "${BASELINE_67}")\` |
| Smoke scored train copy | \`${SCORED_TRAIN}\` | $(jsonl_rows "${SCORED_TRAIN}") | \`$(sha3_file "${SCORED_TRAIN}")\` |
| Failure clusters | \`${CLUSTERS}\` | $(jsonl_rows "${CLUSTERS}") | \`$(sha3_file "${CLUSTERS}")\` |
| Candidate records | \`${CANDIDATES}\` | $(jsonl_rows "${CANDIDATES}") | \`$(sha3_file "${CANDIDATES}")\` |
| Gate results | \`${GATE_RESULTS}\` | $(jsonl_rows "${GATE_RESULTS}") | \`$(sha3_file "${GATE_RESULTS}")\` |
| Sandbox promotions | \`${SANDBOX_PROMOTIONS}\` | $(jsonl_rows "${SANDBOX_PROMOTIONS}") | \`$(sha3_file "${SANDBOX_PROMOTIONS}")\` |
| Held-out results | \`${HELDOUT_RESULTS}\` | $(jsonl_rows "${HELDOUT_RESULTS}") | \`$(sha3_file "${HELDOUT_RESULTS}")\` |
| Stress results | \`${STRESS_RESULTS}\` | $(jsonl_rows "${STRESS_RESULTS}") | \`$(sha3_file "${STRESS_RESULTS}")\` |
| Results summary | \`${RESULTS_DIR}/RESULTS_SUMMARY.md\` | n/a | \`$(sha3_file "${RESULTS_DIR}/RESULTS_SUMMARY.md")\` |

Result tables:

- \`${RESULTS_DIR}/tables/behavior_metrics.csv\`
- \`${RESULTS_DIR}/tables/candidate_lifecycle.csv\`
- \`${RESULTS_DIR}/tables/rejection_reasons.csv\`
- \`${RESULTS_DIR}/tables/governance_containment.csv\`
- \`${RESULTS_DIR}/tables/heldout_delta.csv\`

## Safety Assertions

| Assertion | Value |
| --- | --- |
| Production mutation count | \`${PRODUCTION_MUTATION_COUNT}\` |
| Unauthorized promotion count | \`${UNAUTHORIZED_PROMOTION_COUNT}\` |
| Sandbox-only promotion count | \`${SANDBOX_ONLY_COUNT}\` |
| Held-out/stress candidate isolation | Held-out and stress task files are used only by post-promotion eval commands |
| Replay accounting | Missing replay evidence remains \`not_available\`; it is not treated as passed replay |

## Claim Boundary

This run packages the existing Civitas 6.7B research harness only. It does not
add new paper claims. Smoke placeholder task rows and deterministic stub model
rows are harness/auditability evidence, not final paper evidence. Sandbox gate
approval and sandbox overlay application are not production approval.

## Limitations

- Run status is \`${RUN_TYPE}\`.
- Deterministic stub behavior is active for baseline and Prompt 7 rows.
- One train failure is exposed through a synthetic scored smoke copy inside the
  run directory so failure discovery and candidate lifecycle paths are
  reproducible without mutating source artifacts.
- Replay reproducibility is unavailable in this smoke bundle.
- Live Aegis/Senate checks were not invoked by this research smoke adapter.
- Cassius is explicitly \`not_required\` and gate rows are
  non-claim-supporting in this smoke bundle; claim-supporting gate rows need
  receipt-bound Cassius evidence.
- Smoke outputs are not paper evidence.
EOF

printf 'run directory: %s\n' "${RUN_DIR}"
printf 'run manifest: %s\n' "${MANIFEST}"
printf 'results summary: %s\n' "${RESULTS_DIR}/RESULTS_SUMMARY.md"
printf 'result tables: %s\n' "${RESULTS_DIR}/tables"
printf 'verify with: bash %s %s\n' "${SCRIPT_DIR}/VERIFY_RESULTS.sh" "${RUN_DIR}"
