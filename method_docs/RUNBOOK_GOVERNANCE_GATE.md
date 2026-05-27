# Governance Gate Runbook

## Scope

The `governance_gate` phase evaluates Prompt 4 candidate JSONL records through
a deterministic Prompt 5 research adapter. It exports one inspectable gate
result per candidate.

This phase does not edit config, promote a candidate, call a production
promotion path, or perform sandbox application. An approval is
`approved_for_sandbox` only.

Cassius is mandatory for a claim-supporting governed-improvement gate row.
`cassius_evidence` invokes the non-mutating Cassius reasoning-chain evaluator
against candidate-bound sandbox intervention material and exports receipt-bound
challenge evidence. The gate loads those rows by candidate hash and fails
closed when claim-supporting candidates lack them. External Aegis/Senate
review and production promotion remain outside this phase.

## Input Contract

Use:

- A candidate JSONL file emitted by `candidate_generation`.
- `--active-law-hash` bound to the research gate run.
- `--policy-graph-hash` bound to the research gate run.
- `--trust-region-hash` bound to the research gate run.
- `--trust-region-evidence` JSONL for candidate-bound AU paper trust review.
- `--cassius-challenge-evidence` JSONL for any claim-supporting run.
- Optional `--canary-replay-result` evidence path.

The current adapter accepts train-derived, claim-supporting generated candidate
types. It rejects or blocks candidates when source split, claim-supporting
provenance, evidence, active-law binding, policy-graph binding, or trust-region
binding do not satisfy the research gate.

Generate candidate-bound Cassius evidence first:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  cassius_evidence \
  --candidates ../paper_eval_6.7b/artifacts/candidates/au-paper.candidates.jsonl \
  --artifact-ref candidates:au-paper.candidates.jsonl \
  --timestamp 2026-05-22T00:00:00Z \
  --output ../paper_eval_6.7b/artifacts/cassius/au-paper.cassius.jsonl
```

Each loaded Cassius evidence row carries the candidate hash, `passed` or
`failed` Cassius state, a real Cassius receipt hash, challenge id, input/output
hashes, summary, and source:

```json
{"candidate_hash":"<sha3-256>","cassius_state":"passed","cassius_receipt_hash":"<receipt-sha3-256>","cassius_challenge_id":"<id>","cassius_reason_codes":["<reason-code>"],"cassius_summary":"<summary>","cassius_source":"loaded_artifact"}
```

`cassius_source` is `live_invocation` for the in-process evaluator and may be
`loaded_artifact` for externally produced receipt-bound evidence. Do not
manufacture a pass or receipt hash for a paper run.

Generate candidate-bound trust-region evidence beside Cassius evidence:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  trust_region_evidence \
  --candidates ../paper_eval_6.7b/artifacts/candidates/au-paper.candidates.jsonl \
  --trust-region-hash "${TRUST_REGION_HASH}" \
  --timestamp 2026-05-22T00:00:00Z \
  --output ../paper_eval_6.7b/artifacts/trust_region/au-paper.trust.jsonl
```

That evidence binds the candidate delta hash and active trust-region hash. The
gate records `trust_region_check.state=evidence_passed` for a passed loaded
row, blocks a recorded breach, and asks for evidence if a gate run requires a
candidate row that was not loaded.

An optional canary/replay file is hashed and retained as
`replay_check.state=provided_unchecked`. This adapter does not parse production
replay or canary semantics.

## Direct CLI

Run from the active Rust crate:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  governance_gate \
  --candidates ../paper_eval_6.7b/artifacts/candidates/baseline_smoke.candidates.jsonl \
  --active-law-hash active-law-sha3-loaded-for-smoke \
  --policy-graph-hash policy-graph-sha3-loaded-for-smoke \
  --trust-region-hash trust-region-sha3-loaded-for-smoke \
  --trust-region-evidence ../paper_eval_6.7b/artifacts/trust_region/gate_trust.jsonl \
  --cassius-challenge-evidence ../paper_eval_6.7b/artifacts/cassius/gate_challenges.jsonl \
  --timestamp 2026-05-21T00:00:00Z \
  --output ../paper_eval_6.7b/artifacts/gate_results/baseline_smoke.gate_results.jsonl
```

Supply `--timestamp` when byte-stable gate receipt hashes are required.
For smoke/debug only, use `--cassius-not-required`. That option makes Cassius
`not_required`, sets gate rows non-claim-supporting, and cannot produce a
sandbox approval.

## Gate Result Contract

The row schema is
`paper_eval_6.7b/schemas/governance_gate_result.schema.json`.

Each row contains:

- candidate identity and `gate_result_id`
- sandbox gate status plus reason codes
- explicit Cassius required/state/receipt/challenge/source fields
- trust-region, policy, replay, and Senate/Aegis check summaries
- required and missing evidence flags
- active-law, trust-region, and policy-graph gate bindings
- source split and claim-support provenance
- deterministic gate timestamp and receipt hash

The adapter currently emits:

- `approved_for_sandbox` only when train split, claim-support, supported
  candidate type, required candidate evidence, bound gate hashes, and a passed
  receipt-bound Cassius challenge pass.
- `needs_more_evidence` for missing candidate evidence or unavailable
  Cassius evidence, active-law, policy-graph, or trust-region hashes.
- `blocked_by_policy` for active-law or policy-graph binding conflicts.
- `blocked_by_trust_region` for a candidate trust-region provenance conflict.
- `rejected` for non-claim-supporting or unsupported candidate inputs.

`senate_or_aegis_check` remains `unavailable` in this phase. Every sandbox
approval carries `approved_for_sandbox_only`.

## Reason Codes

The schema reserves the Prompt 5 reason-code set:

- `insufficient_evidence`
- `policy_conflict`
- `trust_region_breach`
- `unsafe_drift`
- `replay_regression`
- `canary_failure`
- `senate_quorum_missing`
- `aegis_denied`
- `unsupported_candidate_type`
- `approved_for_sandbox_only`
- `non_claim_supporting_input`
- `missing_active_law_hash`
- `missing_policy_graph_hash`
- `missing_trust_region_hash`
- `cassius_challenge_unavailable`
- `cassius_challenge_failed`

The narrow adapter emits the codes it can prove from candidate provenance and
gate-time hash bindings. A Cassius failure rejects the candidate. Unavailable
Cassius challenge evidence demotes the gate row out of claim support and
prevents approval. Later phases must not backfill unavailable external evidence
as if the gate had observed it.

## Focused Verification

Use the binary-focused gate tests while iterating:

```bash
cd civitas_V.6.7
cargo test --bin civitas-67b-eval
```
