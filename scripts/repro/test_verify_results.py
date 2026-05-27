from __future__ import annotations

import csv
import json
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
VERIFY = REPO_ROOT / "paper_eval_6.7b" / "repro" / "VERIFY_RESULTS.sh"


class VerifyResultsCassiusTests(unittest.TestCase):
    def test_rejects_claim_supporting_unavailable_cassius(self) -> None:
        with tempfile.TemporaryDirectory() as raw_temp:
            run = Path(raw_temp) / "run"
            self._write_run(run)

            result = subprocess.run(
                ["bash", str(VERIFY), str(run)],
                cwd=REPO_ROOT,
                check=False,
                capture_output=True,
                text=True,
            )

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("claim-supporting gate row has Cassius state", result.stderr)

    def _write_run(self, run: Path) -> None:
        for relative in [
            "baseline",
            "failure_clusters",
            "candidates",
            "gate_results",
            "sandbox_promotions",
            "heldout_results",
            "stress_results",
            "results/tables",
        ]:
            (run / relative).mkdir(parents=True, exist_ok=True)

        self._jsonl(run / "baseline/civitas_6_5b_baseline.jsonl", {"row": "baseline"})
        self._jsonl(
            run / "baseline/civitas_6_7b_no_improvement.jsonl", {"row": "baseline"}
        )
        self._jsonl(
            run / "baseline/civitas_6_7b_no_improvement.scored_smoke.jsonl",
            {"row": "scored"},
        )
        self._jsonl(
            run / "failure_clusters/train_smoke.clusters.jsonl",
            {"source_split": "train_failures"},
        )
        self._jsonl(
            run / "candidates/train_smoke.candidates.jsonl",
            {"source_split": "train_failures"},
        )
        self._jsonl(
            run / "gate_results/train_smoke.gate_results.jsonl",
            {
                "source_split": "train_failures",
                "gate_status": "needs_more_evidence",
                "claim_supporting_run": True,
                "cassius_required": True,
                "cassius_state": "unavailable",
                "cassius_receipt_hash": "unavailable",
            },
        )
        self._jsonl(
            run / "sandbox_promotions/sandbox_promotions.jsonl",
            {
                "promotion_status": "skipped_rejected",
                "production_mutation": False,
                "sandbox_only": True,
            },
        )
        self._jsonl(run / "heldout_results/heldout_smoke.jsonl", {"row": "heldout"})
        self._jsonl(run / "stress_results/stress_smoke.jsonl", {"row": "stress"})
        (run / "sandbox_promotions/sandbox_state.json").write_text(
            json.dumps(
                {
                    "sandbox_marker": "paper_eval_sandbox_only",
                    "production_mutation": False,
                    "overlays": [],
                }
            ),
            encoding="utf-8",
        )
        (run / "MANIFEST.md").write_text(
            "\n".join(
                [
                    "Git commit hash `a`",
                    "Working tree status `dirty`",
                    "Baseline config hash `b`",
                    "Train task file hash `c`",
                    "Held-out task file hash `d`",
                    "Stress task file hash `e`",
                    "Sandbox state file hash `" + "f" * 64 + "`",
                    "## Claim Boundary",
                    "Production mutation count `0`",
                    "Unauthorized promotion count `0`",
                ]
            ),
            encoding="utf-8",
        )
        (run / "results/RESULTS_SUMMARY.md").write_text("fixture summary\n", encoding="utf-8")
        for name in [
            "behavior_metrics.csv",
            "candidate_lifecycle.csv",
            "rejection_reasons.csv",
            "heldout_delta.csv",
        ]:
            self._csv(run / "results/tables" / name, ["fixture"], ["1"])
        self._csv(
            run / "results/tables/governance_containment.csv",
            ["production_mutation_count", "unauthorized_promotion_count"],
            ["0", "0"],
        )

    def _jsonl(self, path: Path, row: dict[str, object]) -> None:
        path.write_text(json.dumps(row) + "\n", encoding="utf-8")

    def _csv(self, path: Path, header: list[str], row: list[str]) -> None:
        with path.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.writer(handle)
            writer.writerow(header)
            writer.writerow(row)


if __name__ == "__main__":
    unittest.main()
