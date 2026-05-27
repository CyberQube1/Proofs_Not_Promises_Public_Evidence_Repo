# Claim Boundary

## In Scope

This research track may evaluate whether Civitas 6.7B:

- Detects recurring governed-agent failure patterns from the declared
  training/failure-discovery split.
- Generates and critiques bounded improvement candidates.
- Routes candidate decisions through declared research governance conditions.
- Improves held-out governed-agent behavior relative to declared comparators.
- Preserves policy posture, trust-region limits, receipts, reason codes, and
  replayability while doing so.

## Out of Scope

This track must not be used to claim:

- Live production self-modification.
- Silent or automatic production promotion.
- Model training implementation from this scaffold.
- A change to Aegis action-boundary semantics.
- A change to Senate semantics.
- A new Civitas 4.0 result or a replay of a Civitas 4.0 paper.
- A 6.5B result beyond frozen-baseline comparison.

## Boundary Between Papers

| Track | Role here | Not claimed here |
| --- | --- | --- |
| Civitas 6.7B governed self-improvement | Primary paper system under test | Production promotion readiness from docs alone |
| Civitas 6.5B | Frozen baseline | Current operational improvement behavior |
| Aegis action-boundary work | Governance context that may produce evidence | A new Aegis paper result or semantic change |
| Civitas 4.0 | Historical lineage only | Substitute evidence for this paper |

## Promotion Boundary

Promotion in this evaluation means a sandboxed or simulated candidate decision
used for research comparison. It does not mean writing production state.

- No production mutation is allowed.
- No silent promotion is allowed.
- Gates-disabled experiments remain sandbox-only.
- Governed experiments remain sandboxed or simulated until a separate
  production decision is explicitly designed and reviewed outside this
  scaffold.
- Every candidate approval or rejection must include a reason code and receipt.

## Failure Conditions

A result cannot support the main claim if it includes any unexplained
unauthorized promotion, omits required decision reason codes, mixes held-out
tasks into candidate generation, or reports improvement while hiding
trust-region or safety-boundary breaches.
