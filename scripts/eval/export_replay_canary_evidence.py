#!/usr/bin/env python3
"""Export candidate-bound post-sandbox replay/canary evidence for AU paper runs."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any


def parser() -> argparse.ArgumentParser:
    arg_parser = argparse.ArgumentParser(
        description="Export post-eval replay/canary evidence from scored AU sandbox rows."
    )
    arg_parser.add_argument("--sandbox-state", required=True, type=Path)
    arg_parser.add_argument("--heldout-results", required=True, type=Path)
    arg_parser.add_argument("--stress-results", required=True, type=Path)
    arg_parser.add_argument(
        "--replay-results",
        action="append",
        default=[],
        type=Path,
        help="Optional replay result JSONL. Omit to keep replay_status=not_available.",
    )
    arg_parser.add_argument("--run-id", required=True)
    arg_parser.add_argument("--timestamp", required=True)
    arg_parser.add_argument("--output", required=True, type=Path)
    return arg_parser


def main() -> int:
    args = parser().parse_args()
    sandbox_state = json.loads(args.sandbox_state.read_text(encoding="utf-8"))
    candidate_hashes = list(sandbox_state.get("applied_candidate_hashes", []))
    if not candidate_hashes:
        raise SystemExit("sandbox state has no applied_candidate_hashes for replay/canary evidence")
    heldout_rows = read_jsonl(args.heldout_results)
    stress_rows = read_jsonl(args.stress_results)
    replay_rows = [row for path in args.replay_results for row in read_jsonl(path)]
    rows = [
        evidence_row(
            candidate_hash,
            args.run_id,
            args.timestamp,
            heldout_rows,
            stress_rows,
            replay_rows,
            [
                str(args.heldout_results),
                str(args.stress_results),
                *[str(path) for path in args.replay_results],
            ],
        )
        for candidate_hash in candidate_hashes
    ]
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        "".join(json.dumps(row, sort_keys=True) + "\n" for row in rows),
        encoding="utf-8",
    )
    print(f"wrote {len(rows)} replay/canary evidence row(s) to {args.output}")
    return 0


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        row = json.loads(line)
        if not isinstance(row, dict):
            raise ValueError(f"{path} line {line_number} must be a JSON object")
        rows.append(row)
    return rows


def evidence_row(
    candidate_hash: str,
    run_id: str,
    timestamp: str,
    heldout_rows: list[dict[str, Any]],
    stress_rows: list[dict[str, Any]],
    replay_rows: list[dict[str, Any]],
    artifact_refs: list[str],
) -> dict[str, Any]:
    candidate_heldout = rows_for_candidate(heldout_rows, candidate_hash)
    candidate_stress = rows_for_candidate(stress_rows, candidate_hash)
    candidate_replay = rows_for_candidate(replay_rows, candidate_hash)
    regression_count = sum(is_regression(row) for row in candidate_stress)
    failure_count = sum(bool(row.get("error_flag")) for row in candidate_heldout + candidate_stress)
    canary_status = "not_available"
    if candidate_stress:
        canary_status = "failed" if regression_count or failure_count else "passed"
    replay_status = "not_available"
    if candidate_replay:
        replay_status = (
            "failed"
            if any(is_regression(row) or bool(row.get("error_flag")) for row in candidate_replay)
            else "passed"
        )
    row = {
        "candidate_hash": candidate_hash,
        "run_id": run_id,
        "replay_status": replay_status,
        "canary_status": canary_status,
        "regression_count": regression_count,
        "failure_count": failure_count,
        "artifact_refs": sorted(set(artifact_refs)),
        "summary": (
            f"Post-sandbox evidence binds {len(candidate_heldout)} held-out, "
            f"{len(candidate_stress)} stress, and {len(candidate_replay)} replay row(s)."
        ),
        "receipt_hash": "",
        "evaluated_at": timestamp,
    }
    row["receipt_hash"] = receipt_hash(row)
    return row


def rows_for_candidate(rows: list[dict[str, Any]], candidate_hash: str) -> list[dict[str, Any]]:
    return [row for row in rows if row.get("candidate_hash") == candidate_hash]


def is_regression(row: dict[str, Any]) -> bool:
    return any(
        bool(row.get(field))
        for field in [
            "regression_flag",
            "unsafe_action",
            "policy_violation",
            "contradiction_to_policy",
        ]
    )


def receipt_hash(row: dict[str, Any]) -> str:
    receipt = dict(row)
    receipt["receipt_hash"] = None
    canonical = json.dumps(receipt, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha3_256(canonical).hexdigest()


if __name__ == "__main__":
    raise SystemExit(main())
