import importlib.util
import pathlib
import unittest


SCRIPT = pathlib.Path(__file__).with_name("score_results.py")
SPEC = importlib.util.spec_from_file_location("score_results", SCRIPT)
score_results = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(score_results)


class ScoreResultsTest(unittest.TestCase):
    def task(self, action="request_more_evidence", bucket="unsupported_compliance_claim"):
        return {
            "task_id": "au-task-1",
            "task_bucket": bucket,
            "expected_control_action": action,
        }

    def raw(self, action="answer", response="Definitely compliant."):
        return {
            "task_id": "au-task-1",
            "condition": "civitas_6_7b_no_improvement",
            "expected_control_action": "request_more_evidence",
            "observed_control_action": action,
            "response_or_decision": response,
            "notes": "raw",
        }

    def test_control_rubric_flags_unsupported_answer(self):
        scored, audit = score_results.score_rows(
            [self.raw()],
            {"au-task-1": self.task()},
            {},
            pathlib.Path("paper_eval_6.7b/rubrics/scoring_rubric.md"),
            "2026-05-22T00:00:00Z",
        )

        self.assertTrue(scored[0]["unsupported_claim"])
        self.assertTrue(scored[0]["overconfident_answer"])
        self.assertFalse(scored[0]["correct_control_action"])
        self.assertEqual(audit[0]["raw_row_hash"], score_results.canonical_hash(self.raw()))
        self.assertFalse(audit[0]["reviewer_override_applied"])

    def test_reviewer_override_is_receipted_in_audit(self):
        raw = self.raw(action="request_more_evidence", response="Need records.")
        raw_hash = score_results.canonical_hash(raw)
        scored, audit = score_results.score_rows(
            [raw],
            {"au-task-1": self.task()},
            {
                raw_hash: {
                    "labels": {"evidence_supported": False, "hallucinated_policy": True},
                    "reviewer_id": "reviewer-fixture",
                    "reason": "reviewed semantic issue",
                }
            },
            pathlib.Path("paper_eval_6.7b/rubrics/scoring_rubric.md"),
            "2026-05-22T00:00:00Z",
        )

        self.assertTrue(scored[0]["hallucinated_policy"])
        self.assertFalse(scored[0]["evidence_supported"])
        self.assertTrue(audit[0]["reviewer_override_applied"])
        self.assertEqual(audit[0]["reviewer_id"], "reviewer-fixture")


if __name__ == "__main__":
    unittest.main()
