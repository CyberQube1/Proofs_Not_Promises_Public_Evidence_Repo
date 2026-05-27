from __future__ import annotations

import unittest

import export_replay_canary_evidence as evidence


class ReplayCanaryEvidenceTests(unittest.TestCase):
    def test_candidate_evidence_counts_stress_regression_and_replay_gap(self) -> None:
        row = evidence.evidence_row(
            "a" * 64,
            "au-run",
            "2026-05-22T00:00:00Z",
            [{"candidate_hash": "a" * 64, "error_flag": False}],
            [
                {
                    "candidate_hash": "a" * 64,
                    "regression_flag": True,
                    "error_flag": False,
                }
            ],
            [],
            ["heldout.jsonl", "stress.jsonl"],
        )

        self.assertEqual(row["canary_status"], "failed")
        self.assertEqual(row["replay_status"], "not_available")
        self.assertEqual(row["regression_count"], 1)
        self.assertEqual(len(row["receipt_hash"]), 64)

    def test_candidate_evidence_replay_passes_when_replay_rows_are_clean(self) -> None:
        row = evidence.evidence_row(
            "b" * 64,
            "au-run",
            "2026-05-22T00:00:00Z",
            [],
            [{"candidate_hash": "b" * 64, "regression_flag": False, "error_flag": False}],
            [{"candidate_hash": "b" * 64, "regression_flag": False, "error_flag": False}],
            ["stress.jsonl", "replay.jsonl"],
        )

        self.assertEqual(row["canary_status"], "passed")
        self.assertEqual(row["replay_status"], "passed")


if __name__ == "__main__":
    unittest.main()
