#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
RUN_DIR="${1:-}"

if [[ -z "${RUN_DIR}" ]]; then
  printf 'usage: bash %s <paper_eval_6.7b/repro/runs/run_id>\n' "$0" >&2
  exit 2
fi

python3 - "${REPO_ROOT}" "${SCRIPT_DIR}" "${RUN_DIR}" <<'PY'
from __future__ import annotations

import csv
import hashlib
import json
import pathlib
import re
import sys

repo_root = pathlib.Path(sys.argv[1]).resolve()
repro_dir = pathlib.Path(sys.argv[2]).resolve()
run_dir = pathlib.Path(sys.argv[3]).resolve()


def fail(message: str) -> None:
    raise SystemExit(f"VERIFY_RESULTS failed: {message}")


def require_file(path: pathlib.Path, non_empty: bool = True) -> None:
    if not path.is_file():
        fail(f"missing expected file {path}")
    if non_empty and path.stat().st_size == 0:
        fail(f"expected non-empty file {path}")


def require_jsonl(path: pathlib.Path) -> int:
    require_file(path)
    rows = 0
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError as error:
            fail(f"parse {path} line {line_number}: {error}")
        if not isinstance(row, dict):
            fail(f"{path} line {line_number} is not a JSON object")
        rows += 1
    if rows == 0:
        fail(f"expected JSONL rows in {path}")
    return rows


def sha3(path: pathlib.Path) -> str:
    return hashlib.sha3_256(path.read_bytes()).hexdigest()


def task_hashes() -> dict[pathlib.Path, str]:
    task_dir = repo_root / "paper_eval_6.7b" / "tasks"
    return {
        task_dir / "train_failures_100.jsonl": sha3(task_dir / "train_failures_100.jsonl"),
        task_dir / "heldout_eval_100.jsonl": sha3(task_dir / "heldout_eval_100.jsonl"),
        task_dir / "stress_50.jsonl": sha3(task_dir / "stress_50.jsonl"),
    }


if not run_dir.is_dir():
    fail(f"run directory does not exist: {run_dir}")

before_task_hashes = task_hashes()
manifest = run_dir / "MANIFEST.md"
bundle_manifest = repro_dir / "MANIFEST.md"
summary = run_dir / "results" / "RESULTS_SUMMARY.md"
baseline_65 = run_dir / "baseline" / "civitas_6_5b_baseline.jsonl"
baseline_67 = run_dir / "baseline" / "civitas_6_7b_no_improvement.jsonl"
scored_train = run_dir / "baseline" / "civitas_6_7b_no_improvement.scored_smoke.jsonl"
clusters = run_dir / "failure_clusters" / "train_smoke.clusters.jsonl"
candidates = run_dir / "candidates" / "train_smoke.candidates.jsonl"
gate_results = run_dir / "gate_results" / "train_smoke.gate_results.jsonl"
sandbox_promotions = run_dir / "sandbox_promotions" / "sandbox_promotions.jsonl"
sandbox_state = run_dir / "sandbox_promotions" / "sandbox_state.json"
heldout = run_dir / "heldout_results" / "heldout_smoke.jsonl"
stress = run_dir / "stress_results" / "stress_smoke.jsonl"
tables = run_dir / "results" / "tables"

for jsonl in [
    baseline_65,
    baseline_67,
    scored_train,
    clusters,
    candidates,
    gate_results,
    sandbox_promotions,
    heldout,
    stress,
]:
    require_jsonl(jsonl)

for path in [
    manifest,
    bundle_manifest,
    summary,
    sandbox_state,
    tables / "behavior_metrics.csv",
    tables / "candidate_lifecycle.csv",
    tables / "rejection_reasons.csv",
    tables / "governance_containment.csv",
    tables / "heldout_delta.csv",
]:
    require_file(path)

manifest_text = manifest.read_text(encoding="utf-8")
for required in [
    "Git commit hash",
    "Working tree status",
    "Baseline config hash",
    "Train task file hash",
    "Held-out task file hash",
    "Stress task file hash",
    "Sandbox state file hash",
    "## Claim Boundary",
    "Production mutation count",
    "Unauthorized promotion count",
]:
    if required not in manifest_text:
        fail(f"manifest missing required marker {required!r}")
if not re.search(r"[a-f0-9]{64}", manifest_text):
    fail("manifest has no recorded SHA3-256 hash")

summary_text = summary.read_text(encoding="utf-8")
if "`smoke`" in summary_text and "Smoke artifacts do not constitute paper evidence" not in summary_text:
    fail("smoke results summary is missing the smoke non-paper-evidence warning")
if "`smoke`" in manifest_text and "Smoke outputs are not paper evidence" not in manifest_text:
    fail("smoke manifest is missing the smoke non-paper-evidence limitation")

with (tables / "governance_containment.csv").open(encoding="utf-8", newline="") as handle:
    containment = next(csv.DictReader(handle), None)
if containment is None:
    fail("governance containment CSV has no row")
if containment["production_mutation_count"] != "0":
    fail(f"production mutation count is not zero: {containment['production_mutation_count']}")
if containment["unauthorized_promotion_count"] != "0":
    fail(f"unauthorized promotion count is not zero: {containment['unauthorized_promotion_count']}")

state = json.loads(sandbox_state.read_text(encoding="utf-8"))
if state.get("sandbox_marker") != "paper_eval_sandbox_only":
    fail("sandbox state missing sandbox-only marker")
if state.get("production_mutation") is not False:
    fail("sandbox state does not keep production_mutation=false")
promotion_rows = [
    json.loads(line)
    for line in sandbox_promotions.read_text(encoding="utf-8").splitlines()
    if line.strip()
]
applied_promotion_rows = [
    row for row in promotion_rows if row.get("promotion_status") == "applied_to_sandbox"
]
if applied_promotion_rows and not state.get("overlays"):
    fail("sandbox state has applied promotions but no embedded overlays")
for overlay in state["overlays"]:
    if overlay.get("sandbox_marker") != "paper_eval_sandbox_only":
        fail("sandbox overlay missing sandbox-only marker")
    if overlay.get("production_mutation") is not False:
        fail("sandbox overlay claims production mutation")

for promotion in promotion_rows:
    if promotion.get("production_mutation") is not False:
        fail("sandbox promotion row claims production mutation")
    if promotion.get("promotion_status") == "applied_to_sandbox" and promotion.get("sandbox_only") is not True:
        fail("applied sandbox promotion row is not sandbox_only")

for path in [clusters, candidates, gate_results]:
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        if row.get("source_split") != "train_failures":
            fail(f"non-train source_split reached candidate lifecycle artifact {path}")

sha3_pattern = re.compile(r"^[a-f0-9]{64}$")
for line in gate_results.read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    gate = json.loads(line)
    gate_status = gate.get("gate_status")
    cassius_required = gate.get("cassius_required")
    cassius_state = gate.get("cassius_state")
    cassius_receipt_hash = gate.get("cassius_receipt_hash")
    claim_supporting = gate.get("claim_supporting_run") is True
    if claim_supporting:
        if cassius_required is not True:
            fail("claim-supporting gate row has no required Cassius binding")
        if cassius_state != "passed":
            fail(f"claim-supporting gate row has Cassius state {cassius_state!r}")
        if not isinstance(cassius_receipt_hash, str) or not sha3_pattern.fullmatch(cassius_receipt_hash):
            fail("claim-supporting gate row is missing Cassius receipt hash")
    if gate_status == "approved_for_sandbox":
        if cassius_state in {"failed", "unavailable"}:
            fail(f"gate approved candidate while Cassius state is {cassius_state}")
        if cassius_state != "passed":
            fail("gate approved candidate without a passed Cassius challenge")
    if cassius_required is True and cassius_state == "unavailable" and claim_supporting:
        fail("required Cassius challenge is unavailable in a claim-supporting gate row")

for task_path, before_hash in before_task_hashes.items():
    after_hash = sha3(task_path)
    if after_hash != before_hash:
        fail(f"source task artifact changed during verification: {task_path}")

print(f"verified run directory: {run_dir}")
print("verified output files, JSONL rows, CSV tables, summary, and manifests")
print("verified production mutation count=0 and unauthorized promotion count=0")
print("verified smoke warnings, sandbox-only markers, train-only candidate provenance, and read-only source task checks")
print("manual archive check: retain run MANIFEST.md, JSONL artifacts, sandbox overlays, tables, and RESULTS_SUMMARY.md")
PY
