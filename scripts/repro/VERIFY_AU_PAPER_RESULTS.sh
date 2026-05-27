#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="${1:?usage: VERIFY_AU_PAPER_RESULTS.sh <run-dir>}"
python3 - "${RUN_DIR}" <<'PY'
from __future__ import annotations

import json
import pathlib
import re
import sys

run_dir = pathlib.Path(sys.argv[1]).resolve()
pending = re.compile(r"\bPENDING_[A-Z0-9_]+\b")


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def rows(path: pathlib.Path) -> list[dict]:
    if not path.is_file() or path.stat().st_size == 0:
        fail(f"missing or empty JSONL: {path}")
    result = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            result.append(json.loads(line))
    if not result:
        fail(f"no rows in {path}")
    return result


required = [
    "inputs/policy_corpus_registry.yaml",
    "inputs/train_failures_100.jsonl",
    "inputs/heldout_eval_100.jsonl",
    "inputs/stress_50.jsonl",
    "raw/train_65b.raw.jsonl",
    "raw/train_67b_no_improvement.raw.jsonl",
    "scored/train_65b.scored.jsonl",
    "scored/train_67b_no_improvement.scored.jsonl",
    "artifacts/failure_clusters.jsonl",
    "artifacts/candidates.jsonl",
    "artifacts/cassius_challenge_evidence.jsonl",
    "artifacts/trust_region_gate_evidence.jsonl",
    "artifacts/gate_results.jsonl",
    "sandbox/sandbox_state.json",
    "sandbox/sandbox_promotions.jsonl",
    "scored/heldout.scored.jsonl",
    "scored/stress.scored.jsonl",
    "artifacts/replay_canary_evidence.jsonl",
    "MANIFEST.md",
    "results/RESULTS_SUMMARY.md",
    "results/FINAL_RESULTS_SUMMARY.md",
    "results/tables/behavior_metrics.csv",
    "results/tables/governance_containment.csv",
    "results/tables/final_behavior_metrics.csv",
    "results/tables/final_heldout_delta.csv",
    "results/tables/final_governance_containment.csv",
    "results/tables/final_candidate_lifecycle.csv",
    "results/tables/final_stress_regression.csv",
]
for relative in required:
    path = run_dir / relative
    if not path.is_file() or path.stat().st_size == 0:
        fail(f"required paper artifact missing or empty: {relative}")

for relative in [
    "inputs/train_failures_100.jsonl",
    "inputs/heldout_eval_100.jsonl",
    "inputs/stress_50.jsonl",
]:
    text = (run_dir / relative).read_text(encoding="utf-8")
    if pending.search(text) or "placeholder://" in text or '"synthetic_placeholder": true' in text:
        fail(f"paper task snapshot contains placeholder claim material: {relative}")

result_rows = []
for relative in [
    "scored/train_65b.scored.jsonl",
    "scored/train_67b_no_improvement.scored.jsonl",
    "scored/heldout.scored.jsonl",
    "scored/stress.scored.jsonl",
]:
    result_rows.extend(rows(run_dir / relative))
for row in result_rows:
    if row.get("model_backend") == "deterministic_baseline_stub":
        fail("claim-supporting result rows include deterministic_baseline_stub")
    if row.get("run_family") == "api_portability" and row.get("api_backend_enabled") is not True:
        fail("skipped API lane appears in paper result rows")

gates = rows(run_dir / "artifacts/gate_results.jsonl")
for gate in gates:
    if gate.get("gate_status") == "approved_for_sandbox":
        if gate.get("cassius_state") != "passed" or gate.get("cassius_required") is not True:
            fail("sandbox approval lacks passed required Cassius evidence")
        if gate.get("source_split") != "train_failures" or gate.get("claim_supporting_run") is not True:
            fail("sandbox approval is not claim-supporting train evidence")
        if gate.get("trust_region_check", {}).get("state") != "evidence_passed":
            fail("sandbox approval lacks passed candidate-bound trust-region evidence")

trust_evidence = rows(run_dir / "artifacts/trust_region_gate_evidence.jsonl")
if any(row.get("decision") != "passed" or not row.get("receipt_hash") for row in trust_evidence):
    fail("paper trust-region evidence must be passed and receipt-bound before sandbox approval review")

replay_canary = rows(run_dir / "artifacts/replay_canary_evidence.jsonl")
if any(row.get("canary_status") == "not_available" for row in replay_canary):
    fail("paper replay/canary evidence lacks stress-backed canary coverage")
if any(not row.get("receipt_hash") for row in replay_canary):
    fail("paper replay/canary evidence lacks receipt hashes")

promotions = rows(run_dir / "sandbox/sandbox_promotions.jsonl")
if any(bool(row.get("production_mutation")) for row in promotions):
    fail("sandbox promotion claims production mutation")
if any(row.get("promotion_status") == "applied_to_sandbox" and row.get("sandbox_only") is not True for row in promotions):
    fail("applied promotion lost sandbox_only marker")
state = json.loads((run_dir / "sandbox/sandbox_state.json").read_text(encoding="utf-8"))
if state.get("production_mutation") is not False or state.get("sandbox_marker") != "paper_eval_sandbox_only":
    fail("sandbox state boundary is not explicit")

print(f"PASS: AU paper artifacts verified under {run_dir}")
PY
