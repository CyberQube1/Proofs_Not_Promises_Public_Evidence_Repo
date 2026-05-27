#!/usr/bin/env python3
"""Aggregate Civitas 6.7B paper-eval JSONL artifacts into research tables."""

from __future__ import annotations

import argparse
import csv
import json
import math
import random
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any, Iterable


NOT_AVAILABLE = "not_available"
BEHAVIOR_FIELDS = [
    "phase",
    "run_family",
    "model_provider",
    "backend_kind",
    "model_id",
    "condition",
    "task_count",
    "error_count",
    "unsafe_action_count",
    "unsafe_action_rate",
    "unsupported_claim_count",
    "unsupported_claim_rate",
    "policy_violation_count",
    "policy_violation_rate",
    "contradiction_to_policy_count",
    "contradiction_to_policy_rate",
    "correct_control_action_count",
    "correct_control_action_rate",
    "safe_fallback_count",
    "safe_fallback_rate",
    "regression_count",
    "regression_rate",
    "mean_latency_ms",
    "p95_latency_ms",
]
CANDIDATE_LIFECYCLE_FIELDS = [
    "candidates_generated",
    "candidates_rejected",
    "candidates_needing_more_evidence",
    "candidates_blocked_by_policy",
    "candidates_blocked_by_trust_region",
    "candidates_blocked_by_replay",
    "candidates_approved_for_sandbox",
    "candidates_sandbox_promoted",
    "candidates_failed_to_apply",
    "rejection_rate",
    "approval_rate",
    "sandbox_promotion_rate",
]
REJECTION_REASON_FIELDS = [
    "reason_code",
    "count",
    "percentage",
    "example_candidate_id",
    "example_gate_result_id",
]
CONTAINMENT_FIELDS = [
    "unauthorized_promotion_count",
    "production_mutation_count",
    "sandbox_only_promotion_count",
    "trust_region_breach_count",
    "blocked_by_policy_count",
    "blocked_by_replay_count",
    "non_claim_supporting_block_count",
    "heldout_or_stress_candidate_block_count",
    "cassius_required_count",
    "cassius_pass_count",
    "cassius_fail_count",
    "cassius_unavailable_count",
    "cassius_unavailable_claim_supporting_count",
    "trust_region_evidence_row_count",
    "canary_failure_count",
    "receipt_completeness_rate",
    "replay_reproducibility_rate",
    "notes",
]
HELDOUT_DELTA_FIELDS = [
    "metric",
    "baseline_value",
    "governed_improvement_value",
    "absolute_delta",
    "relative_delta",
    "interpretation",
]
HELDOUT_DELTA_METRICS = [
    "unsafe_action_rate",
    "unsupported_claim_rate",
    "policy_violation_rate",
    "contradiction_to_policy_rate",
    "correct_control_action_rate",
    "safe_fallback_rate",
    "regression_rate",
    "mean_latency_ms",
]
RISK_METRICS = {
    "unsafe_action_rate",
    "unsupported_claim_rate",
    "policy_violation_rate",
    "contradiction_to_policy_rate",
    "regression_rate",
}
FINAL_RATE_METRICS = [
    "correct_control_action",
    "unsafe_action",
    "unsupported_claim",
    "policy_violation",
    "contradiction_to_policy",
    "safe_fallback",
]
FINAL_BEHAVIOR_FIELDS = [
    "phase",
    "run_family",
    "model_provider",
    "backend_kind",
    "model_id",
    "condition",
    "metric",
    "count",
    "denominator",
    "rate",
    "wilson_95_low",
    "wilson_95_high",
    "error_count",
]
FINAL_HELDOUT_DELTA_FIELDS = [
    "metric",
    "paired_task_count",
    "baseline_value",
    "governed_improvement_value",
    "absolute_delta",
    "bootstrap_95_low",
    "bootstrap_95_high",
    "interpretation",
]
FINAL_STRESS_FIELDS = [
    "condition",
    "metric",
    "count",
    "denominator",
    "rate",
    "wilson_95_low",
    "wilson_95_high",
    "error_count",
]


JsonRow = dict[str, Any]
InputRecord = dict[str, Any]


def parser() -> argparse.ArgumentParser:
    arg_parser = argparse.ArgumentParser(
        description="Aggregate research-only Civitas 6.7B paper-eval JSONL artifacts."
    )
    for option, help_text in [
        ("baseline-results", "Baseline result JSONL from Prompt 2."),
        ("failure-clusters", "Failure cluster JSONL from Prompt 3."),
        ("candidates", "Improvement candidate JSONL from Prompt 4."),
        ("gate-results", "Governance gate result JSONL from Prompt 5."),
        ("trust-region-evidence", "Trust-region gate evidence JSONL for paper candidates."),
        ("replay-canary-evidence", "Post-sandbox replay/canary evidence JSONL."),
        ("sandbox-promotions", "Sandbox promotion JSONL from Prompt 6."),
        ("heldout-results", "Held-out result JSONL from Prompt 7."),
        ("stress-results", "Stress result JSONL from Prompt 7."),
    ]:
        arg_parser.add_argument(
            f"--{option}",
            action="append",
            default=[],
            type=Path,
            help=f"{help_text} Repeat the option to aggregate multiple files.",
        )
    arg_parser.add_argument(
        "--run-type",
        choices=["smoke", "pilot", "full", "unknown"],
        default="unknown",
        help="Honest research run label written into RESULTS_SUMMARY.md.",
    )
    arg_parser.add_argument(
        "--out-dir",
        required=True,
        type=Path,
        help="Output directory for tables/ and RESULTS_SUMMARY.md.",
    )
    return arg_parser


def main() -> int:
    args = parser().parse_args()
    artifacts, input_records = load_inputs(args)
    out_dir = args.out_dir
    tables_dir = out_dir / "tables"
    figures_dir = out_dir / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)

    behavior_rows = build_behavior_metrics(
        artifacts["baseline_results"],
        artifacts["heldout_results"],
        artifacts["stress_results"],
    )
    api_skip_rows = collect_api_skip_rows(
        artifacts["baseline_results"],
        artifacts["heldout_results"],
        artifacts["stress_results"],
    )
    lifecycle_row = build_candidate_lifecycle(
        artifacts["candidates"],
        artifacts["gate_results"],
        artifacts["sandbox_promotions"],
        input_records,
    )
    rejection_rows = build_rejection_reasons(
        artifacts["gate_results"], artifact_available(input_records, "gate_results")
    )
    containment_row = build_governance_containment(artifacts, input_records)
    heldout_delta_rows = build_heldout_delta(artifacts["heldout_results"])
    final_behavior_rows = build_final_behavior_metrics(behavior_rows)
    final_heldout_delta_rows = build_final_heldout_delta(artifacts["heldout_results"])
    final_stress_rows = build_final_stress_regression(artifacts["stress_results"])

    table_paths = {
        "behavior_metrics": tables_dir / "behavior_metrics.csv",
        "candidate_lifecycle": tables_dir / "candidate_lifecycle.csv",
        "rejection_reasons": tables_dir / "rejection_reasons.csv",
        "governance_containment": tables_dir / "governance_containment.csv",
        "heldout_delta": tables_dir / "heldout_delta.csv",
        "final_behavior_metrics": tables_dir / "final_behavior_metrics.csv",
        "final_heldout_delta": tables_dir / "final_heldout_delta.csv",
        "final_governance_containment": tables_dir / "final_governance_containment.csv",
        "final_candidate_lifecycle": tables_dir / "final_candidate_lifecycle.csv",
        "final_stress_regression": tables_dir / "final_stress_regression.csv",
    }
    write_csv(table_paths["behavior_metrics"], BEHAVIOR_FIELDS, behavior_rows)
    write_csv(
        table_paths["candidate_lifecycle"],
        CANDIDATE_LIFECYCLE_FIELDS,
        [lifecycle_row],
    )
    write_csv(table_paths["rejection_reasons"], REJECTION_REASON_FIELDS, rejection_rows)
    write_csv(
        table_paths["governance_containment"], CONTAINMENT_FIELDS, [containment_row]
    )
    write_csv(table_paths["heldout_delta"], HELDOUT_DELTA_FIELDS, heldout_delta_rows)
    write_csv(table_paths["final_behavior_metrics"], FINAL_BEHAVIOR_FIELDS, final_behavior_rows)
    write_csv(
        table_paths["final_heldout_delta"],
        FINAL_HELDOUT_DELTA_FIELDS,
        final_heldout_delta_rows,
    )
    write_csv(
        table_paths["final_governance_containment"],
        CONTAINMENT_FIELDS,
        [containment_row],
    )
    write_csv(
        table_paths["final_candidate_lifecycle"],
        CANDIDATE_LIFECYCLE_FIELDS,
        [lifecycle_row],
    )
    write_csv(table_paths["final_stress_regression"], FINAL_STRESS_FIELDS, final_stress_rows)

    summary_path = out_dir / "RESULTS_SUMMARY.md"
    summary_path.write_text(
        build_summary(
            args.run_type,
            input_records,
            behavior_rows,
            lifecycle_row,
            containment_row,
            heldout_delta_rows,
            artifacts["stress_results"],
            api_skip_rows,
            table_paths,
        ),
        encoding="utf-8",
    )
    final_summary_path = out_dir / "FINAL_RESULTS_SUMMARY.md"
    final_summary_path.write_text(
        build_final_summary(
            args.run_type,
            final_behavior_rows,
            final_heldout_delta_rows,
            final_stress_rows,
            containment_row,
            table_paths,
        ),
        encoding="utf-8",
    )
    print(f"wrote Prompt 8 tables to {tables_dir}")
    print(f"wrote Prompt 8 Markdown summary to {summary_path}")
    print(f"wrote final paper table summary to {final_summary_path}")
    return 0


def load_inputs(args: argparse.Namespace) -> tuple[dict[str, list[JsonRow]], list[InputRecord]]:
    loaded: dict[str, list[JsonRow]] = {}
    input_records: list[InputRecord] = []
    for artifact_name in [
        "baseline_results",
        "failure_clusters",
        "candidates",
        "gate_results",
        "trust_region_evidence",
        "replay_canary_evidence",
        "sandbox_promotions",
        "heldout_results",
        "stress_results",
    ]:
        rows, records = read_jsonl_inputs(artifact_name, getattr(args, artifact_name))
        loaded[artifact_name] = rows
        input_records.extend(records)
    return loaded, input_records


def read_jsonl_inputs(
    artifact_name: str, paths: list[Path]
) -> tuple[list[JsonRow], list[InputRecord]]:
    if not paths:
        return [], [
            {
                "artifact_type": artifact_name,
                "path": "not_provided",
                "status": "missing",
                "row_count": 0,
            }
        ]

    rows: list[JsonRow] = []
    records: list[InputRecord] = []
    for path in paths:
        if not path.exists():
            records.append(
                {
                    "artifact_type": artifact_name,
                    "path": str(path),
                    "status": "missing",
                    "row_count": 0,
                }
            )
            continue
        file_rows = read_jsonl(path)
        rows.extend(file_rows)
        records.append(
            {
                "artifact_type": artifact_name,
                "path": str(path),
                "status": "available",
                "row_count": len(file_rows),
            }
        )
    return rows, records


def read_jsonl(path: Path) -> list[JsonRow]:
    rows: list[JsonRow] = []
    with path.open(encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            if not line.strip():
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError as error:
                raise ValueError(f"parse {path} line {line_number}: {error}") from error
            if not isinstance(row, dict):
                raise ValueError(f"parse {path} line {line_number}: JSONL row must be an object")
            rows.append(row)
    return rows


def write_csv(path: Path, fieldnames: list[str], rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def build_behavior_metrics(
    baseline_rows: list[JsonRow],
    heldout_rows: list[JsonRow],
    stress_rows: list[JsonRow],
) -> list[dict[str, Any]]:
    grouped: dict[tuple[str, str, str, str, str, str], list[JsonRow]] = defaultdict(list)
    for row in baseline_rows:
        if api_comparator_is_skipped(row):
            continue
        grouped[behavior_group_key(row, "baseline")].append(row)
    for row in heldout_rows + stress_rows:
        if api_comparator_is_skipped(row):
            continue
        grouped[behavior_group_key(row, text_or_na(row.get("phase")))].append(row)
    if not grouped:
        return [{field: NOT_AVAILABLE for field in BEHAVIOR_FIELDS}]
    return [
        behavior_metric_row(phase, run_family, provider, backend, model_id, condition, rows)
        for (phase, run_family, provider, backend, model_id, condition), rows in sorted(
            grouped.items()
        )
    ]


def collect_api_skip_rows(*row_groups: list[JsonRow]) -> list[JsonRow]:
    return [row for rows in row_groups for row in rows if api_comparator_is_skipped(row)]


def api_comparator_is_skipped(row: JsonRow) -> bool:
    return (
        row.get("run_family") == "api_portability"
        and row.get("api_backend_enabled") is False
    )


def behavior_group_key(row: JsonRow, phase: str) -> tuple[str, str, str, str, str, str]:
    return (
        phase,
        text_or_na(row.get("run_family")),
        text_or_na(row.get("model_provider")),
        text_or_na(row.get("backend_kind")),
        text_or_na(row.get("model_id")),
        text_or_na(row.get("condition")),
    )


def behavior_metric_row(
    phase: str,
    run_family: str,
    model_provider: str,
    backend_kind: str,
    model_id: str,
    condition: str,
    rows: list[JsonRow],
) -> dict[str, Any]:
    total = len(rows)
    unsafe_action_count = count_true(rows, "unsafe_action")
    unsupported_claim_count = count_true(rows, "unsupported_claim")
    policy_violation_count = count_true(rows, "policy_violation")
    contradiction_count = count_true(rows, "contradiction_to_policy")
    correct_action_count = count_true(rows, "correct_control_action")
    safe_fallback_count = count_true(rows, "safe_fallback")
    regression_total = [row for row in rows if "regression_flag" in row]
    regression_count: Any = NOT_AVAILABLE
    regression_rate: Any = NOT_AVAILABLE
    if regression_total:
        regression_count = count_true(regression_total, "regression_flag")
        regression_rate = format_rate(regression_count, len(regression_total))
    latencies = numeric_values(rows, "latency_ms")
    return {
        "phase": phase,
        "run_family": run_family,
        "model_provider": model_provider,
        "backend_kind": backend_kind,
        "model_id": model_id,
        "condition": condition,
        "task_count": total,
        "error_count": count_true(rows, "error_flag"),
        "unsafe_action_count": unsafe_action_count,
        "unsafe_action_rate": format_rate(unsafe_action_count, total),
        "unsupported_claim_count": unsupported_claim_count,
        "unsupported_claim_rate": format_rate(unsupported_claim_count, total),
        "policy_violation_count": policy_violation_count,
        "policy_violation_rate": format_rate(policy_violation_count, total),
        "contradiction_to_policy_count": contradiction_count,
        "contradiction_to_policy_rate": format_rate(contradiction_count, total),
        "correct_control_action_count": correct_action_count,
        "correct_control_action_rate": format_rate(correct_action_count, total),
        "safe_fallback_count": safe_fallback_count,
        "safe_fallback_rate": format_rate(safe_fallback_count, total),
        "regression_count": regression_count,
        "regression_rate": regression_rate,
        "mean_latency_ms": format_number(mean(latencies)),
        "p95_latency_ms": format_number(p95(latencies)),
    }


def build_candidate_lifecycle(
    candidates: list[JsonRow],
    gates: list[JsonRow],
    promotions: list[JsonRow],
    input_records: list[InputRecord],
) -> dict[str, Any]:
    candidates_available = artifact_available(input_records, "candidates")
    gates_available = artifact_available(input_records, "gate_results")
    promotions_available = artifact_available(input_records, "sandbox_promotions")
    generated: Any = len(candidates) if candidates_available else NOT_AVAILABLE
    rejected = gate_status_count(gates, "rejected") if gates_available else NOT_AVAILABLE
    needs_evidence = (
        gate_status_count(gates, "needs_more_evidence")
        if gates_available
        else NOT_AVAILABLE
    )
    blocked_policy = (
        gate_status_count(gates, "blocked_by_policy") if gates_available else NOT_AVAILABLE
    )
    blocked_trust_region = (
        gate_status_count(gates, "blocked_by_trust_region")
        if gates_available
        else NOT_AVAILABLE
    )
    blocked_replay = (
        gate_status_count(gates, "blocked_by_replay") if gates_available else NOT_AVAILABLE
    )
    approved = (
        gate_status_count(gates, "approved_for_sandbox")
        if gates_available
        else NOT_AVAILABLE
    )
    promoted = (
        promotion_status_count(promotions, "applied_to_sandbox")
        if promotions_available
        else NOT_AVAILABLE
    )
    failed = (
        promotion_status_count(promotions, "failed_to_apply")
        if promotions_available
        else NOT_AVAILABLE
    )
    return {
        "candidates_generated": generated,
        "candidates_rejected": rejected,
        "candidates_needing_more_evidence": needs_evidence,
        "candidates_blocked_by_policy": blocked_policy,
        "candidates_blocked_by_trust_region": blocked_trust_region,
        "candidates_blocked_by_replay": blocked_replay,
        "candidates_approved_for_sandbox": approved,
        "candidates_sandbox_promoted": promoted,
        "candidates_failed_to_apply": failed,
        "rejection_rate": ratio_or_na(rejected, generated),
        "approval_rate": ratio_or_na(approved, generated),
        "sandbox_promotion_rate": ratio_or_na(promoted, generated),
    }


def build_rejection_reasons(
    gates: list[JsonRow], gates_available: bool
) -> list[dict[str, Any]]:
    if not gates_available:
        return [{field: NOT_AVAILABLE for field in REJECTION_REASON_FIELDS}]

    reason_counts: Counter[str] = Counter()
    examples: dict[str, tuple[str, str]] = {}
    for gate in gates:
        if gate.get("gate_status") == "approved_for_sandbox":
            continue
        for reason in gate.get("reason_codes", []):
            reason_text = str(reason)
            reason_counts[reason_text] += 1
            examples.setdefault(
                reason_text,
                (
                    text_or_na(gate.get("candidate_id")),
                    text_or_na(gate.get("gate_result_id")),
                ),
            )
    total = sum(reason_counts.values())
    result_rows = []
    for reason, count in sorted(reason_counts.items()):
        candidate_id, gate_result_id = examples[reason]
        result_rows.append(
            {
                "reason_code": reason,
                "count": count,
                "percentage": format_rate(count, total),
                "example_candidate_id": candidate_id,
                "example_gate_result_id": gate_result_id,
            }
        )
    return result_rows


def build_governance_containment(
    artifacts: dict[str, list[JsonRow]], input_records: list[InputRecord]
) -> dict[str, Any]:
    gates = artifacts["gate_results"]
    trust_region_evidence = artifacts["trust_region_evidence"]
    replay_canary_evidence = artifacts["replay_canary_evidence"]
    promotions = artifacts["sandbox_promotions"]
    gates_available = artifact_available(input_records, "gate_results")
    promotions_available = artifact_available(input_records, "sandbox_promotions")

    unauthorized: Any = NOT_AVAILABLE
    production_mutation: Any = NOT_AVAILABLE
    sandbox_only: Any = NOT_AVAILABLE
    if promotions_available:
        applied = [
            row for row in promotions if row.get("promotion_status") == "applied_to_sandbox"
        ]
        unauthorized = sum(
            bool(row.get("production_mutation")) or row.get("sandbox_only") is not True
            for row in applied
        )
        production_mutation = count_true(promotions, "production_mutation")
        sandbox_only = sum(
            row.get("sandbox_only") is True and not bool(row.get("production_mutation"))
            for row in applied
        )

    gate_counts: dict[str, Any] = {
        "trust_region_breach_count": NOT_AVAILABLE,
        "blocked_by_policy_count": NOT_AVAILABLE,
        "blocked_by_replay_count": NOT_AVAILABLE,
        "non_claim_supporting_block_count": NOT_AVAILABLE,
        "heldout_or_stress_candidate_block_count": NOT_AVAILABLE,
        "cassius_required_count": NOT_AVAILABLE,
        "cassius_pass_count": NOT_AVAILABLE,
        "cassius_fail_count": NOT_AVAILABLE,
        "cassius_unavailable_count": NOT_AVAILABLE,
        "cassius_unavailable_claim_supporting_count": NOT_AVAILABLE,
        "trust_region_evidence_row_count": (
            len(trust_region_evidence)
            if artifact_available(input_records, "trust_region_evidence")
            else NOT_AVAILABLE
        ),
        "canary_failure_count": (
            sum(row.get("canary_status") == "failed" for row in replay_canary_evidence)
            if artifact_available(input_records, "replay_canary_evidence")
            else NOT_AVAILABLE
        ),
    }
    if gates_available:
        gate_counts = {
            "trust_region_breach_count": count_gate_rows(
                gates,
                lambda row: row.get("gate_status") == "blocked_by_trust_region"
                or has_reason(row, "trust_region_breach"),
            ),
            "blocked_by_policy_count": count_gate_rows(
                gates,
                lambda row: row.get("gate_status") == "blocked_by_policy"
                or has_reason(row, "policy_conflict"),
            ),
            "blocked_by_replay_count": count_gate_rows(
                gates,
                lambda row: row.get("gate_status") == "blocked_by_replay"
                or has_reason(row, "replay_regression")
                or has_reason(row, "canary_failure"),
            ),
            "non_claim_supporting_block_count": count_gate_rows(
                gates, lambda row: has_reason(row, "non_claim_supporting_input")
            ),
            "heldout_or_stress_candidate_block_count": count_gate_rows(
                gates,
                lambda row: row.get("source_split") in {"heldout_eval", "stress"}
                and row.get("gate_status") != "approved_for_sandbox",
            ),
            "cassius_required_count": count_gate_rows(
                gates, lambda row: row.get("cassius_required") is True
            ),
            "cassius_pass_count": cassius_state_count(gates, "passed"),
            "cassius_fail_count": cassius_state_count(gates, "failed"),
            "cassius_unavailable_count": cassius_state_count(gates, "unavailable"),
            "cassius_unavailable_claim_supporting_count": count_gate_rows(
                gates,
                lambda row: cassius_state(row) == "unavailable"
                and row.get("claim_supporting_run") is True,
            ),
            "trust_region_evidence_row_count": (
                len(trust_region_evidence)
                if artifact_available(input_records, "trust_region_evidence")
                else NOT_AVAILABLE
            ),
            "canary_failure_count": (
                sum(row.get("canary_status") == "failed" for row in replay_canary_evidence)
                if artifact_available(input_records, "replay_canary_evidence")
                else NOT_AVAILABLE
            ),
        }

    receipt_rows = collect_receipt_rows(artifacts)
    receipt_rate = NOT_AVAILABLE
    if receipt_rows:
        receipt_rate = format_rate(sum(receipt_is_complete(row) for row in receipt_rows), len(receipt_rows))
    replay_statuses = [
        row.get("replay_status")
        for row in replay_canary_evidence
        if row.get("replay_status") in {"passed", "failed"}
    ]
    replay_rate: Any = NOT_AVAILABLE
    if replay_statuses:
        replay_rate = format_rate(sum(status == "passed" for status in replay_statuses), len(replay_statuses))
    return {
        "unauthorized_promotion_count": unauthorized,
        "production_mutation_count": production_mutation,
        "sandbox_only_promotion_count": sandbox_only,
        **gate_counts,
        "receipt_completeness_rate": receipt_rate,
        "replay_reproducibility_rate": replay_rate,
        "notes": (
            "Receipt completeness covers available behavior, governance-gate, and sandbox "
            "promotion rows with receipt fields. Replay reproducibility stays not_available "
            "until replay/canary evidence includes replay passed/failed rows."
        ),
    }


def build_heldout_delta(heldout_rows: list[JsonRow]) -> list[dict[str, Any]]:
    baseline = [
        row for row in heldout_rows if row.get("condition") == "civitas_6_5b_baseline"
    ]
    governed = [
        row
        for row in heldout_rows
        if row.get("condition") == "civitas_6_7b_governed_improvement"
    ]
    result_rows = []
    for metric in HELDOUT_DELTA_METRICS:
        baseline_value = heldout_metric_value(baseline, metric)
        governed_value = heldout_metric_value(governed, metric)
        delta = metric_delta(baseline_value, governed_value)
        result_rows.append(
            {
                "metric": metric,
                "baseline_value": format_metric_value(baseline_value),
                "governed_improvement_value": format_metric_value(governed_value),
                "absolute_delta": format_metric_value(delta),
                "relative_delta": format_relative_delta(baseline_value, delta),
                "interpretation": heldout_delta_interpretation(metric, delta),
            }
        )
    return result_rows


def build_final_behavior_metrics(behavior_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for behavior in behavior_rows:
        denominator = behavior.get("task_count")
        if not isinstance(denominator, int):
            continue
        for metric in FINAL_RATE_METRICS:
            count = behavior.get(f"{metric}_count")
            if not isinstance(count, int):
                continue
            low, high = wilson_interval(count, denominator)
            rows.append(
                {
                    "phase": behavior["phase"],
                    "run_family": behavior["run_family"],
                    "model_provider": behavior["model_provider"],
                    "backend_kind": behavior["backend_kind"],
                    "model_id": behavior["model_id"],
                    "condition": behavior["condition"],
                    "metric": f"{metric}_rate",
                    "count": count,
                    "denominator": denominator,
                    "rate": format_rate(count, denominator),
                    "wilson_95_low": format_metric_value(low),
                    "wilson_95_high": format_metric_value(high),
                    "error_count": behavior["error_count"],
                }
            )
    return rows or [{field: NOT_AVAILABLE for field in FINAL_BEHAVIOR_FIELDS}]


def build_final_heldout_delta(heldout_rows: list[JsonRow]) -> list[dict[str, Any]]:
    baseline = [row for row in heldout_rows if row.get("condition") == "civitas_6_5b_baseline"]
    governed = [
        row
        for row in heldout_rows
        if row.get("condition") == "civitas_6_7b_governed_improvement"
    ]
    baseline_by_task = rows_by_task(baseline)
    governed_by_task = rows_by_task(governed)
    paired_task_ids = sorted(set(baseline_by_task) & set(governed_by_task))
    result_rows: list[dict[str, Any]] = []
    for metric in HELDOUT_DELTA_METRICS:
        baseline_values: list[float] = []
        governed_values: list[float] = []
        task_deltas: list[float] = []
        for task_id in paired_task_ids:
            baseline_value = heldout_task_metric_value(baseline_by_task[task_id], metric)
            governed_value = heldout_task_metric_value(governed_by_task[task_id], metric)
            if baseline_value is None or governed_value is None:
                continue
            baseline_values.append(baseline_value)
            governed_values.append(governed_value)
            task_deltas.append(governed_value - baseline_value)
        baseline_mean = mean(baseline_values)
        governed_mean = mean(governed_values)
        delta = mean(task_deltas)
        low, high = bootstrap_mean_ci(task_deltas)
        result_rows.append(
            {
                "metric": metric,
                "paired_task_count": len(task_deltas),
                "baseline_value": format_metric_value(baseline_mean),
                "governed_improvement_value": format_metric_value(governed_mean),
                "absolute_delta": format_metric_value(delta),
                "bootstrap_95_low": format_metric_value(low),
                "bootstrap_95_high": format_metric_value(high),
                "interpretation": heldout_delta_interpretation(metric, delta),
            }
        )
    return result_rows


def build_final_stress_regression(stress_rows: list[JsonRow]) -> list[dict[str, Any]]:
    metrics = [
        ("regression_rate", "regression_flag"),
        ("unsafe_action_rate", "unsafe_action"),
        ("policy_violation_rate", "policy_violation"),
        ("contradiction_to_policy_rate", "contradiction_to_policy"),
    ]
    grouped: dict[str, list[JsonRow]] = defaultdict(list)
    for row in stress_rows:
        if not api_comparator_is_skipped(row):
            grouped[text_or_na(row.get("condition"))].append(row)
    rows: list[dict[str, Any]] = []
    for condition, condition_rows in sorted(grouped.items()):
        for metric, field in metrics:
            if field == "regression_flag" and not any(field in row for row in condition_rows):
                continue
            count = count_true(condition_rows, field)
            low, high = wilson_interval(count, len(condition_rows))
            rows.append(
                {
                    "condition": condition,
                    "metric": metric,
                    "count": count,
                    "denominator": len(condition_rows),
                    "rate": format_rate(count, len(condition_rows)),
                    "wilson_95_low": format_metric_value(low),
                    "wilson_95_high": format_metric_value(high),
                    "error_count": count_true(condition_rows, "error_flag"),
                }
            )
    return rows or [{field: NOT_AVAILABLE for field in FINAL_STRESS_FIELDS}]


def rows_by_task(rows: list[JsonRow]) -> dict[str, list[JsonRow]]:
    grouped: dict[str, list[JsonRow]] = defaultdict(list)
    for row in rows:
        grouped[text_or_na(row.get("task_id"))].append(row)
    return grouped


def heldout_task_metric_value(rows: list[JsonRow], metric: str) -> float | None:
    if metric == "mean_latency_ms":
        return mean(numeric_values(rows, "latency_ms"))
    key = "regression_flag" if metric == "regression_rate" else metric.removesuffix("_rate")
    if key == "regression_flag" and not any(key in row for row in rows):
        return None
    return mean([float(bool(row.get(key))) for row in rows])


def wilson_interval(count: int, denominator: int) -> tuple[float | None, float | None]:
    if denominator <= 0:
        return None, None
    z = 1.959963984540054
    phat = count / denominator
    denom = 1 + z * z / denominator
    center = (phat + z * z / (2 * denominator)) / denom
    radius = (
        z
        * math.sqrt((phat * (1 - phat) + z * z / (4 * denominator)) / denominator)
        / denom
    )
    return max(0.0, center - radius), min(1.0, center + radius)


def bootstrap_mean_ci(values: list[float]) -> tuple[float | None, float | None]:
    if not values:
        return None, None
    if len(values) == 1:
        return values[0], values[0]
    rng = random.Random(670022)
    samples = []
    for _ in range(2000):
        samples.append(mean([values[rng.randrange(len(values))] for _ in values]))
    samples.sort()
    return samples[int(0.025 * len(samples))], samples[int(0.975 * len(samples)) - 1]


def build_final_summary(
    run_type: str,
    final_behavior_rows: list[dict[str, Any]],
    final_heldout_delta_rows: list[dict[str, Any]],
    final_stress_rows: list[dict[str, Any]],
    containment_row: dict[str, Any],
    table_paths: dict[str, Path],
) -> str:
    lines = [
        "# Civitas 6.7B Final Paper Table Summary",
        "",
        f"- Run type: `{run_type}`",
        "- Behavior rate intervals use 95% Wilson intervals.",
        "- Held-out paired delta intervals use a fixed-seed 2,000-resample paired bootstrap over aligned task IDs.",
        "- Failed/error rows stay in denominators and keep their error counts visible.",
        "- Sandbox approval remains sandbox-only; this summary does not claim production promotion.",
        "",
    ]
    if run_type == "smoke":
        lines.extend(
            [
                "> WARNING: smoke final-table outputs are plumbing checks only and are not paper evidence.",
                "",
            ]
        )
    lines.extend(["## Final Tables", ""])
    for name in [
        "final_behavior_metrics",
        "final_heldout_delta",
        "final_governance_containment",
        "final_candidate_lifecycle",
        "final_stress_regression",
    ]:
        lines.append(f"- `{name}`: `{table_paths[name]}`")
    lines.extend(
        [
            "",
            "## Evidence Coverage",
            "",
            f"- Final behavior metric rows: `{len(final_behavior_rows)}`",
            f"- Paired held-out delta rows: `{len(final_heldout_delta_rows)}`",
            f"- Stress metric rows: `{len(final_stress_rows)}`",
            f"- Replay reproducibility rate: `{containment_row['replay_reproducibility_rate']}`",
            f"- Canary failure count: `{containment_row['canary_failure_count']}`",
            "",
            "## Reporting Boundary",
            "",
            "- Do not claim statistical significance from these intervals alone.",
            "- Do not merge smoke and full AU evidence rows.",
            "- Exclude API portability unless real API rows were frozen separately.",
            "",
        ]
    )
    return "\n".join(lines)


def build_summary(
    run_type: str,
    input_records: list[InputRecord],
    behavior_rows: list[dict[str, Any]],
    lifecycle_row: dict[str, Any],
    containment_row: dict[str, Any],
    heldout_delta_rows: list[dict[str, Any]],
    stress_rows: list[JsonRow],
    api_skip_rows: list[JsonRow],
    table_paths: dict[str, Path],
) -> str:
    behavior_total = sum(
        row["task_count"] for row in behavior_rows if isinstance(row["task_count"], int)
    )
    tiny = behavior_total < 100
    lines = [
        "# Civitas 6.7B Paper Eval Results Summary",
        "",
        f"## Run Type",
        "",
        f"`{run_type}`",
        "",
    ]
    if tiny:
        lines.extend(
            [
                "> WARNING: Tiny sample size. These aggregates are for scaffold inspection, not statistical inference.",
                "",
            ]
        )
    if run_type == "smoke":
        lines.extend(
            [
                "> WARNING: Smoke artifacts do not constitute paper evidence.",
                "",
            ]
        )
    lines.extend(
        [
            "## Input Artifacts Used",
            "",
            "| Artifact type | Path | Status | Row count |",
            "| --- | --- | --- | ---: |",
        ]
    )
    for record in input_records:
        lines.append(
            "| {} | `{}` | `{}` | {} |".format(
                record["artifact_type"],
                escape_pipe(record["path"]),
                record["status"],
                record["row_count"],
            )
        )
    lines.extend(["", "Generated tables:"])
    for table_name, table_path in table_paths.items():
        lines.append(f"- `{table_name}`: `{table_path}`")
    lines.extend(
        [
            "",
            "## Behavior Metrics Summary",
            "",
            "Behavior metrics count result rows by phase, comparator lane metadata, and condition. Candidate-bound governed rows remain separate result rows.",
            api_skip_summary(api_skip_rows),
            "",
            "| Phase | Run family | Provider | Backend | Model id | Condition | Rows | Errors | Unsafe rate | Correct action rate | Regression rate |",
            "| --- | --- | --- | --- | --- | --- | ---: | ---: | --- | --- | --- |",
        ]
    )
    for row in behavior_rows:
        lines.append(
            "| {} | {} | {} | {} | {} | {} | {} | {} | {} | {} | {} |".format(
                row["phase"],
                row["run_family"],
                row["model_provider"],
                row["backend_kind"],
                row["model_id"],
                row["condition"],
                row["task_count"],
                row["error_count"],
                row["unsafe_action_rate"],
                row["correct_control_action_rate"],
                row["regression_rate"],
            )
        )
    lines.extend(
        [
            "",
            "## Candidate Lifecycle Summary",
            "",
            "| Generated | Rejected | Needs evidence | Approved for sandbox | Sandbox promoted | Failed apply |",
            "| ---: | ---: | ---: | ---: | ---: | ---: |",
            "| {} | {} | {} | {} | {} | {} |".format(
                lifecycle_row["candidates_generated"],
                lifecycle_row["candidates_rejected"],
                lifecycle_row["candidates_needing_more_evidence"],
                lifecycle_row["candidates_approved_for_sandbox"],
                lifecycle_row["candidates_sandbox_promoted"],
                lifecycle_row["candidates_failed_to_apply"],
            ),
            "",
            "Lifecycle rates use generated candidate count as denominator where that input is available.",
            "",
            "## Governance Containment Summary",
            "",
            "| Unauthorized promotions | Production mutations | Sandbox-only promotions | Cassius required | Cassius passed | Cassius failed | Cassius unavailable | Claim-supporting Cassius unavailable | Receipt completeness | Replay reproducibility |",
            "| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |",
            "| {} | {} | {} | {} | {} | {} | {} | {} | {} | {} |".format(
                containment_row["unauthorized_promotion_count"],
                containment_row["production_mutation_count"],
                containment_row["sandbox_only_promotion_count"],
                containment_row["cassius_required_count"],
                containment_row["cassius_pass_count"],
                containment_row["cassius_fail_count"],
                containment_row["cassius_unavailable_count"],
                containment_row["cassius_unavailable_claim_supporting_count"],
                containment_row["receipt_completeness_rate"],
                containment_row["replay_reproducibility_rate"],
            ),
            "",
            containment_row["notes"],
            "",
            "## Held-Out Delta Summary",
            "",
            "| Metric | Baseline | Governed improvement | Absolute delta | Interpretation |",
            "| --- | --- | --- | --- | --- |",
        ]
    )
    for row in heldout_delta_rows:
        lines.append(
            "| {} | {} | {} | {} | {} |".format(
                row["metric"],
                row["baseline_value"],
                row["governed_improvement_value"],
                row["absolute_delta"],
                escape_pipe(row["interpretation"]),
            )
        )
    stress_by_condition: dict[str, list[JsonRow]] = defaultdict(list)
    for row in stress_rows:
        stress_by_condition[text_or_na(row.get("condition"))].append(row)
    lines.extend(
        [
            "",
            "## Stress Regression Summary",
            "",
            "| Condition | Rows | Regression rows | Error rows |",
            "| --- | ---: | ---: | ---: |",
        ]
    )
    if not stress_by_condition:
        lines.append(f"| {NOT_AVAILABLE} | {NOT_AVAILABLE} | {NOT_AVAILABLE} | {NOT_AVAILABLE} |")
    for condition, rows in sorted(stress_by_condition.items()):
        lines.append(
            f"| {condition} | {len(rows)} | {count_true(rows, 'regression_flag')} | {count_true(rows, 'error_flag')} |"
        )
    lines.extend(
        [
            "",
            "## Limitations",
            "",
            f"- Run type is `{run_type}`. Only a full curated run may support final paper tables.",
            "- Smoke and placeholder outputs are harness evidence only; they are not paper evidence.",
            "- Replay reproducibility is `not_available` until replay rerun artifacts are added and aggregated.",
            "- Statistical significance tests are not implemented here, so no significance claim is emitted.",
            "- Missing optional JSONL inputs remain visible in the input table and unavailable cells.",
            "- Sandbox approval and sandbox promotion are not production approval.",
            "",
        ]
    )
    return "\n".join(lines)


def api_skip_summary(rows: list[JsonRow]) -> str:
    if not rows:
        return "Explicit skipped API comparator rows excluded from behavior rates: `0`."
    reasons = Counter(text_or_na(row.get("api_backend_skip_reason")) for row in rows)
    reason_summary = ", ".join(
        f"`{reason}`={count}" for reason, count in sorted(reasons.items())
    )
    return (
        f"Explicit skipped API comparator rows excluded from behavior rates: `{len(rows)}` "
        f"({reason_summary})."
    )


def heldout_metric_value(rows: list[JsonRow], metric: str) -> float | None:
    if not rows:
        return None
    if metric == "mean_latency_ms":
        return mean(numeric_values(rows, "latency_ms"))
    metric_key = metric.removesuffix("_rate")
    if metric_key == "regression" and not any("regression_flag" in row for row in rows):
        return None
    key = "regression_flag" if metric_key == "regression" else metric_key
    return count_true(rows, key) / len(rows)


def metric_delta(baseline_value: float | None, governed_value: float | None) -> float | None:
    if baseline_value is None or governed_value is None:
        return None
    return governed_value - baseline_value


def heldout_delta_interpretation(metric: str, delta: float | None) -> str:
    if delta is None:
        return "not_available because held-out baseline or governed rows are missing"
    if abs(delta) < 1e-12:
        return "no row-level change in this aggregate"
    if metric in RISK_METRICS:
        direction = "lower" if delta < 0 else "higher"
        valence = "directionally favorable" if delta < 0 else "directionally unfavorable"
        return f"governed risk metric is {direction}; {valence}"
    if metric == "correct_control_action_rate":
        valence = "directionally favorable" if delta > 0 else "directionally unfavorable"
        return f"governed correct-control rate changed; {valence}"
    if metric == "mean_latency_ms":
        return "governed mean latency is lower" if delta < 0 else "governed mean latency is higher"
    return "governed safe-fallback rate changed; interpret with task control-action mix"


def format_metric_value(value: float | None) -> str:
    return NOT_AVAILABLE if value is None else format_number(value)


def format_relative_delta(baseline_value: float | None, delta: float | None) -> str:
    if baseline_value is None or delta is None or abs(baseline_value) < 1e-12:
        return NOT_AVAILABLE
    return format_number(delta / baseline_value)


def artifact_available(input_records: list[InputRecord], artifact_name: str) -> bool:
    return any(
        record["artifact_type"] == artifact_name and record["status"] == "available"
        for record in input_records
    )


def collect_receipt_rows(artifacts: dict[str, list[JsonRow]]) -> list[JsonRow]:
    result_rows = []
    for artifact_name in [
        "baseline_results",
        "heldout_results",
        "stress_results",
        "gate_results",
        "sandbox_promotions",
    ]:
        for row in artifacts[artifact_name]:
            if any(
                field in row
                for field in ["receipt_hashes", "gate_receipt_hash", "promotion_receipt_hash"]
            ):
                result_rows.append(row)
    return result_rows


def receipt_is_complete(row: JsonRow) -> bool:
    if "receipt_hashes" in row:
        receipts = row.get("receipt_hashes")
        return isinstance(receipts, list) and bool(receipts) and all(
            non_placeholder_text(value) for value in receipts
        )
    for field in ["gate_receipt_hash", "promotion_receipt_hash"]:
        if field in row:
            return non_placeholder_text(row.get(field))
    return False


def non_placeholder_text(value: Any) -> bool:
    return isinstance(value, str) and value.strip().lower() not in {
        "",
        "missing",
        "not_loaded",
        "not_available",
        "unavailable",
    }


def count_gate_rows(gates: list[JsonRow], predicate: Any) -> int:
    return sum(bool(predicate(row)) for row in gates)


def has_reason(gate: JsonRow, reason: str) -> bool:
    return reason in gate.get("reason_codes", [])


def gate_status_count(gates: list[JsonRow], status: str) -> int:
    return sum(gate.get("gate_status") == status for gate in gates)


def cassius_state(gate: JsonRow) -> str:
    return text_or_na(gate.get("cassius_state", "unavailable"))


def cassius_state_count(gates: list[JsonRow], state: str) -> int:
    return sum(cassius_state(gate) == state for gate in gates)


def promotion_status_count(promotions: list[JsonRow], status: str) -> int:
    return sum(promotion.get("promotion_status") == status for promotion in promotions)


def count_true(rows: Iterable[JsonRow], key: str) -> int:
    return sum(row.get(key) is True for row in rows)


def numeric_values(rows: Iterable[JsonRow], key: str) -> list[float]:
    result = []
    for row in rows:
        value = row.get(key)
        if isinstance(value, bool):
            continue
        if isinstance(value, (int, float)):
            result.append(float(value))
    return result


def ratio_or_na(numerator: Any, denominator: Any) -> str:
    if not isinstance(numerator, int) or not isinstance(denominator, int):
        return NOT_AVAILABLE
    return format_rate(numerator, denominator)


def format_rate(count: int, total: int) -> str:
    if total <= 0:
        return NOT_AVAILABLE
    return format_number(count / total)


def mean(values: list[float]) -> float | None:
    return None if not values else sum(values) / len(values)


def p95(values: list[float]) -> float | None:
    if not values:
        return None
    sorted_values = sorted(values)
    index = max(0, math.ceil(len(sorted_values) * 0.95) - 1)
    return sorted_values[index]


def format_number(value: float | None) -> str:
    return NOT_AVAILABLE if value is None else f"{value:.6f}"


def text_or_na(value: Any) -> str:
    return str(value) if value not in (None, "") else NOT_AVAILABLE


def escape_pipe(value: Any) -> str:
    return str(value).replace("|", "\\|")


if __name__ == "__main__":
    raise SystemExit(main())
