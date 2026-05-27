#!/usr/bin/env python3
"""Validate the resolved Australian finance paper scope registry lane."""

from __future__ import annotations

import argparse
import pathlib
import re
import sys
from typing import Any

import yaml


PENDING = re.compile(r"\bPENDING_[A-Z0-9_]+\b")
PAPER_CORPUS_ID = "au_finance_paper_scope"
REQUIRED_REAL_FIELDS = [
    "praxis_corpus_ref",
    "praxis_bundle_id",
    "praxis_bundle_version",
    "praxis_artifact_uri",
    "baseline_slug",
    "baseline_release_id",
    "baseline_minio_prefix",
    "aegis_active_governance_artifact_ref",
    "aegis_active_governance_bundle_id",
    "aegis_active_governance_bundle_version",
    "aegis_active_law_hash",
    "active_law_epoch_id",
    "active_law_epoch_root",
    "active_law_epoch_sequence_root",
    "active_law_epoch_sequence_index",
    "active_law_epoch_ilk_ref",
    "active_law_state",
    "constitutional_graph_ref",
    "policy_graph_hash",
    "trust_region_ref",
    "trust_region_hash",
    "source_bundle_root",
    "activated_at",
]
APRA_MARKERS = ["APRA CPS 234", "cps_234_july_2019_for_public_release"]
ASIC_MARKERS = [
    "rg234-published-15-november-2012-20211008",
    "rg271-published-2-september-2021",
    "rg274-published-10-september-2024",
]


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
    if isinstance(value, str) and PENDING.search(value):
        return [path]
    return []


def validate_registry(registry_path: pathlib.Path) -> list[str]:
    payload = yaml.safe_load(registry_path.read_text(encoding="utf-8"))
    entries = payload.get("entries", {}) if isinstance(payload, dict) else {}
    entry = entries.get(PAPER_CORPUS_ID)
    errors: list[str] = []
    if not isinstance(entry, dict):
        return [f"missing registry entry {PAPER_CORPUS_ID!r}"]

    for field in REQUIRED_REAL_FIELDS:
        if field not in entry or entry[field] in (None, "", []):
            errors.append(f"{PAPER_CORPUS_ID}.{field} is missing")
    for path in pending_paths(entry, f"entries.{PAPER_CORPUS_ID}"):
        errors.append(f"selected AU paper lane retains pending value at {path}")

    source_refs = [str(ref) for ref in entry.get("source_refs", [])]
    if not any(marker in ref for marker in APRA_MARKERS for ref in source_refs):
        errors.append("selected AU paper lane lacks APRA source refs")
    missing_asic = [
        marker for marker in ASIC_MARKERS if not any(marker in ref for ref in source_refs)
    ]
    if missing_asic:
        errors.append("selected AU paper lane lacks ASIC source refs: " + ", ".join(missing_asic))
    if entry.get("jurisdiction") != "AU":
        errors.append("selected AU paper lane jurisdiction is not AU")
    if entry.get("status") != "active_in_aegis":
        errors.append("selected AU paper lane is not marked active_in_aegis")
    if entries.get("eu", {}).get("status") != "planned":
        errors.append("EU lane should remain excluded/planned for this AU paper path")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--registry",
        type=pathlib.Path,
        default=pathlib.Path(__file__).with_name("policy_corpus_registry.yaml"),
    )
    args = parser.parse_args()
    errors = validate_registry(args.registry)
    if errors:
        for error in errors:
            print(f"FAIL: {error}", file=sys.stderr)
        return 1
    print(f"PASS: {PAPER_CORPUS_ID} has resolved AU paper authority bindings")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
