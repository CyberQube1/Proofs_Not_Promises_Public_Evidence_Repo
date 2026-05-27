# Baseline Runbook

## Scope

Prompt 2 adds the first runnable baseline-only research path for:

- `civitas_6_5b_baseline`
- `civitas_6_7b_no_improvement`

This path reads Prompt 1 JSONL task rows and exports comparable JSONL result
rows. It does not generate candidates, enable improvement, promote anything, or
mutate production state.

The smoke adapter remains intentionally narrow and records deterministic
research stub decisions with `model_backend=deterministic_baseline_stub`.
`--execution-mode real_local` uses the local Ollama inference surface for raw
AU paper rows and records `model_backend=ollama_real_local`. Do not treat stub
rows or unscored raw real-local rows as final benchmark evidence.

Prompt 11 adds metadata flags for backend comparator lanes. Gemma/Ollama is the
primary real-run lane. API/frontier metadata can be recorded as a skipped
secondary lane without enabling API calls in this adapter.

## Build And Focused Test

Run from the repository root:

```bash
cd civitas_V.6.7
cargo build --bin civitas-67b-eval
cargo test --bin civitas-67b-eval
```

These focused commands cover the Prompt 2 runner. A full crate-wide
`cargo test` run is not part of the baseline smoke loop.

## Direct CLI

Run one baseline condition over the three placeholder training rows:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  baseline \
  --tasks ../paper_eval_6.7b/tasks/train_failures_100.jsonl \
  --condition civitas_6_7b_no_improvement \
  --run-id baseline-smoke-civitas-6-7b-no-improvement \
  --timestamp 2026-05-21T00:00:00Z \
  --output ../paper_eval_6.7b/results/baseline_smoke/civitas_6_7b_no_improvement.jsonl
```

Supported conditions are exactly:

- `civitas_6_5b_baseline`
- `civitas_6_7b_no_improvement`

`--timestamp` is optional. Supplying an RFC 3339 timestamp keeps smoke output
stable across reruns.

For a local Gemma/Ollama metadata-bound run, add flags like:

```bash
  --model-provider ollama \
  --backend-kind local \
  --model-id gemma4:e2b-it-q8_0 \
  --run-family local_reproducible \
  --model-version not_loaded \
  --temperature 0 \
  --max-tokens 2048 \
  --seed ollama-seed-configured-separately \
  --deterministic-mode true
```

Use those metadata flags with `--execution-mode real_local` for the local
Ollama adapter. The focused real-local command and health checks live in
`paper_eval_6.7b/docs/RUNBOOK_REAL_LOCAL_EXECUTION.md`.

An unavailable API comparator is explicit rather than a failure of the local
lane:

```bash
  --model-provider openai \
  --backend-kind api \
  --model-id frontier-model-configured-later \
  --run-family api_portability \
  --api-backend-skip-reason missing_api_config \
  --deterministic-mode false
```

That command shape records a metadata-bearing skipped API lane with
`api_backend_enabled=false`. This runner does not make API calls; passing
`--api-backend-enabled` fails closed until an API execution adapter is wired.
Do not report API portability from skipped rows.

## Two-Condition Smoke

Run both baseline conditions from the repository root:

```bash
bash paper_eval_6.7b/scripts/run_baseline_eval.sh
```

The script defaults to:

- Input: `paper_eval_6.7b/tasks/train_failures_100.jsonl`
- Output directory: `paper_eval_6.7b/results/baseline_smoke/`

Override the task file and output directory with positional arguments:

```bash
bash paper_eval_6.7b/scripts/run_baseline_eval.sh \
  paper_eval_6.7b/tasks/stress_50.jsonl \
  /tmp/civitas-67b-baseline-stress
```

## Result Row Shape

Each exported JSONL result row contains:

- `run_id`
- `timestamp`
- `condition`
- `task_id`
- `task_bucket`
- `jurisdiction`
- `policy_corpus_id`
- `active_law_hash`
- `model_backend`
- `model_provider`
- `backend_kind`
- `model_id`
- `model_version`
- `run_family`
- `api_backend_enabled`
- `api_backend_skip_reason`
- `temperature`
- `max_tokens`
- `seed`
- `deterministic_mode`
- `config_hash`
- `prompt_hash`
- `response_or_decision`
- `expected_control_action`
- `observed_control_action`
- `split`
- `unsafe_action`
- `unsupported_claim`
- `policy_violation`
- `contradiction_to_policy`
- `correct_control_action`
- `evidence_supported`
- `safe_fallback`
- `latency_ms`
- `receipt_hashes`
- `notes`

The stub adapter sets `latency_ms` to `0`, computes deterministic SHA3-256
config/prompt/receipt hashes, and marks the notes field as research-only stub
output. The real-local adapter preserves this row shape with real latency,
actual model response text, parsed control action, and separate local receipt
hash material. The machine-readable row contract is
`paper_eval_6.7b/schemas/baseline_result.schema.json`.
