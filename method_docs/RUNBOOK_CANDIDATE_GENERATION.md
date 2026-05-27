# Candidate Generation Runbook

## Scope

The `candidate_generation` phase exports research-only improvement candidate
records from Prompt 3 failure cluster JSONL. Every row is bound to one source
cluster plus the declared pre-candidate config, active-law, and policy-graph
hashes.

The phase does not edit config, mutate production state, call promotion paths,
or treat a candidate as gate-approved. The initial adapter exports candidate
records only.

## Input Contract

Use:

- A non-empty failure cluster JSONL file emitted by `failure_discovery`.
- `--current-config-hash` for the configuration before candidate evaluation.
- `--active-law-hash` for the active law snapshot bound to generation.
- `--policy-graph-hash` for the active policy graph bound to generation.
- Gate-ready provenance such as `--generation-run-id`,
  `--generation-condition`, and `--trust-region-hash` when already loaded.

The runner rejects a cluster row if its `cluster_hash` no longer matches the
canonical cluster content. That keeps candidate evidence traceable back to the
failure-discovery artifact.

By default only clusters with `source_split=train_failures` reach candidate
export. A research debugging run may pass `--allow-non-train-split`; those
candidate rows are visibly marked `claim_supporting_run=false`.

## Direct CLI

Run from the active Rust crate:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  candidate_generation \
  --clusters ../paper_eval_6.7b/artifacts/failure_clusters/baseline_smoke.clusters.jsonl \
  --current-config-hash placeholder-config-before-hash \
  --active-law-hash placeholder-active-law-hash \
  --policy-graph-hash placeholder-policy-graph-hash \
  --trust-region-hash not_loaded \
  --generation-run-id baseline-smoke-candidate-generation \
  --generation-condition civitas_6_7b_no_improvement \
  --timestamp 2026-05-21T00:00:00Z \
  --output ../paper_eval_6.7b/artifacts/candidates/baseline_smoke.candidates.jsonl
```

Supply `--timestamp` when a byte-stable smoke export is needed. Without it the
candidate row records the current UTC generation time.

## Output Contract

The candidate row schema is
`paper_eval_6.7b/schemas/improvement_candidate.schema.json`.

Each JSONL row contains:

- `candidate_id`
- `candidate_hash`
- `source_cluster_id`
- `source_cluster_hash`
- `source_split`
- `candidate_type`
- `proposed_change_summary`
- `proposed_delta`
- `expected_benefit`
- `possible_risks`
- `evidence_refs`
- `policy_refs`
- `active_law_hash`
- `policy_graph_hash`
- `trust_region_hash`
- `config_hash_before`
- `generation_run_id`
- `generation_condition`
- `gate_boundary_context`
- `claim_supporting_run`
- `generated_by`
- `generated_at`
- `status`
- `notes`

The first adapter emits `status=generated`. `candidate_hash` is a SHA3-256
digest over canonical candidate content excluding the `candidate_hash` field.
Candidate ids bind the source cluster hash, candidate type, config hash, active
law hash, and policy graph hash.

## Current Mapping

Failure clusters currently map to bounded candidate types as follows:

| Failure cluster type | Candidate type |
| --- | --- |
| `unsafe_action` | `routing_policy_adjustment` |
| `repeat_failure_pattern` | `routing_policy_adjustment` |
| `unsupported_claim` | `evidence_gate_tightening` |
| `evidence_gap` | `evidence_gate_tightening` |
| `incorrect_escalation` | `escalation_policy_adjustment` |
| `incorrect_refusal` | `refusal_policy_adjustment` |
| `policy_violation` | `prompt_composer_constraint` |
| `contradiction_to_policy` | `prompt_composer_constraint` |
| `overconfident_answer` | `prompt_composer_constraint` |
| `hallucinated_policy` | `prompt_composer_constraint` |

The schema also reserves `model_pack_selection_rule`,
`trust_region_parameter_candidate`, and `other` for later research adapters.

## Focused Verification

Use the binary-focused tests while iterating on this phase:

```bash
cd civitas_V.6.7
cargo test --bin civitas-67b-eval
```

The Prompt 4 test checks deterministic candidate ids and candidate hashes from a
failure cluster export.
