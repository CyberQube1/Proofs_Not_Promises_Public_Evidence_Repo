#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

python3 - "${REPO_ROOT}" "${SCRIPT_DIR}" "$@" <<'PY'
from __future__ import annotations

import argparse
import csv
import datetime as dt
import json
import pathlib
import re
import subprocess
import sys
from typing import Any

import jsonschema
import yaml


repo_root = pathlib.Path(sys.argv[1]).resolve()
repro_dir = pathlib.Path(sys.argv[2]).resolve()
sha3_pattern = re.compile(r"^[a-f0-9]{64}$")
pending_pattern = re.compile(r"\bPENDING_[A-Z0-9_]+\b")
comparator_fields = {
    "model_provider",
    "backend_kind",
    "model_id",
    "model_version",
    "run_family",
    "api_backend_enabled",
    "api_backend_skip_reason",
    "temperature",
    "max_tokens",
    "seed",
    "deterministic_mode",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Classify Civitas 6.7B paper-eval readiness without running benchmarks."
    )
    parser.add_argument(
        "--mode",
        choices=["smoke", "pilot", "paper"],
        default="smoke",
        help="Requested readiness level. Defaults to smoke.",
    )
    parser.add_argument(
        "--tasks",
        action="append",
        default=[],
        type=pathlib.Path,
        help="Task JSONL to inspect. Repeat for split files.",
    )
    parser.add_argument(
        "--registry",
        type=pathlib.Path,
        default=repo_root / "paper_eval_6.7b" / "policy_corpora" / "policy_corpus_registry.yaml",
        help="Linkage-only Praxis/Aegis policy corpus registry.",
    )
    parser.add_argument(
        "--cassius-evidence",
        type=pathlib.Path,
        help="Receipt-bound Cassius challenge JSONL for claim-supporting paper mode.",
    )
    parser.add_argument(
        "--run-dir",
        type=pathlib.Path,
        help="Existing reproducibility run directory to inspect or verify.",
    )
    parser.add_argument(
        "--claim-api-portability",
        action="store_true",
        help="Declare that this readiness decision intends to claim the API portability lane.",
    )
    parser.add_argument(
        "--api-backend-enabled",
        action="store_true",
        help="Declare a genuinely configured API lane for the selected run.",
    )
    parser.add_argument(
        "--api-backend-skip-reason",
        default="api_backend_not_configured",
        help="Skip reason retained when the optional API lane is absent.",
    )
    parser.add_argument(
        "--out-dir",
        type=pathlib.Path,
        default=repro_dir,
        help="Directory for readiness_report.md and readiness_report.json.",
    )
    return parser.parse_args(sys.argv[3:])


args = parse_args()
args.registry = args.registry.resolve()
args.out_dir = args.out_dir.resolve()
if args.run_dir:
    args.run_dir = args.run_dir.resolve()
else:
    smoke_run = repro_dir / "runs" / "prompt9-smoke-20260521"
    args.run_dir = smoke_run.resolve() if smoke_run.is_dir() and args.mode == "smoke" else None

default_tasks = [
    repo_root / "paper_eval_6.7b" / "tasks" / "train_failures_100.jsonl",
    repo_root / "paper_eval_6.7b" / "tasks" / "heldout_eval_100.jsonl",
    repo_root / "paper_eval_6.7b" / "tasks" / "stress_50.jsonl",
]
task_paths = [(path if path.is_absolute() else repo_root / path).resolve() for path in (args.tasks or default_tasks)]
task_schema_path = repo_root / "paper_eval_6.7b" / "tasks" / "schema" / "task.schema.json"
baseline_schema_path = repo_root / "paper_eval_6.7b" / "schemas" / "baseline_result.schema.json"
heldout_schema_path = repo_root / "paper_eval_6.7b" / "schemas" / "heldout_stress_result.schema.json"
sandbox_schema_path = repo_root / "paper_eval_6.7b" / "schemas" / "sandbox_promotion.schema.json"
gate_schema_path = repo_root / "paper_eval_6.7b" / "schemas" / "governance_gate_result.schema.json"
runner_path = repo_root / "civitas_V.6.7" / "src" / "bin" / "civitas-67b-eval.rs"
bundle_manifest_path = repro_dir / "MANIFEST.md"
verify_script = repro_dir / "VERIFY_RESULTS.sh"
au_verify_script = repro_dir / "VERIFY_AU_PAPER_RESULTS.sh"

checks: list[dict[str, str]] = []
blocking_gaps: list[str] = []
warnings: list[str] = []
next_actions: list[str] = []


def add_check(name: str, ok: bool, detail: str, *, block: bool = True) -> None:
    status = "pass" if ok else ("fail" if block else "warn")
    checks.append({"name": name, "status": status, "detail": detail})
    if ok:
        return
    if block:
        blocking_gaps.append(detail)
    else:
        warnings.append(detail)


def warn(name: str, detail: str) -> None:
    add_check(name, False, detail, block=False)


def load_json(path: pathlib.Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def load_jsonl(path: pathlib.Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError as error:
            raise ValueError(f"parse {path} line {line_number}: {error}") from error
        if not isinstance(row, dict):
            raise ValueError(f"{path} line {line_number} is not a JSON object")
        rows.append(row)
    if not rows:
        raise ValueError(f"{path} has no JSONL rows")
    return rows


def pending_paths(value: Any, path: str = "$") -> list[str]:
    if isinstance(value, dict):
        paths: list[str] = []
        for key, child in value.items():
            paths.extend(pending_paths(child, f"{path}.{key}"))
        return paths
    if isinstance(value, list):
        paths = []
        for index, child in enumerate(value):
            paths.extend(pending_paths(child, f"{path}[{index}]"))
        return paths
    if isinstance(value, str) and pending_pattern.search(value):
        return [path]
    return []


def text_has_placeholder(value: Any) -> bool:
    if isinstance(value, dict):
        return any(text_has_placeholder(child) for child in value.values())
    if isinstance(value, list):
        return any(text_has_placeholder(child) for child in value)
    if not isinstance(value, str):
        return False
    lowered = value.lower()
    return "placeholder" in lowered or lowered.startswith("synthetic_") or "placeholder://" in lowered


def source_refs_are_placeholder(row: dict[str, Any]) -> bool:
    refs = list(row.get("policy_source_refs", [])) + list(row.get("source_document_refs", []))
    return any(text_has_placeholder(ref) or pending_pattern.search(str(ref)) for ref in refs)


def format_paths(paths: list[str], limit: int = 5) -> str:
    if not paths:
        return "none"
    prefix = ", ".join(paths[:limit])
    return prefix if len(paths) <= limit else f"{prefix}, and {len(paths) - limit} more"


registry_entries: dict[str, dict[str, Any]] = {}
registry_pending: dict[str, list[str]] = {}
if not args.registry.is_file():
    add_check("registry_file", False, f"policy corpus registry is absent: {args.registry}")
else:
    add_check("registry_file", True, f"policy corpus registry exists: {args.registry}")
    try:
        registry = yaml.safe_load(args.registry.read_text(encoding="utf-8"))
        registry_entries = registry.get("entries", {}) if isinstance(registry, dict) else {}
        add_check(
            "registry_parse",
            isinstance(registry_entries, dict),
            f"parsed {len(registry_entries) if isinstance(registry_entries, dict) else 0} registry entries",
        )
    except Exception as error:  # noqa: BLE001 - report readiness parse defects verbatim.
        add_check("registry_parse", False, f"cannot parse registry {args.registry}: {error}")

expected_registry_ids = {"au_finance_baseline", "asic", "apra", "eu"}
missing_registry_ids = sorted(expected_registry_ids - set(registry_entries))
add_check(
    "registry_required_entries",
    not missing_registry_ids,
    (
        "registry includes au_finance_baseline, asic, apra, and eu entries"
        if not missing_registry_ids
        else f"registry is missing required entries: {', '.join(missing_registry_ids)}"
    ),
)
for corpus_id, entry in registry_entries.items():
    registry_pending[corpus_id] = pending_paths(entry, f"entries.{corpus_id}")
all_registry_pending = [path for paths in registry_pending.values() for path in paths]
if all_registry_pending:
    registry_pending_detail = f"registry contains unresolved PENDING refs at {format_paths(all_registry_pending)}"
    if args.mode == "smoke":
        warn("registry_pending_refs", registry_pending_detail)
    else:
        checks.append({"name": "registry_pending_refs", "status": "warn", "detail": registry_pending_detail})
        warnings.append(registry_pending_detail)
else:
    add_check("registry_pending_refs", True, "registry has no unresolved PENDING refs")
eu_entry = registry_entries.get("eu", {})
if eu_entry.get("status") == "planned" or eu_entry.get("confidence") == "placeholder":
    warn("eu_registry_status", "EU registry lane remains planned or placeholder and cannot support an EU readiness claim")
else:
    add_check("eu_registry_status", True, "EU registry lane is not marked planned or placeholder")

task_rows: list[dict[str, Any]] = []
task_sources: list[tuple[pathlib.Path, dict[str, Any]]] = []
if not task_schema_path.is_file():
    add_check("task_schema", False, f"task schema is absent: {task_schema_path}")
    task_validator = None
else:
    add_check("task_schema", True, f"task schema exists: {task_schema_path}")
    try:
        task_validator = jsonschema.Draft202012Validator(load_json(task_schema_path))
    except Exception as error:  # noqa: BLE001
        add_check("task_schema_parse", False, f"cannot load task schema {task_schema_path}: {error}")
        task_validator = None

for path in task_paths:
    if not path.is_file():
        add_check("task_file_exists", False, f"task file is absent: {path}")
        continue
    add_check("task_file_exists", True, f"task file exists: {path}")
    try:
        rows = load_jsonl(path)
    except Exception as error:  # noqa: BLE001
        add_check("task_jsonl_parse", False, str(error))
        continue
    before_errors = len(blocking_gaps)
    if task_validator is not None:
        for index, row in enumerate(rows, start=1):
            errors = sorted(task_validator.iter_errors(row), key=lambda error: list(error.path))
            if errors:
                detail = errors[0].message
                add_check(
                    "task_schema_validation",
                    False,
                    f"{path} row {index} fails task schema: {detail}",
                )
    if len(blocking_gaps) == before_errors:
        add_check("task_schema_validation", True, f"{path} has {len(rows)} schema-valid task row(s)")
    task_rows.extend(rows)
    task_sources.extend((path, row) for row in rows)

add_check(
    "task_rows_present",
    bool(task_rows),
    f"loaded {len(task_rows)} task row(s)" if task_rows else "no task rows were loaded",
)
placeholder_tasks = [row.get("task_id", "<unknown>") for row in task_rows if text_has_placeholder(row)]
if placeholder_tasks:
    detail = f"placeholder or synthetic task metadata remains in task row(s): {', '.join(placeholder_tasks[:5])}"
    if args.mode == "smoke":
        warn("task_placeholder_status", detail)
    else:
        add_check("task_placeholder_status", False, detail)
else:
    add_check("task_placeholder_status", True, "selected task rows are not placeholder-labelled")

unknown_corpora = sorted(
    {
        str(row.get("policy_corpus_id", "<missing>"))
        for row in task_rows
        if row.get("policy_corpus_id") not in registry_entries
    }
)
if unknown_corpora:
    detail = f"task rows reference policy_corpus_id values absent from the registry: {', '.join(unknown_corpora)}"
    if args.mode == "smoke":
        warn("task_registry_linkage", detail)
    else:
        add_check("task_registry_linkage", False, detail)
else:
    add_check("task_registry_linkage", True, "selected task rows reference known registry corpus IDs")

claim_supporting_mode = args.mode in {"pilot", "paper"}
if claim_supporting_mode:
    source_placeholder_tasks = [
        str(row.get("task_id", "<unknown>")) for row in task_rows if source_refs_are_placeholder(row)
    ]
    add_check(
        "claim_task_source_refs",
        not source_placeholder_tasks,
        (
            "claim-supporting task rows use non-placeholder source refs"
            if not source_placeholder_tasks
            else f"claim-supporting task rows use placeholder source refs: {', '.join(source_placeholder_tasks[:5])}"
        ),
    )
    task_pending = [
        f"{row.get('task_id', '<unknown>')}:{path}"
        for row in task_rows
        for path in pending_paths(row)
    ]
    add_check(
        "claim_task_pending_refs",
        not task_pending,
        (
            "claim-supporting task rows have no PENDING task fields"
            if not task_pending
            else f"claim-supporting task rows contain PENDING task fields at {format_paths(task_pending)}"
        ),
    )
    linked_pending = [
        f"{corpus_id}:{path}"
        for corpus_id in sorted({str(row.get("policy_corpus_id")) for row in task_rows})
        for path in registry_pending.get(corpus_id, [])
    ]
    add_check(
        "claim_registry_refs_resolved",
        not linked_pending,
        (
            "linked registry entries have no unresolved PENDING refs"
            if not linked_pending
            else f"claim-supporting task registry entries retain PENDING refs at {format_paths(linked_pending)}"
        ),
    )
    paper_task_hash_fields = ["active_law_hash"]
    task_hash_gaps = [
        f"{row.get('task_id', '<unknown>')}:{field}"
        for row in task_rows
        for field in paper_task_hash_fields
        if text_has_placeholder(row.get(field, "")) or pending_pattern.search(str(row.get(field, "")))
    ]
    add_check(
        "claim_active_law_hash",
        not task_hash_gaps,
        (
            "claim-supporting tasks bind non-placeholder active-law hashes"
            if not task_hash_gaps
            else f"claim-supporting tasks lack non-placeholder active-law hashes: {', '.join(task_hash_gaps[:5])}"
        ),
    )
    optional_hash_gaps = [
        f"{row.get('task_id', '<unknown>')}:{field}"
        for row in task_rows
        for field in ["policy_graph_hash", "trust_region_hash"]
        if field in row and (text_has_placeholder(row[field]) or pending_pattern.search(str(row[field])))
    ]
    add_check(
        "claimed_optional_hashes",
        not optional_hash_gaps,
        (
            "claimed policy-graph and trust-region task hashes are non-placeholder"
            if not optional_hash_gaps
            else f"claimed policy-graph or trust-region task hashes are unresolved: {', '.join(optional_hash_gaps[:5])}"
        ),
    )
else:
    warn(
        "smoke_claim_boundary",
        "smoke mode sets claim_supporting_run=false; placeholder tasks and Cassius not_required do not support paper evidence",
    )

cassius_gate_fields_ok = False
if gate_schema_path.is_file() and runner_path.is_file() and verify_script.is_file():
    gate_schema = load_json(gate_schema_path)
    gate_props = set(gate_schema.get("properties", {}))
    runner_text = runner_path.read_text(encoding="utf-8")
    verifier_text = verify_script.read_text(encoding="utf-8")
    cassius_gate_fields_ok = {
        "cassius_required",
        "cassius_state",
        "cassius_receipt_hash",
        "cassius_challenge_id",
        "cassius_source",
    }.issubset(gate_props)
    cassius_fail_closed_ok = (
        "cannot approve without passed Cassius evidence" in runner_text
        and "claim-supporting gate row has no required Cassius binding" in verifier_text
    )
else:
    cassius_fail_closed_ok = False
add_check(
    "cassius_gate_contract",
    cassius_gate_fields_ok and cassius_fail_closed_ok,
    (
        "gate schema, runner, and verifier preserve receipt-bound fail-closed Cassius approval checks"
        if cassius_gate_fields_ok and cassius_fail_closed_ok
        else "Cassius fail-closed gate/schema/verifier contract is incomplete"
    ),
)


def validate_cassius_evidence(path: pathlib.Path) -> tuple[bool, str]:
    if not path.is_file():
        return False, f"Cassius evidence JSONL is absent: {path}"
    try:
        rows = load_jsonl(path)
    except Exception as error:  # noqa: BLE001
        return False, f"Cassius evidence cannot be read: {error}"
    required = {
        "candidate_hash",
        "cassius_state",
        "cassius_receipt_hash",
        "cassius_challenge_id",
        "cassius_summary",
        "cassius_source",
    }
    for index, row in enumerate(rows, start=1):
        missing = sorted(required - set(row))
        if missing:
            return False, f"Cassius evidence row {index} is missing {', '.join(missing)}"
        if row["cassius_state"] not in {"passed", "failed"}:
            return False, f"Cassius evidence row {index} has unsupported cassius_state {row['cassius_state']!r}"
        if row["cassius_source"] not in {"live_invocation", "loaded_artifact"}:
            return False, f"Cassius evidence row {index} has unsupported cassius_source {row['cassius_source']!r}"
        if not sha3_pattern.fullmatch(str(row["candidate_hash"])):
            return False, f"Cassius evidence row {index} has invalid candidate_hash"
        if not sha3_pattern.fullmatch(str(row["cassius_receipt_hash"])):
            return False, f"Cassius evidence row {index} has invalid cassius_receipt_hash"
    return True, f"Cassius evidence JSONL has {len(rows)} receipt-bound row(s): {path}"


if args.mode == "paper":
    if args.cassius_evidence is None:
        add_check(
            "cassius_evidence",
            False,
            "paper mode requires --cassius-evidence for claim-supporting governed approvals",
        )
    else:
        ok, detail = validate_cassius_evidence(args.cassius_evidence.resolve())
        add_check("cassius_evidence", ok, detail)
elif args.cassius_evidence is not None:
    ok, detail = validate_cassius_evidence(args.cassius_evidence.resolve())
    add_check("cassius_evidence", ok, detail)
elif args.mode == "pilot":
    warn(
        "cassius_evidence",
        "pilot readiness may proceed without loaded Cassius evidence, but governed approval requires it before claim support",
    )
else:
    warn(
        "cassius_evidence",
        "smoke mode permits Cassius not_required only for non-claim-supporting rows",
    )

for name, path in [
    ("repro_manifest", bundle_manifest_path),
    ("repro_verify_script", verify_script),
]:
    add_check(name, path.is_file(), f"{name} exists: {path}" if path.is_file() else f"{name} is absent: {path}")

if args.run_dir is None:
    if args.mode == "smoke":
        warn("run_dir", "no smoke run directory was configured for containment inspection")
    else:
        add_check("run_dir", False, f"{args.mode} mode requires --run-dir for reproducibility inspection")
else:
    add_check("run_dir", args.run_dir.is_dir(), f"run directory exists: {args.run_dir}" if args.run_dir.is_dir() else f"run directory is absent: {args.run_dir}")
    run_manifest = args.run_dir / "MANIFEST.md"
    add_check(
        "run_manifest",
        run_manifest.is_file(),
        f"run manifest exists: {run_manifest}" if run_manifest.is_file() else f"run manifest is absent: {run_manifest}",
    )
    if run_manifest.is_file():
        manifest_text = run_manifest.read_text(encoding="utf-8")
        smoke_manifest = "`smoke`" in manifest_text or "Run status is `smoke`" in manifest_text
        if args.mode == "paper":
            add_check(
                "paper_run_boundary",
                not smoke_manifest,
                (
                    "paper mode run manifest is not smoke-labelled"
                    if not smoke_manifest
                    else "paper mode cannot use a smoke reproducibility run as paper evidence"
                ),
            )
            model_manifest_markers = [
                "Model provider",
                "Backend kind",
                "Run family",
                "API backend status",
                "temperature",
                "seed",
            ]
            missing_model_markers = [
                marker for marker in model_manifest_markers if marker not in manifest_text
            ]
            add_check(
                "paper_model_manifest",
                not missing_model_markers,
                (
                    "paper mode run manifest freezes provider/backend/run-family/API/decode metadata"
                    if not missing_model_markers
                    else "paper mode run manifest lacks frozen model markers: "
                    + ", ".join(missing_model_markers)
                ),
            )
        elif smoke_manifest:
            warn("run_boundary", "selected run manifest is smoke-labelled and remains outside paper evidence")

containment_csv = args.run_dir / "results" / "tables" / "governance_containment.csv" if args.run_dir else None
if containment_csv and containment_csv.is_file():
    try:
        with containment_csv.open(encoding="utf-8", newline="") as handle:
            containment = next(csv.DictReader(handle), None)
        containment_ok = bool(containment) and containment.get("production_mutation_count") == "0" and containment.get("unauthorized_promotion_count") == "0"
        add_check(
            "governance_containment_counts",
            containment_ok,
            (
                "run containment table reports production_mutation_count=0 and unauthorized_promotion_count=0"
                if containment_ok
                else f"run containment table does not report zero mutation/unauthorized promotion: {containment_csv}"
            ),
        )
    except Exception as error:  # noqa: BLE001
        add_check("governance_containment_counts", False, f"cannot read containment table {containment_csv}: {error}")
elif args.mode == "paper":
    add_check("governance_containment_counts", False, "paper mode run directory lacks governance_containment.csv")
else:
    warn("governance_containment_counts", "selected run has no containment table to inspect")

if sandbox_schema_path.is_file():
    sandbox_schema = load_json(sandbox_schema_path)
    props = sandbox_schema.get("properties", {})
    sandbox_contract_ok = props.get("sandbox_only", {}).get("const") is True and props.get("production_mutation", {}).get("const") is False
else:
    sandbox_contract_ok = False
add_check(
    "sandbox_only_contract",
    sandbox_contract_ok,
    (
        "sandbox promotion schema fixes sandbox_only=true and production_mutation=false"
        if sandbox_contract_ok
        else "sandbox promotion schema does not prove sandbox-only production_mutation=false rows"
    ),
)

state_path = args.run_dir / "sandbox_promotions" / "sandbox_state.json" if args.run_dir else None
if args.run_dir and not state_path.is_file():
    state_path = args.run_dir / "sandbox" / "sandbox_state.json"
if state_path and state_path.is_file():
    try:
        state = load_json(state_path)
        state_ok = state.get("sandbox_marker") == "paper_eval_sandbox_only" and state.get("production_mutation") is False
        add_check(
            "sandbox_state_marker",
            state_ok,
            (
                "sandbox state marker is present and production_mutation=false"
                if state_ok
                else f"sandbox state is not sandbox-only: {state_path}"
            ),
        )
    except Exception as error:  # noqa: BLE001
        add_check("sandbox_state_marker", False, f"cannot read sandbox state {state_path}: {error}")
elif args.mode == "paper":
    add_check("sandbox_state_marker", False, "paper mode run directory lacks sandbox_promotions/sandbox_state.json")
else:
    warn("sandbox_state_marker", "selected run has no sandbox_state.json to inspect")

if baseline_schema_path.is_file() and heldout_schema_path.is_file() and runner_path.is_file():
    baseline_props = set(load_json(baseline_schema_path).get("properties", {}))
    heldout_props = set(load_json(heldout_schema_path).get("properties", {}))
    runner_text = runner_path.read_text(encoding="utf-8")
    comparator_ok = (
        comparator_fields.issubset(baseline_props)
        and comparator_fields.issubset(heldout_props)
        and "--api-backend-enabled" in runner_text
        and "ApiPortability" in runner_text
    )
else:
    comparator_ok = False
add_check(
    "comparator_metadata_contract",
    comparator_ok,
    (
        "baseline/held-out schemas and eval runner preserve comparator metadata and API skip flags"
        if comparator_ok
        else "comparator metadata support is absent from schemas or eval runner"
    ),
)

api_skip_active = not args.api_backend_enabled
if args.claim_api_portability and api_skip_active:
    add_check(
        "api_portability_claim",
        False,
        f"API portability is claimed while API backend is skipped: {args.api_backend_skip_reason}",
    )
elif args.claim_api_portability:
    add_check("api_portability_claim", True, "API portability claim declares a configured API lane")
else:
    warn(
        "api_portability_claim",
        f"API portability is excluded from claims; optional lane skip reason is {args.api_backend_skip_reason}",
    )

paper_verify_script = au_verify_script if au_verify_script.is_file() else verify_script
if args.mode == "paper" and args.run_dir and paper_verify_script.is_file() and args.run_dir.is_dir():
    verified = subprocess.run(
        ["bash", str(paper_verify_script), str(args.run_dir)],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )
    detail = (
        f"{paper_verify_script.name} passed for {args.run_dir}"
        if verified.returncode == 0
        else f"{paper_verify_script.name} failed for paper mode: {(verified.stderr or verified.stdout).strip()[:600]}"
    )
    add_check("paper_repro_verifier", verified.returncode == 0, detail)
elif args.mode == "paper":
    add_check("paper_repro_verifier", False, "paper mode cannot run an AU paper verifier without an existing run directory and verifier")
else:
    warn("paper_repro_verifier", "full result verifier is required for paper mode; readiness audit did not run it")

if blocking_gaps:
    readiness_status = "not_ready"
elif args.mode == "smoke":
    readiness_status = "smoke_ready"
elif args.mode == "pilot":
    readiness_status = "pilot_ready"
else:
    readiness_status = "paper_evidence_ready"

if readiness_status == "smoke_ready":
    allowed_claims = [
        "research harness smoke readiness",
        "non-claim-supporting sandbox and reproducibility scaffold inspection",
    ]
    disallowed_claims = [
        "paper evidence",
        "Cassius-backed governed improvement claim",
        "API/frontier portability claim",
    ]
elif readiness_status == "pilot_ready":
    allowed_claims = [
        "pilot run readiness for the selected registry-linked local lane",
        "ASIC/APRA baseline-contained framing when task sources say so",
    ]
    disallowed_claims = [
        "full paper evidence before full curated results and verifier closure",
        "API/frontier portability unless an API lane is genuinely configured",
        "EU readiness when the linked EU registry entry remains unresolved",
    ]
elif readiness_status == "paper_evidence_ready":
    allowed_claims = [
        "paper-evidence run readiness for the selected curated task and repro bundle",
        "local model lane readiness with frozen comparator metadata",
    ]
    if args.claim_api_portability:
        allowed_claims.append("configured API portability lane readiness")
    else:
        disallowed_claims = ["API/frontier portability claim is explicitly excluded"]
    disallowed_claims = locals().get("disallowed_claims", [])
else:
    allowed_claims = ["readiness audit output only"]
    disallowed_claims = [
        "smoke, pilot, or paper readiness until blocking gaps close",
        "paper evidence from placeholder or smoke artifacts",
        "API/frontier portability while API lane is skipped",
    ]

if blocking_gaps:
    next_actions.extend(f"Close blocking gap: {gap}" for gap in blocking_gaps[:8])
elif readiness_status == "smoke_ready":
    next_actions.extend(
        [
            "Curate registry-linked pilot task rows with non-placeholder policy refs.",
            "Freeze active-law, policy-graph, trust-region, and Cassius evidence bindings before claim support.",
        ]
    )
elif readiness_status == "pilot_ready":
    next_actions.extend(
        [
            "Run the pilot under a run-local reproducibility bundle.",
            "Load receipt-bound Cassius evidence before governed claim-supporting approvals.",
        ]
    )
else:
    next_actions.append("Execute the selected paper-evidence run and archive its verified manifests and artifacts.")

checked_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
report = {
    "readiness_status": readiness_status,
    "checked_at": checked_at,
    "requested_mode": args.mode,
    "inputs": {
        "registry": str(args.registry),
        "tasks": [str(path) for path in task_paths],
        "cassius_evidence": str(args.cassius_evidence.resolve()) if args.cassius_evidence else None,
        "run_dir": str(args.run_dir) if args.run_dir else None,
        "api_backend_enabled": args.api_backend_enabled,
        "claim_api_portability": args.claim_api_portability,
        "api_backend_skip_reason": args.api_backend_skip_reason,
    },
    "checks": checks,
    "blocking_gaps": blocking_gaps,
    "warnings": warnings,
    "allowed_claims": allowed_claims,
    "disallowed_claims": disallowed_claims,
    "next_required_actions": next_actions,
}


def bullets(values: list[str]) -> list[str]:
    return [f"- {value}" for value in values] if values else ["- none"]


markdown_lines = [
    "# Civitas 6.7B Paper Evidence Readiness Report",
    "",
    "## Status",
    "",
    f"- Requested mode: `{args.mode}`",
    f"- Readiness status: `{readiness_status}`",
    f"- Checked at: `{checked_at}`",
    "",
    "## Claim Boundary",
    "",
    "This checker inspects scaffold and artifact readiness only. It does not generate benchmark evidence, promote candidates, call production governance mutation paths, or make smoke artifacts paper evidence.",
    "",
    "## Inputs",
    "",
    f"- Registry: `{args.registry}`",
    f"- Task files: `{', '.join(str(path) for path in task_paths)}`",
    f"- Cassius evidence: `{report['inputs']['cassius_evidence'] or 'not_provided'}`",
    f"- Run directory: `{args.run_dir or 'not_provided'}`",
    f"- API portability claim: `{args.claim_api_portability}`",
    f"- API backend enabled: `{args.api_backend_enabled}`",
    f"- API skip reason: `{args.api_backend_skip_reason}`",
    "",
    "## Checks",
    "",
    "| Check | Status | Detail |",
    "| --- | --- | --- |",
]
markdown_lines.extend(
    f"| `{item['name']}` | `{item['status']}` | {str(item['detail']).replace('|', '\\|')} |"
    for item in checks
)
markdown_lines.extend(["", "## Blocking Gaps", "", *bullets(blocking_gaps)])
markdown_lines.extend(["", "## Warnings", "", *bullets(warnings)])
markdown_lines.extend(["", "## Allowed Claims", "", *bullets(allowed_claims)])
markdown_lines.extend(["", "## Disallowed Claims", "", *bullets(disallowed_claims)])
markdown_lines.extend(["", "## Next Required Actions", "", *bullets(next_actions), ""])

args.out_dir.mkdir(parents=True, exist_ok=True)
json_path = args.out_dir / "readiness_report.json"
markdown_path = args.out_dir / "readiness_report.md"
json_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
markdown_path.write_text("\n".join(markdown_lines), encoding="utf-8")

print(f"readiness_status={readiness_status}")
print(f"wrote readiness JSON report to {json_path}")
print(f"wrote readiness Markdown report to {markdown_path}")
PY
