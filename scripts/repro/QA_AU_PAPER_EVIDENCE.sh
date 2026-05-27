#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="${1:?usage: QA_AU_PAPER_EVIDENCE.sh <au-paper-run-dir>}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

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

python3 - "${RUN_DIR}" <<'PY'
from __future__ import annotations

import json
import pathlib
import sys

run_dir = pathlib.Path(sys.argv[1]).resolve()
report = json.loads((run_dir / "results" / "readiness_report.json").read_text(encoding="utf-8"))
ready = report.get("readiness_status") == "paper_evidence_ready"
verdict = "paper_evidence_ready" if ready else "not_ready"
gaps = report.get("blocking_gaps", [])
lines = [
    "# Civitas 6.7B AU Final Paper Evidence QA",
    "",
    f"- Verdict: `{verdict}`",
    f"- Evidence bundle: `{run_dir}`",
    f"- Readiness report: `{run_dir / 'results' / 'readiness_report.md'}`",
    "",
    "## Checks",
    "",
    "- AU paper verifier passed before this report was written.",
    f"- Paper readiness status is `{report.get('readiness_status')}`.",
    "- Final tables, sandbox markers, Cassius evidence, trust-region evidence, and replay/canary evidence are verifier inputs.",
    "",
    "## Blocking Gaps",
    "",
]
lines.extend([f"- {gap}" for gap in gaps] or ["- none"])
lines.extend(
    [
        "",
        "## Claim Boundary",
        "",
        "- AU finance lane only.",
        "- Production mutation and unauthorized promotion must stay zero.",
        "- Smoke and skipped API rows are outside the paper-evidence bundle.",
        "",
    ]
)
(run_dir / "QA_FINAL_PAPER_EVIDENCE.md").write_text("\n".join(lines), encoding="utf-8")
print(f"wrote final AU QA report to {run_dir / 'QA_FINAL_PAPER_EVIDENCE.md'}")
if not ready:
    raise SystemExit("AU final QA stopped: readiness status is not paper_evidence_ready")
PY
