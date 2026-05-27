# AU Paper Evidence New-Box Handoff

## Boundary

The AU paper-evidence setup is committed in this repository. The larger Gemma
box is for producing paper result rows and the verified evidence bundle. It is
not required to rediscover Praxis/Aegis refs or to copy local Praxis policy
storage into the run box.

The paper lane stays:

> Australian finance baseline only, with APRA and ASIC source subsets contained
> inside the frozen Praxis `baseline-au-finance` lane.

## Committed Run Inputs

The new box uses repo-local inputs:

- `paper_eval_6.7b/repro/AU_PAPER_ENV.sh`
- `paper_eval_6.7b/policy_corpora/policy_corpus_registry.yaml`
- `paper_eval_6.7b/policy_corpora/AU_PAPER_SCOPE_BINDING.md`
- `paper_eval_6.7b/tasks/au_finance_v1/train_failures_100.jsonl`
- `paper_eval_6.7b/tasks/au_finance_v1/heldout_eval_100.jsonl`
- `paper_eval_6.7b/tasks/au_finance_v1/stress_50.jsonl`
- `paper_eval_6.7b/repro/CHECK_AU_PAPER_SETUP.sh`
- `paper_eval_6.7b/repro/RUN_AU_PAPER.sh`
- `paper_eval_6.7b/repro/VERIFY_AU_PAPER_RESULTS.sh`
- `paper_eval_6.7b/repro/QA_AU_PAPER_EVIDENCE.sh`

`AU_PAPER_ENV.sh` is intentionally committed. It contains non-secret selected
AU authority hashes and local Ollama defaults. Override `MODEL_VERSION` on the
new box with the model digest/tag actually used there.

## New Box Requirements

- this Civitas checkout at the intended commit
- Rust/Cargo for `civitas_V.6.7`
- `protoc` / Debian package `protobuf-compiler` for the vendored ILK proto build
- `pkg-config` and Debian package `libfontconfig1-dev` for the Rust
  fontconfig build dependency pulled by plotting crates in the Civitas build
- Python 3 for scoring, aggregation, readiness, and evidence exporters
- Python validation packages `jsonschema` and `PyYAML`
- Ollama running locally
- local `gemma4:e2b-it-q8_0` model, or an explicitly reviewed replacement
- sufficient compute for the AU real-local calls

The current AU runner does not read live files under
`/home/spqr-admin/praxis-admin/` or `/home/spqr-admin/aegis-kernel/`. Praxis
and Aegis refs in the registry are frozen authority/provenance refs for the
taskset and manifest.

## Run Commands

After pulling the commit, verify the repo-only handoff package first:

```bash
bash paper_eval_6.7b/repro/CHECK_AU_PAPER_SETUP.sh
```

Then start Ollama, freeze the model version for that VM, check the run
environment, and start the paper job:

```bash
source paper_eval_6.7b/repro/AU_PAPER_ENV.sh
export MODEL_VERSION='<ollama model digest/tag from this box>'
bash paper_eval_6.7b/repro/CHECK_AU_PAPER_SETUP.sh --require-ollama
bash paper_eval_6.7b/repro/RUN_AU_PAPER.sh au-paper-<run-id>
bash paper_eval_6.7b/repro/QA_AU_PAPER_EVIDENCE.sh \
  paper_eval_6.7b/repro/runs/au-paper-<run-id>
```

`RUN_AU_PAPER.sh` reruns the strict setup check before it spends time on the
full Gemma matrix. It refuses the committed placeholder `MODEL_VERSION`; set
that value to the actual Ollama model digest/tag from the evidence VM first.
It also forces a run-local `CARGO_TARGET_DIR` so a host-local Cargo config from
the source VM cannot redirect builds into another user's home directory.
The Civitas crates now vendor the ILK proto used by their build scripts; the
run box does not need a separate `$HOME/spqr/ilk/proto` checkout.

## What The Large Gemma Run Produces

The real AU run creates paper result evidence:

- non-stub Civitas 6.5B comparator rows
- non-stub Civitas 6.7B no-improvement rows
- train-only failure clusters and improvement candidates
- Cassius and trust-region evidence
- sandbox gate decisions and sandbox overlays
- held-out/stress sandbox result rows
- replay/canary evidence summaries
- final tables, manifest, verifier output, readiness report, and QA report

The setup is complete before those artifacts exist. The paper-evidence verdict
is not complete until the larger box run produces and verifies them.
