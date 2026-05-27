from __future__ import annotations

import unittest

import aggregate_results


class GovernanceContainmentCassiusTests(unittest.TestCase):
    def test_counts_cassius_gate_states(self) -> None:
        artifacts = {
            "baseline_results": [],
            "failure_clusters": [],
            "candidates": [],
            "gate_results": [
                {
                    "cassius_required": True,
                    "cassius_state": "passed",
                    "claim_supporting_run": True,
                    "gate_status": "approved_for_sandbox",
                    "source_split": "train_failures",
                },
                {
                    "cassius_required": True,
                    "cassius_state": "failed",
                    "claim_supporting_run": False,
                    "gate_status": "rejected",
                    "source_split": "train_failures",
                },
                {
                    "cassius_required": True,
                    "cassius_state": "unavailable",
                    "claim_supporting_run": True,
                    "gate_status": "needs_more_evidence",
                    "source_split": "train_failures",
                },
            ],
            "trust_region_evidence": [],
            "replay_canary_evidence": [],
            "sandbox_promotions": [],
            "heldout_results": [],
            "stress_results": [],
        }
        inputs = [
            {
                "artifact_type": "gate_results",
                "path": "fixture.jsonl",
                "status": "available",
                "row_count": 3,
            }
        ]

        row = aggregate_results.build_governance_containment(artifacts, inputs)

        self.assertEqual(row["cassius_required_count"], 3)
        self.assertEqual(row["cassius_pass_count"], 1)
        self.assertEqual(row["cassius_fail_count"], 1)
        self.assertEqual(row["cassius_unavailable_count"], 1)
        self.assertEqual(row["cassius_unavailable_claim_supporting_count"], 1)


class BehaviorComparatorLaneTests(unittest.TestCase):
    def test_behavior_metrics_group_model_lanes_separately(self) -> None:
        common = {
            "condition": "civitas_6_7b_no_improvement",
            "unsafe_action": False,
            "unsupported_claim": False,
            "policy_violation": False,
            "contradiction_to_policy": False,
            "correct_control_action": True,
            "safe_fallback": True,
            "latency_ms": 0,
        }

        rows = aggregate_results.build_behavior_metrics(
            [
                {
                    **common,
                    "run_family": "local_reproducible",
                    "model_provider": "ollama",
                    "backend_kind": "local",
                    "model_id": "gemma4:e2b-it-q8_0",
                },
                {
                    **common,
                    "run_family": "api_portability",
                    "model_provider": "openai",
                    "backend_kind": "api",
                    "model_id": "frontier-configured-later",
                },
            ],
            [],
            [],
        )

        self.assertEqual(len(rows), 2)
        self.assertEqual(
            {(row["run_family"], row["backend_kind"], row["model_id"]) for row in rows},
            {
                ("local_reproducible", "local", "gemma4:e2b-it-q8_0"),
                ("api_portability", "api", "frontier-configured-later"),
            },
        )

    def test_disabled_api_lane_is_skip_not_behavior_metric(self) -> None:
        api_skip = {
            "condition": "civitas_6_7b_no_improvement",
            "run_family": "api_portability",
            "model_provider": "openai",
            "backend_kind": "api",
            "model_id": "frontier-configured-later",
            "api_backend_enabled": False,
            "api_backend_skip_reason": "missing_api_config",
            "unsafe_action": False,
            "unsupported_claim": False,
            "policy_violation": False,
            "contradiction_to_policy": False,
            "correct_control_action": True,
            "safe_fallback": True,
            "latency_ms": 0,
        }

        rows = aggregate_results.build_behavior_metrics([api_skip], [], [])

        self.assertEqual(rows[0]["task_count"], aggregate_results.NOT_AVAILABLE)
        self.assertEqual(aggregate_results.collect_api_skip_rows([api_skip]), [api_skip])


class FinalPaperTableTests(unittest.TestCase):
    def test_final_heldout_delta_bootstraps_paired_task_rows(self) -> None:
        rows = [
            {
                "task_id": "a",
                "condition": "civitas_6_5b_baseline",
                "correct_control_action": False,
                "unsafe_action": True,
                "unsupported_claim": False,
                "policy_violation": False,
                "contradiction_to_policy": False,
                "safe_fallback": False,
                "regression_flag": True,
                "latency_ms": 10,
            },
            {
                "task_id": "a",
                "condition": "civitas_6_7b_governed_improvement",
                "correct_control_action": True,
                "unsafe_action": False,
                "unsupported_claim": False,
                "policy_violation": False,
                "contradiction_to_policy": False,
                "safe_fallback": True,
                "regression_flag": False,
                "latency_ms": 12,
            },
        ]

        final_rows = aggregate_results.build_final_heldout_delta(rows)
        correct = next(row for row in final_rows if row["metric"] == "correct_control_action_rate")

        self.assertEqual(correct["paired_task_count"], 1)
        self.assertEqual(correct["absolute_delta"], "1.000000")
        self.assertEqual(correct["bootstrap_95_low"], "1.000000")


if __name__ == "__main__":
    unittest.main()
