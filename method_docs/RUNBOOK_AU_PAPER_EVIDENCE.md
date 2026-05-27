# AU Paper Evidence Runbook

## Scope

`RUN_AU_PAPER.sh` is the strict AU-only paper lane. It uses the frozen
`au_finance_paper_scope`, local Ollama execution, scoring audit artifacts,
Cassius evidence, sandbox promotion, sealed held-out/stress splits, result
aggregation, paper verification, and the readiness checker.

It is not the Prompt 9 smoke runner. It does not invoke API/frontier
comparators, EU tasks, production promotion, Aegis production mutation, or
Senate production calls.

## Required Environment

`repro/AU_PAPER_ENV.sh` is a committed non-secret source file for the selected
AU lane. Source it explicitly on a new box when inspecting or overriding the
defaults:

```bash
source paper_eval_6.7b/repro/AU_PAPER_ENV.sh
export MODEL_VERSION='<ollama model digest/tag recorded for this box>'
```

`RUN_AU_PAPER.sh` sources that file automatically unless
`AU_PAPER_ENV_FILE` points at another reviewed env source. The committed file
contains authority hashes and local decode defaults only. It contains no
secret and no API credential. Use the values frozen in
`policy_corpus_registry.yaml` and `AU_PAPER_SCOPE_BINDING.md`; do not invent
replacements.

The run box needs `cargo`, `python3`, `protoc`, `pkg-config`, the system
`fontconfig` development metadata, and Python `jsonschema` plus `PyYAML`
available before the AU setup checker will pass. On Debian-family boxes
`protoc` is provided by `protobuf-compiler` and fontconfig metadata is
provided by `libfontconfig1-dev`. The checker verifies those dependencies
before the long model path starts. Civitas vendors the ILK proto used by its
build script, so no separate SPQR proto checkout is needed.

## Command

Check the commit-and-run package before moving it or before starting a long
evidence job:

```bash
bash paper_eval_6.7b/repro/CHECK_AU_PAPER_SETUP.sh
```

On the Gemma VM, start Ollama, set the concrete model version, run the Ollama
preflight, and run:

```bash
source paper_eval_6.7b/repro/AU_PAPER_ENV.sh
export MODEL_VERSION='<ollama model digest/tag from this box>'
bash paper_eval_6.7b/repro/CHECK_AU_PAPER_SETUP.sh --require-ollama
bash paper_eval_6.7b/repro/RUN_AU_PAPER.sh au-paper-<run-id>
```

Verify an existing run directly with:

```bash
bash paper_eval_6.7b/repro/VERIFY_AU_PAPER_RESULTS.sh \
  paper_eval_6.7b/repro/runs/au-paper-<run-id>
```

## Fail-Closed Checks

The setup checker and runner fail on missing repo-local AU inputs, ignored
handoff files, missing validation dependencies, external Praxis/Aegis checkout
paths in the AU runner, placeholder `MODEL_VERSION`, missing Ollama model
tags, missing AU authority environment bindings, stub rows in paper result
artifacts, missing candidate/Cassius/trust/gate/sandbox artifacts,
placeholder task snapshots, non-sandbox promotions, Cassius-free or
trust-evidence-free sandbox approvals, skipped API rows inside paper results,
and missing final tables.

The runner exports a run-local `CARGO_TARGET_DIR` before invoking Cargo. That
prevents host-local Cargo target paths in the checkout from pointing a moved
paper run back at the source VM home directory. Set
`CIVITAS_67B_AU_PAPER_CARGO_TARGET_DIR` only when a reviewed VM-local build
cache path is required.

The run directory snapshots registry and task inputs before model execution.
It writes a run-local manifest and preserves raw rows, scored rows, scoring
audits, candidates, Cassius evidence, trust-region evidence, replay/canary
evidence, gate decisions, sandbox overlays, final tables, verifier result,
readiness reports, and the final QA report emitted by:

```bash
bash paper_eval_6.7b/repro/QA_AU_PAPER_EVIDENCE.sh \
  paper_eval_6.7b/repro/runs/au-paper-<run-id>
```

The larger Gemma run produces the paper result rows. This runbook and the
committed env/task/registry inputs are setup artifacts that can be moved to a
larger box before those result rows exist.
