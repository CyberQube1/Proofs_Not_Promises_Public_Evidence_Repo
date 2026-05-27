# Aggregation Runbook

## Scope

`scripts/aggregate_results.py` reads research JSONL artifacts from the
Civitas 6.7B paper-eval scaffold and writes paper-table CSV drafts plus a
Markdown results summary. It aggregates existing artifacts only. It does not
score new tasks, mutate sandbox state, promote candidates, or load production
config.

Smoke and placeholder artifacts are harness evidence. They are not final paper
evidence.

## Supported Inputs

The aggregator accepts repeatable inputs for:

- baseline result JSONL
- failure cluster JSONL
- improvement candidate JSONL
- governance gate result JSONL
- trust-region gate evidence JSONL
- post-sandbox replay/canary evidence JSONL
- sandbox promotion JSONL
- held-out result JSONL
- stress result JSONL

Input flags are optional so partial research runs can be summarized. Missing
paths and omitted optional inputs are recorded in `RESULTS_SUMMARY.md`; their
unavailable table cells stay `not_available`.

## Smoke Command

Run from the repository root:

```bash
python3 paper_eval_6.7b/scripts/aggregate_results.py \
  --baseline-results paper_eval_6.7b/results/baseline_smoke/civitas_6_5b_baseline.jsonl \
  --baseline-results paper_eval_6.7b/results/baseline_smoke/civitas_6_7b_no_improvement.jsonl \
  --failure-clusters /tmp/civitas-67b-prompt4a-train.clusters.jsonl \
  --candidates /tmp/civitas-67b-prompt5-train.candidates.jsonl \
  --gate-results /tmp/civitas-67b-prompt5-train.gate_results.jsonl \
  --sandbox-promotions /tmp/civitas-67b-prompt6-sandbox/sandbox_promotions.jsonl \
  --heldout-results /tmp/civitas-67b-prompt7-heldout.jsonl \
  --stress-results /tmp/civitas-67b-prompt7-stress.jsonl \
  --run-type smoke \
  --out-dir paper_eval_6.7b/results
```

## Outputs

The script writes:

- `results/tables/behavior_metrics.csv`
- `results/tables/candidate_lifecycle.csv`
- `results/tables/rejection_reasons.csv`
- `results/tables/governance_containment.csv`
- `results/tables/heldout_delta.csv`
- `results/tables/final_behavior_metrics.csv`
- `results/tables/final_heldout_delta.csv`
- `results/tables/final_governance_containment.csv`
- `results/tables/final_candidate_lifecycle.csv`
- `results/tables/final_stress_regression.csv`
- `results/RESULTS_SUMMARY.md`
- `results/FINAL_RESULTS_SUMMARY.md`

`results/figures/` is reserved for later paper figure exports.

## Metric Notes

- Behavior rates use the result-row count for the phase, condition, run-family,
  model-provider, backend-kind, and model-id group. Governed held-out and
  stress rows remain candidate-bound if Prompt 7 emitted one result row per
  applied sandbox candidate. Missing or skipped API lanes do not become failed
  behavior rows.
- Candidate lifecycle rates use generated candidate count where candidate JSONL
  is available.
- `heldout_delta.csv` compares Civitas 6.5B baseline rows to governed sandbox
  improvement rows inside the held-out result input.
- The Prompt 8 receipt completeness rate covers present receipt-bearing
  behavior, gate, and sandbox-promotion rows.
- Final behavior and stress rate tables carry 95% Wilson intervals. Final
  held-out deltas carry a fixed-seed 2,000-resample paired bootstrap interval
  over aligned task IDs. These intervals are uncertainty reporting, not a
  significance claim.
- Replay reproducibility remains `not_available` until replay/canary evidence
  includes replay rerun rows. The aggregator does not treat missing replay
  evidence as success.

## Focused Verification

Compile the script and run the smoke command:

```bash
python3 -m py_compile paper_eval_6.7b/scripts/aggregate_results.py
```
