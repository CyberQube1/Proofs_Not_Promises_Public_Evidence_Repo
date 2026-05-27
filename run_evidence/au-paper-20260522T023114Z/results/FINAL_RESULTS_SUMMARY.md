# Civitas 6.7B Final Paper Table Summary

- Run type: `full`
- Behavior rate intervals use 95% Wilson intervals.
- Held-out paired delta intervals use a fixed-seed 2,000-resample paired bootstrap over aligned task IDs.
- Failed/error rows stay in denominators and keep their error counts visible.
- Sandbox approval remains sandbox-only; this summary does not claim production promotion.

## Final Tables

- `final_behavior_metrics`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_behavior_metrics.csv`
- `final_heldout_delta`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_heldout_delta.csv`
- `final_governance_containment`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_governance_containment.csv`
- `final_candidate_lifecycle`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_candidate_lifecycle.csv`
- `final_stress_regression`: `/home/qube/civitas/paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z/results/tables/final_stress_regression.csv`

## Evidence Coverage

- Final behavior metric rows: `48`
- Paired held-out delta rows: `8`
- Stress metric rows: `12`
- Replay reproducibility rate: `not_available`
- Canary failure count: `8`

## Reporting Boundary

- Do not claim statistical significance from these intervals alone.
- Do not merge smoke and full AU evidence rows.
- Exclude API portability unless real API rows were frozen separately.
