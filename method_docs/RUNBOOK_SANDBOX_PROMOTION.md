# Sandbox Promotion Runbook

## Scope

The `sandbox_promote` phase consumes Prompt 4 candidate JSONL and Prompt 5
governance gate results. It writes isolated sandbox artifacts only for
candidates that were explicitly approved for sandbox use.

Promotion in this runbook means a sandbox overlay simulation. It does not edit
live config, active law, policy graphs, trust-region config, Aegis state, or
Senate state.

## Inputs

Use:

- candidate JSONL from `candidate_generation`
- gate result JSONL from `governance_gate`
- a readable baseline config file to hash
- an isolated sandbox output directory
- optional deterministic `--timestamp`

The output directory defaults to
`paper_eval_6.7b/artifacts/sandbox_promotions/` when the command is run from
the active Rust crate.

## Direct CLI

Run from the active Rust crate:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  sandbox_promote \
  --candidates /tmp/civitas-67b-prompt5-train.candidates.jsonl \
  --gate-results /tmp/civitas-67b-prompt5-train.gate_results.jsonl \
  --baseline-config Cargo.toml \
  --sandbox-output-dir ../paper_eval_6.7b/artifacts/sandbox_promotions/smoke \
  --timestamp 2026-05-21T00:00:00Z
```

The simulator writes:

- `sandbox_state.json`
- `sandbox_promotions.jsonl`
- `overlays/sandbox_overlay_<candidate-hash-prefix>.json` for each applied
  candidate

Use `--dry-run` to calculate the promotion rows and path checks without
writing those files.

## Application Rules

The simulator matches candidate rows to gate result rows by `candidate_hash`.
It applies only candidates where:

- gate status is `approved_for_sandbox`
- reason codes include `approved_for_sandbox_only`
- candidate and gate provenance are claim-supporting
- candidate and gate source split are `train_failures`

Rejected, blocked, needs-more-evidence, held-out, stress, non-claim-supporting,
and missing-gate rows emit `skipped_rejected` promotion records. A gate binding
conflict inside one sandbox run emits `failed_to_apply`.

## Overlay Contract

The simulator does not mutate a real runtime config. Every approved candidate
becomes a structured sandbox overlay with:

- candidate id, hash, type, and proposed change summary
- the candidate `proposed_delta`
- gate result id and receipt hash
- active-law, policy-graph, and trust-region hash bindings from the gate result
- sandbox marker
- `production_mutation=false`

`sandbox_state.json` records the baseline config hash, applied candidate hashes
and summaries, embedded overlays, gate hash bindings, sandbox marker, and
`production_mutation=false`.

The promotion row contract is
`paper_eval_6.7b/schemas/sandbox_promotion.schema.json`.

## Path Safety

Before any sandbox artifact write, the simulator checks the output directory
and every planned artifact path. It refuses production-looking output paths
including paths with `config/`, `src/`, `/etc/`, or `/var/` components. Output
filenames are fixed inside the requested sandbox directory; the phase never
writes to the baseline config path.

## Focused Verification

Use the binary-only tests while iterating:

```bash
cd civitas_V.6.7
cargo test --bin civitas-67b-eval
```
