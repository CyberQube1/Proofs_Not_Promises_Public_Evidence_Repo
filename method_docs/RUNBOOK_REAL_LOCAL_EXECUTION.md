# Real Local Execution Runbook

## Scope

`civitas-67b-eval` keeps `--execution-mode stub` for deterministic smoke
artifacts and adds `--execution-mode real_local` for AU paper rows backed by
local Ollama inference. The real-local path is still sandbox-only: it records
raw responses and control actions without mutating production config, active
law, trust-region state, Aegis state, or Senate state.

Raw real-local rows are not final scored evidence by themselves. They keep
pre-scoring safety-label defaults and must go through the scoring/adjudication
path before paper metrics are aggregated.

## Ollama Health Check

Run these checks before a pilot or full AU paper run:

```bash
ollama --version
ollama list
curl http://localhost:11434/api/tags
ollama run gemma4:e2b-it-q8_0 "Reply with exactly: Civitas local inference online."
```

The primary local lane uses `gemma4:e2b-it-q8_0`. The documented fallback tag
is `gemma3n:e2b`; the eval runner records that fallback but does not silently
switch to it.

## Real Baseline CLI

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  baseline \
  --execution-mode real_local \
  --ollama-host http://localhost:11434 \
  --timeout-seconds 120 \
  --tasks ../paper_eval_6.7b/tasks/au_finance_v1/train_failures_100.jsonl \
  --condition civitas_6_7b_no_improvement \
  --run-id au-real-train-67b-no-improvement \
  --model-provider ollama \
  --backend-kind local \
  --model-id gemma4:e2b-it-q8_0 \
  --model-version local-tag-recorded-by-run \
  --run-family local_reproducible \
  --temperature 0 \
  --max-tokens 512 \
  --seed ollama-seed-unavailable \
  --deterministic-mode false \
  --output ../paper_eval_6.7b/results/au_real/train_67b_no_improvement.raw.jsonl
```

Switch `--condition` to `civitas_6_5b_baseline` for the frozen comparator
condition. Baseline real-local inference fails loudly if a row cannot be
executed or its JSON control action cannot be parsed.

## Real Held-Out And Stress CLI

Use Prompt 6 sandbox state for governed-improvement rows:

```bash
cd civitas_V.6.7
cargo run --bin civitas-67b-eval -- \
  heldout_eval \
  --execution-mode real_local \
  --tasks ../paper_eval_6.7b/tasks/au_finance_v1/heldout_eval_100.jsonl \
  --sandbox-state ../paper_eval_6.7b/artifacts/sandbox_promotions/au-paper/sandbox_state.json \
  --run-id au-real-heldout \
  --model-provider ollama \
  --backend-kind local \
  --model-id gemma4:e2b-it-q8_0 \
  --model-version local-tag-recorded-by-run \
  --run-family local_reproducible \
  --temperature 0 \
  --max-tokens 512 \
  --seed ollama-seed-unavailable \
  --deterministic-mode false \
  --output ../paper_eval_6.7b/results/au_real/heldout.raw.jsonl
```

Use the same model flags with `stress_eval` and the stress task file for the
stress lane. Held-out and stress execution retain per-task error rows instead
of dropping failures.

## Recorded Boundary

Real-local rows record:

- `model_backend=ollama_real_local`
- provider/backend/run-family/model metadata
- prompt, config, and receipt hashes
- actual local-model response text
- parsed `observed_control_action`
- latency in milliseconds
- sandbox state path and candidate hash on governed held-out/stress rows

Stub rows keep `model_backend=deterministic_baseline_stub`. Paper-mode
verification must exclude those rows from claim-supporting evidence.
