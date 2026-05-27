from __future__ import annotations

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
CHECKER = REPO_ROOT / "paper_eval_6.7b" / "repro" / "CHECK_AU_PAPER_SETUP.sh"


class AuPaperSetupTests(unittest.TestCase):
    def test_repo_handoff_package_passes_without_full_gemma_run(self) -> None:
        with tempfile.TemporaryDirectory() as raw_temp:
            report = self._run(Path(raw_temp))

        self.assertEqual(report["setup_status"], "au_paper_handoff_setup_ready")
        self.assertEqual(report["blocking_gaps"], [])
        self.assertTrue(
            any("Ollama host/model check is deferred" in warning for warning in report["warnings"]),
            report["warnings"],
        )

    def test_run_env_refuses_placeholder_model_version(self) -> None:
        with tempfile.TemporaryDirectory() as raw_temp:
            report_dir = Path(raw_temp)
            env = os.environ.copy()
            env["MODEL_VERSION"] = "record-ollama-tag-before-run"
            result = subprocess.run(
                [
                    "bash",
                    str(CHECKER),
                    "--require-run-env",
                    "--report-dir",
                    str(report_dir),
                ],
                cwd=REPO_ROOT,
                env=env,
                check=False,
                capture_output=True,
                text=True,
            )
            report = json.loads((report_dir / "au_paper_setup_report.json").read_text())

        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(report["setup_status"], "not_ready")
        self.assertTrue(
            any("MODEL_VERSION must be set" in gap for gap in report["blocking_gaps"]),
            report["blocking_gaps"],
        )

    def _run(self, report_dir: Path) -> dict[str, object]:
        result = subprocess.run(
            ["bash", str(CHECKER), "--report-dir", str(report_dir)],
            cwd=REPO_ROOT,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr or result.stdout)
        return json.loads((report_dir / "au_paper_setup_report.json").read_text())


if __name__ == "__main__":
    unittest.main()
