# Civitas 6.7B AU Evidence-Bound Results

## Verdict

The selected evidence bundle is:

`paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z`

Final AU QA and paper readiness classify it as `paper_evidence_ready`. The
bundle is the evidence source for the current result narrative; smoke and stub
rows are not paper evidence.

## Scope Lock

- Scope is AU finance only.
- Task rows are curated AU rows: 100 training failure rows, 100 held-out rows,
  and 50 stress rows.
- The executed paper lane is local Ollama/Gemma only.
- ASIC and APRA remain baseline-contained source subsets in this lane.
- API portability, EU results, production promotion, replay reproducibility,
  and statistical significance are not claims from this bundle.

## Strongest Supported Result

Civitas 6.7B is strongest here as a governed self-improvement containment
system. The final containment table reports:

| Signal | Locked value |
| --- | ---: |
| Production mutation count | 0 |
| Unauthorized promotion count | 0 |
| Sandbox-only promotion count | 8 |
| Cassius required count | 8 |
| Cassius pass count | 8 |
| Cassius unavailable claim-supporting count | 0 |
| Receipt completeness rate | 1.000000 |
| Replay reproducibility rate | `not_available` |

These values support sandbox-contained candidate handling with archived
Cassius, gate, trust-region, sandbox, QA, and readiness surfaces. They do not
support production self-modification.

## Selected Behavioral Support

The held-out delta table gives narrow risk-reduction support against the
Civitas 6.5B held-out baseline:

| Metric | Baseline | Governed |
| --- | ---: | ---: |
| `unsupported_claim_rate` | 0.110000 | 0.057500 |
| `policy_violation_rate` | 0.030000 | 0.017500 |
| `contradiction_to_policy_rate` | 0.010000 | 0.000000 |
| `unsafe_action_rate` | 0.020000 | 0.017500 |

Governed stress rows also report `unsafe_action_rate = 0.000000`,
`policy_violation_rate = 0.000000`, and
`contradiction_to_policy_rate = 0.000000`.

## Mixed Result That Must Stay Visible

The behavioral claim is mixed rather than globally positive:

| Metric | Comparator | Governed |
| --- | ---: | ---: |
| Held-out `correct_control_action_rate` | 0.050000 | 0.042500 |
| Held-out `regression_rate` | 0.950000 | 0.957500 |
| Stress `regression_rate` | 0.880000 baseline/no-improvement | 0.907500 |

The lifecycle table also shows 8 candidates generated, 8 approved for sandbox,
and 0 rejected. That preserves the archived governed path but leaves gate
selectivity unproven in this bundle.

## Paper Interpretation

The paper should present this result as yellow-green. It can argue that a
governed candidate loop remained auditable and contained while reducing
selected AU held-out risk metrics. It should not claim broad behavioral
superiority, a pure benchmark win, live production promotion, API portability,
EU generalization, replay reproducibility, or statistical significance.
