#!/usr/bin/env python3
"""Validate final AU paper tasks before they can enter evidence runs."""

from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys
from difflib import SequenceMatcher
from typing import Any

import jsonschema
import yaml


PENDING = re.compile(r"\bPENDING_[A-Z0-9_]+\b")
PLACEHOLDER = re.compile(r"placeholder|synthetic_|placeholder://", re.IGNORECASE)
EXPECTED_SPLITS = {
    "train_failures_100.jsonl": "train_failures",
    "heldout_eval_100.jsonl": "heldout_eval",
    "stress_50.jsonl": "stress",
}
FINAL_FIELDS = (
    "active_law_epoch_id",
    "policy_graph_hash",
    "trust_region_hash",
    "praxis_bundle_id",
    "source_document_refs",
    "synthetic_placeholder",
)


def parse_args() -> argparse.Namespace:
    here = pathlib.Path(__file__).resolve()
    eval_root = here.parents[2]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--task-file", action="append", required=True, type=pathlib.Path)
    parser.add_argument("--source-map", default=here.with_name("AU_SOURCE_MAP.yaml"), type=pathlib.Path)
    parser.add_argument("--registry", default=eval_root / "policy_corpora" / "policy_corpus_registry.yaml", type=pathlib.Path)
    parser.add_argument("--schema", default=eval_root / "tasks" / "schema" / "task.schema.json", type=pathlib.Path)
    parser.add_argument(
        "--near-duplicate-threshold",
        type=float,
        default=0.92,
        help="Cross-split normalized prompt similarity that fails leakage review.",
    )
    return parser.parse_args()


def load_yaml(path: pathlib.Path) -> dict[str, Any]:
    value = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"{path} is not a YAML object")
    return value


def load_jsonl(path: pathlib.Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        value = json.loads(line)
        if not isinstance(value, dict):
            raise ValueError(f"{path}:{line_number} is not a JSON object")
        value["_taskset_source_path"] = str(path)
        value["_taskset_source_line"] = line_number
        rows.append(value)
    if not rows:
        raise ValueError(f"{path} has no task rows")
    return rows


def normalized_prompt(value: str) -> str:
    lowered = re.sub(r"[^a-z0-9]+", " ", value.lower())
    return " ".join(lowered.split())


def contains_forbidden_marker(value: Any) -> bool:
    if isinstance(value, dict):
        return any(contains_forbidden_marker(child) for child in value.values())
    if isinstance(value, list):
        return any(contains_forbidden_marker(child) for child in value)
    if isinstance(value, str):
        return bool(PENDING.search(value) or PLACEHOLDER.search(value))
    return False


def allowed_refs(source_map: dict[str, Any]) -> tuple[set[str], set[str], dict[str, dict[str, Any]]]:
    families = source_map.get("source_families", {})
    if not isinstance(families, dict) or not families:
        raise ValueError("AU source map has no source_families")
    policy_refs: set[str] = set()
    document_refs: set[str] = set()
    for family_id, family in families.items():
        if not isinstance(family, dict):
            raise ValueError(f"source family {family_id} is not an object")
        policy_refs.update(str(ref) for ref in family.get("policy_source_refs", []))
        document_refs.update(str(ref) for ref in family.get("source_document_refs", []))
    return policy_refs, document_refs, families


def row_label(row: dict[str, Any]) -> str:
    return f"{row.get('task_id', '<missing-task-id>')}@{row.get('_taskset_source_path')}:{row.get('_taskset_source_line')}"


def row_family_ids(
    row: dict[str, Any], families: dict[str, dict[str, Any]]
) -> set[str]:
    policy_refs = set(str(ref) for ref in row.get("policy_source_refs", []))
    document_refs = set(str(ref) for ref in row.get("source_document_refs", []))
    matched: set[str] = set()
    for family_id, family in families.items():
        family_policy_refs = set(str(ref) for ref in family.get("policy_source_refs", []))
        family_document_refs = set(str(ref) for ref in family.get("source_document_refs", []))
        if policy_refs & family_policy_refs and document_refs & family_document_refs:
            matched.add(family_id)
    return matched


def validate_rows(
    rows: list[dict[str, Any]],
    validator: jsonschema.Draft202012Validator,
    source_map: dict[str, Any],
    registry: dict[str, Any],
    threshold: float,
) -> list[str]:
    errors: list[str] = []
    policy_refs, document_refs, families = allowed_refs(source_map)
    binding = source_map.get("authority_binding", {})
    paper_corpus_id = source_map.get("paper_corpus_id")
    registry_entries = registry.get("entries", {})
    paper_entry = registry_entries.get(paper_corpus_id, {}) if isinstance(registry_entries, dict) else {}

    if not paper_entry:
        errors.append(f"registry does not contain selected paper corpus {paper_corpus_id!r}")
        return errors

    row_ids: dict[str, str] = {}
    prompts: dict[str, dict[str, Any]] = {}
    for row in rows:
        schema_row = {key: value for key, value in row.items() if not key.startswith("_taskset_")}
        label = row_label(row)
        schema_errors = sorted(validator.iter_errors(schema_row), key=lambda error: list(error.path))
        for error in schema_errors:
            path = ".".join(str(part) for part in error.path) or "$"
            errors.append(f"{label} fails task schema at {path}: {error.message}")
        if schema_errors:
            continue

        task_id = str(row["task_id"])
        if task_id in row_ids:
            errors.append(f"duplicate task_id {task_id}: {row_ids[task_id]} and {label}")
        row_ids[task_id] = label

        expected_split = EXPECTED_SPLITS.get(pathlib.Path(str(row["_taskset_source_path"])).name)
        if expected_split and row["split"] != expected_split:
            errors.append(f"{label} has split {row['split']!r}; filename requires {expected_split!r}")
        if row["jurisdiction"] != "AU":
            errors.append(f"{label} must use AU jurisdiction")
        if row["policy_corpus_id"] != paper_corpus_id:
            errors.append(f"{label} must use selected paper corpus {paper_corpus_id!r}")
        if contains_forbidden_marker(schema_row):
            errors.append(f"{label} contains placeholder or PENDING text")
        if row.get("synthetic_placeholder") is not False:
            errors.append(f"{label} must set synthetic_placeholder=false")

        for field in FINAL_FIELDS:
            if field not in row:
                errors.append(f"{label} is missing final task field {field}")
        for field in ("active_law_hash", "active_law_epoch_id", "policy_graph_hash", "trust_region_hash", "praxis_bundle_id"):
            expected = binding.get(field)
            if expected and row.get(field) != expected:
                errors.append(f"{label} field {field} must match AU source map authority binding")

        used_policy_refs = set(str(ref) for ref in row.get("policy_source_refs", []))
        used_document_refs = set(str(ref) for ref in row.get("source_document_refs", []))
        unknown_policy = sorted(used_policy_refs - policy_refs)
        unknown_documents = sorted(used_document_refs - document_refs)
        if unknown_policy:
            errors.append(f"{label} uses policy refs outside AU source map: {', '.join(unknown_policy)}")
        if unknown_documents:
            errors.append(f"{label} uses source document refs outside AU source map: {', '.join(unknown_documents)}")
        matched_families = row_family_ids(row, families)
        if not matched_families:
            errors.append(f"{label} must bind policy and document refs from the same AU source family")
        for family_id in matched_families:
            allowed_buckets = set(families[family_id].get("allowed_buckets", []))
            if row["task_bucket"] not in allowed_buckets:
                errors.append(f"{label} bucket {row['task_bucket']} is not allowed for source family {family_id}")

        prompt_key = normalized_prompt(str(row["prompt"]))
        if prompt_key in prompts:
            previous = prompts[prompt_key]
            if previous["split"] != row["split"]:
                errors.append(f"duplicate cross-split prompt between {row_label(previous)} and {label}")
        prompts[prompt_key] = row

    prompt_rows = list(prompts.values())
    for index, left in enumerate(prompt_rows):
        left_prompt = normalized_prompt(str(left["prompt"]))
        for right in prompt_rows[index + 1 :]:
            if left["split"] == right["split"]:
                continue
            right_prompt = normalized_prompt(str(right["prompt"]))
            similarity = SequenceMatcher(a=left_prompt, b=right_prompt).ratio()
            if similarity >= threshold:
                errors.append(
                    f"near-duplicate cross-split prompt similarity {similarity:.3f} between {row_label(left)} and {row_label(right)}"
                )
    return errors


def main() -> int:
    args = parse_args()
    task_paths = [path.resolve() for path in args.task_file]
    try:
        source_map = load_yaml(args.source_map.resolve())
        registry = load_yaml(args.registry.resolve())
        schema = json.loads(args.schema.resolve().read_text(encoding="utf-8"))
        validator = jsonschema.Draft202012Validator(schema)
        rows = [row for path in task_paths for row in load_jsonl(path)]
        errors = validate_rows(rows, validator, source_map, registry, args.near_duplicate_threshold)
    except Exception as error:  # noqa: BLE001 - validation CLI must report malformed inputs.
        print(f"FAIL: {error}", file=sys.stderr)
        return 2

    if errors:
        print(f"FAIL: {len(errors)} AU taskset validation error(s)", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    split_counts: dict[str, int] = {}
    for row in rows:
        split_counts[str(row["split"])] = split_counts.get(str(row["split"]), 0) + 1
    print(f"PASS: validated {len(rows)} AU paper task row(s)")
    for split, count in sorted(split_counts.items()):
        print(f"- {split}: {count}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
