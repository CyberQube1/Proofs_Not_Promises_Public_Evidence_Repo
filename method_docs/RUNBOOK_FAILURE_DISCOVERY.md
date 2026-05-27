# Failure Discovery Runbook

## Scope

The `failure_discovery` phase turns scored baseline result rows and their task
rows into inspectable train-split failure clusters. It is the detection phase
for the Civitas 6.7B governed self-improvement paper path.

This phase does not generate improvement candidates, modify runtime behavior,
call promotion paths, or mutate production state.

## Input Contract

Use:

- A baseline result JSONL file with the Prompt 2 result fields and scoring
  labels.
- The task JSONL file that contains every `task_id` referenced by the result
  JSONL.

The current deterministic baseline stub emits clean placeholder rows. Failure
clusters appear only when scored result labels expose failure evidence, such as
`unsupported_claim=true`, `evidence_supported=false`, or an incorrect
escalation/refusal control action.

By default the task JSONL must contain only `split=train_failures` rows.
Held-out and stress rows are rejected before clustering. A research debugging
run may pass `--allow-non-train-split`, but emitted clusters are then marked
`claim_supporting_run=false` and must not support paper claims.

## Direct CLI

Run from the active Rust crate:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  failure_discovery \
  --results ../paper_eval_6.7b/results/baseline_smoke/civitas_6_7b_no_improvement.jsonl \
  --tasks ../paper_eval_6.7b/tasks/train_failures_100.jsonl \
  --clusters ../paper_eval_6.7b/artifacts/failure_clusters/baseline_smoke.clusters.jsonl \
  --summary ../paper_eval_6.7b/artifacts/failure_clusters/baseline_smoke.summary.md
```

## Output Contract

Each failure cluster JSONL row contains:

- `cluster_id`
- `failure_type`
- `task_ids`
- `task_buckets`
- `policy_corpus_id`
- `source_split`
- `claim_supporting_run`
- `recurring_pattern_summary`
- `observed_failure_count`
- `severity`
- `evidence_refs`
- `representative_examples`
- `suggested_improvement_target`
- `cluster_hash`

The Markdown summary records source paths, row and cluster counts, and a compact
table for review. Cluster ids are stable for a failure type and policy-corpus
pair. Cluster hashes are SHA3-256 digests over canonical cluster content
excluding the `cluster_hash` field.
The machine-readable row contract is
`paper_eval_6.7b/schemas/failure_cluster.schema.json`.

## Supported Failure Types

The first deterministic grouping pass recognizes:

- `unsafe_action`
- `unsupported_claim`
- `policy_violation`
- `contradiction_to_policy`
- `incorrect_escalation`
- `incorrect_refusal`
- `evidence_gap`
- `overconfident_answer`
- `hallucinated_policy`
- `repeat_failure_pattern`

Optional scored labels may carry `correct_escalation`, `correct_refusal`,
`overconfident_answer`, or `hallucinated_policy`. Baseline Prompt 2 rows remain
valid without those optional labels.

## Focused Verification

Use the binary-focused tests while iterating on this phase:

```bash
cd civitas_V.6.7
cargo test --bin civitas-67b-eval
```

Those tests cover direct claim/evidence grouping and incorrect escalation plus
repeat-pattern clustering. They do not exercise candidate generation or any
production governance surface.
