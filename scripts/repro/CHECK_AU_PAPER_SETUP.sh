#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
AU_ENV="${AU_PAPER_ENV_FILE:-${SCRIPT_DIR}/AU_PAPER_ENV.sh}"
if [[ -f "${AU_ENV}" ]]; then
  # shellcheck source=/dev/null
  source "${AU_ENV}"
fi

python3 - "${REPO_ROOT}" "${SCRIPT_DIR}" "$@" <<'PY'
from __future__ import annotations

import argparse
import datetime as dt
import importlib.util
import json
import os
import pathlib
import shutil
import subprocess
import sys
import urllib.error
import urllib.request
from typing import Any


repo_root = pathlib.Path(sys.argv[1]).resolve()
repro_dir = pathlib.Path(sys.argv[2]).resolve()
eval_root = repo_root / "paper_eval_6.7b"
task_root = eval_root / "tasks" / "au_finance_v1"
validator = task_root / "validate_au_taskset.py"
scope_validator = eval_root / "policy_corpora" / "validate_au_paper_scope.py"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Verify the committed AU paper-evidence run package before the Gemma VM run."
    )
    parser.add_argument(
        "--require-run-env",
        action="store_true",
        help="Require a concrete model version and runnable Cargo/Python toolchain.",
    )
    parser.add_argument(
        "--require-ollama",
        action="store_true",
        help="Require the configured Ollama host and selected model tag to be available.",
    )
    parser.add_argument(
        "--report-dir",
        type=pathlib.Path,
        default=repro_dir,
        help="Write au_paper_setup_report.json and .md here.",
    )
    return parser.parse_args(sys.argv[3:])


args = parse_args()
if args.require_ollama:
    args.require_run_env = True
report_dir = args.report_dir.resolve()
checks: list[dict[str, str]] = []
blocking_gaps: list[str] = []
warnings: list[str] = []


def add_check(name: str, ok: bool, detail: str, *, block: bool = True) -> None:
    status = "pass" if ok else ("fail" if block else "warn")
    checks.append({"name": name, "status": status, "detail": detail})
    if ok:
        return
    if block:
        blocking_gaps.append(detail)
    else:
        warnings.append(detail)


def required_files() -> list[pathlib.Path]:
    return [
        repo_root / "civitas_V.6.7" / "Cargo.toml",
        repo_root / "civitas_V.6.7" / "src" / "bin" / "civitas-67b-eval.rs",
        repro_dir / "AU_PAPER_ENV.sh",
        repro_dir / "RUN_AU_PAPER.sh",
        repro_dir / "VERIFY_AU_PAPER_RESULTS.sh",
        repro_dir / "QA_AU_PAPER_EVIDENCE.sh",
        repro_dir / "CHECK_PAPER_READINESS.sh",
        eval_root / "scripts" / "score_results.py",
        eval_root / "scripts" / "aggregate_results.py",
        eval_root / "scripts" / "export_replay_canary_evidence.py",
        eval_root / "policy_corpora" / "policy_corpus_registry.yaml",
        eval_root / "policy_corpora" / "AU_PAPER_SCOPE_BINDING.md",
        scope_validator,
        task_root / "AU_SOURCE_MAP.yaml",
        task_root / "TASKSET_MANIFEST.md",
        validator,
        task_root / "train_failures_100.jsonl",
        task_root / "heldout_eval_100.jsonl",
        task_root / "stress_50.jsonl",
    ]


def command_check(name: str, command: list[str]) -> None:
    result = subprocess.run(command, cwd=repo_root, capture_output=True, text=True, check=False)
    detail_text = (result.stdout or result.stderr).strip().splitlines()
    suffix = detail_text[-1] if detail_text else "no output"
    add_check(
        name,
        result.returncode == 0,
        f"{' '.join(command)} {'passed' if result.returncode == 0 else 'failed'}: {suffix}",
    )


def task_rows(path: pathlib.Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            value = json.loads(line)
            if not isinstance(value, dict):
                raise ValueError(f"{path} contains non-object JSONL")
            rows.append(value)
    return rows


def check_task_counts() -> None:
    expected = {
        "train_failures_100.jsonl": ("train_failures", 100),
        "heldout_eval_100.jsonl": ("heldout_eval", 100),
        "stress_50.jsonl": ("stress", 50),
    }
    errors: list[str] = []
    for name, (split, count) in expected.items():
        path = task_root / name
        try:
            rows = task_rows(path)
        except Exception as error:  # noqa: BLE001 - surface handoff parse defects.
            errors.append(str(error))
            continue
        if len(rows) != count:
            errors.append(f"{name} has {len(rows)} row(s), expected {count}")
        wrong = [str(row.get("task_id", "<unknown>")) for row in rows if row.get("split") != split]
        if wrong:
            errors.append(f"{name} has wrong split row(s): {', '.join(wrong[:3])}")
    add_check(
        "au_task_counts",
        not errors,
        "AU task files retain 100 train, 100 held-out, and 50 stress rows"
        if not errors
        else "; ".join(errors),
    )


def check_not_ignored(paths: list[pathlib.Path]) -> None:
    git = shutil.which("git")
    if git is None:
        add_check(
            "git_ignore_boundary",
            False,
            "git is unavailable; could not verify AU handoff files are not ignored",
            block=False,
        )
        return
    relative = [str(path.relative_to(repo_root)) for path in paths if path.exists()]
    result = subprocess.run(
        [git, "check-ignore", "-v", *relative],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )
    ignored = [line for line in result.stdout.splitlines() if line.strip()]
    add_check(
        "git_ignore_boundary",
        not ignored,
        "required AU paper handoff files are not ignored by git"
        if not ignored
        else "required AU paper handoff files are ignored: " + "; ".join(ignored[:4]),
    )


def check_runner_is_repo_local() -> None:
    forbidden = ("/home/spqr-admin/praxis-admin", "/home/spqr-admin/aegis-kernel")
    inspected = [repro_dir / "RUN_AU_PAPER.sh", repro_dir / "AU_PAPER_ENV.sh"]
    hits = [
        f"{path.name}:{needle}"
        for path in inspected
        for needle in forbidden
        if needle in path.read_text(encoding="utf-8")
    ]
    add_check(
        "runner_repo_local_inputs",
        not hits,
        "AU runner and env source do not read local Praxis/Aegis checkout paths"
        if not hits
        else "AU runner or env source retains external checkout path(s): " + ", ".join(hits),
    )


def check_python_deps() -> None:
    missing = [name for name in ["jsonschema", "yaml"] if importlib.util.find_spec(name) is None]
    add_check(
        "python_validation_dependencies",
        not missing,
        "jsonschema and PyYAML are available for AU validators and readiness checks"
        if not missing
        else "missing Python validation dependencies: " + ", ".join(missing),
    )


def env_value(name: str) -> str:
    return str(os.environ.get(name, "")).strip()


def check_run_env() -> None:
    required = ["ACTIVE_LAW_HASH", "POLICY_GRAPH_HASH", "TRUST_REGION_HASH", "MODEL_ID", "MODEL_VERSION"]
    missing = [name for name in required if not env_value(name)]
    add_check(
        "run_env_values",
        not missing,
        "AU authority hashes and model identity env values are present"
        if not missing
        else "AU run env is missing " + ", ".join(missing),
    )
    placeholders = {
        "record-ollama-tag-before-run",
        "local-tag-required",
        "not_loaded",
        "unavailable",
    }
    concrete_version = env_value("MODEL_VERSION") not in placeholders
    add_check(
        "model_version_frozen",
        concrete_version,
        f"MODEL_VERSION is frozen as {env_value('MODEL_VERSION')}"
        if concrete_version
        else "MODEL_VERSION must be set to the actual Ollama model digest/tag before the paper run",
        block=args.require_run_env,
    )
    tool_missing = [tool for tool in ["cargo", "python3", "protoc"] if shutil.which(tool) is None]
    add_check(
        "run_toolchain",
        not tool_missing,
        "cargo, python3, and protoc are available"
        if not tool_missing
        else "missing run tool(s): " + ", ".join(tool_missing),
        block=args.require_run_env,
    )
    pkg_config = shutil.which("pkg-config")
    if pkg_config is None:
        add_check(
            "rust_fontconfig_build_dependency",
            False,
            "missing run tool(s): pkg-config; install pkg-config and libfontconfig1-dev before Cargo builds the eval binary",
            block=args.require_run_env,
        )
        return
    fontconfig = subprocess.run(
        [pkg_config, "--exists", "fontconfig"],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )
    add_check(
        "rust_fontconfig_build_dependency",
        fontconfig.returncode == 0,
        "pkg-config can resolve fontconfig for Rust plot/font dependencies"
        if fontconfig.returncode == 0
        else "pkg-config cannot resolve fontconfig; install libfontconfig1-dev before Cargo builds the eval binary",
        block=args.require_run_env,
    )


def check_ollama() -> None:
    host = env_value("OLLAMA_HOST") or "http://localhost:11434"
    model_id = env_value("MODEL_ID")
    endpoint = host.rstrip("/") + "/api/tags"
    try:
        with urllib.request.urlopen(endpoint, timeout=10) as response:
            payload = json.loads(response.read().decode("utf-8"))
    except (OSError, urllib.error.URLError, json.JSONDecodeError) as error:
        add_check("ollama_api", False, f"cannot read Ollama tags from {endpoint}: {error}")
        return
    models = payload.get("models", []) if isinstance(payload, dict) else []
    names = {
        str(model.get(field))
        for model in models
        if isinstance(model, dict)
        for field in ["name", "model"]
        if model.get(field)
    }
    add_check("ollama_api", True, f"Ollama tags endpoint is reachable at {endpoint}")
    add_check(
        "ollama_model",
        model_id in names,
        f"Ollama model {model_id} is installed"
        if model_id in names
        else f"Ollama model {model_id} is not present in /api/tags",
    )


files = required_files()
missing_files = [str(path.relative_to(repo_root)) for path in files if not path.is_file()]
add_check(
    "repo_inputs",
    not missing_files,
    "all AU paper runner, registry, task, scoring, evidence, and QA inputs exist in this checkout"
    if not missing_files
    else "missing AU paper input file(s): " + ", ".join(missing_files),
)
check_not_ignored(files)
check_runner_is_repo_local()
check_python_deps()
check_task_counts()
command_check("au_authority_validator", [sys.executable, str(scope_validator)])
command_check(
    "au_taskset_validator",
    [
        sys.executable,
        str(validator),
        "--task-file",
        str(task_root / "train_failures_100.jsonl"),
        "--task-file",
        str(task_root / "heldout_eval_100.jsonl"),
        "--task-file",
        str(task_root / "stress_50.jsonl"),
    ],
)
check_run_env()
if args.require_ollama:
    check_ollama()
else:
    add_check(
        "ollama_api",
        False,
        "Ollama host/model check is deferred; pass --require-ollama on the Gemma VM",
        block=False,
    )

status = "not_ready" if blocking_gaps else (
    "au_paper_run_env_ready" if args.require_ollama else "au_paper_handoff_setup_ready"
)
checked_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
report = {
    "setup_status": status,
    "checked_at": checked_at,
    "require_run_env": args.require_run_env,
    "require_ollama": args.require_ollama,
    "checks": checks,
    "blocking_gaps": blocking_gaps,
    "warnings": warnings,
    "next_actions": (
        [f"Close blocking gap: {gap}" for gap in blocking_gaps]
        if blocking_gaps
        else (
            ["Run RUN_AU_PAPER.sh on this Gemma VM."]
            if args.require_ollama
            else [
                "Commit this checkout and move it to the Gemma VM.",
                "Set MODEL_VERSION to that VM's actual Ollama model digest/tag.",
                "Run this checker again with --require-ollama before RUN_AU_PAPER.sh.",
            ]
        )
    ),
}


def bullets(values: list[str]) -> list[str]:
    return [f"- {value}" for value in values] if values else ["- none"]


lines = [
    "# Civitas 6.7B AU Paper Run Setup Report",
    "",
    f"- Setup status: `{status}`",
    f"- Checked at: `{checked_at}`",
    f"- Require run env: `{args.require_run_env}`",
    f"- Require Ollama: `{args.require_ollama}`",
    "",
    "This report verifies the commit-and-run AU paper-evidence package. It does not run the full Gemma matrix or create result evidence.",
    "",
    "## Checks",
    "",
    "| Check | Status | Detail |",
    "| --- | --- | --- |",
]
lines.extend(
    f"| `{row['name']}` | `{row['status']}` | {row['detail'].replace('|', '\\|')} |"
    for row in checks
)
lines.extend(["", "## Blocking Gaps", "", *bullets(blocking_gaps)])
lines.extend(["", "## Warnings", "", *bullets(warnings)])
lines.extend(["", "## Next Actions", "", *bullets(report["next_actions"]), ""])

report_dir.mkdir(parents=True, exist_ok=True)
(report_dir / "au_paper_setup_report.json").write_text(
    json.dumps(report, indent=2, sort_keys=True) + "\n",
    encoding="utf-8",
)
(report_dir / "au_paper_setup_report.md").write_text("\n".join(lines), encoding="utf-8")

print(f"setup_status={status}")
print(f"wrote AU setup JSON report to {report_dir / 'au_paper_setup_report.json'}")
print(f"wrote AU setup Markdown report to {report_dir / 'au_paper_setup_report.md'}")
if blocking_gaps:
    raise SystemExit(1)
PY
