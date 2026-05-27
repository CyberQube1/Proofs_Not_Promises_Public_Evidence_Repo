# Civitas 6.7B AU Paper Run Setup Report

- Setup status: `au_paper_run_env_ready`
- Checked at: `2026-05-22T02:31:19Z`
- Require run env: `True`
- Require Ollama: `True`

This report verifies the commit-and-run AU paper-evidence package. It does not run the full Gemma matrix or create result evidence.

## Checks

| Check | Status | Detail |
| --- | --- | --- |
| `repo_inputs` | `pass` | all AU paper runner, registry, task, scoring, evidence, and QA inputs exist in this checkout |
| `git_ignore_boundary` | `pass` | required AU paper handoff files are not ignored by git |
| `runner_repo_local_inputs` | `pass` | AU runner and env source do not read local Praxis/Aegis checkout paths |
| `python_validation_dependencies` | `pass` | jsonschema and PyYAML are available for AU validators and readiness checks |
| `au_task_counts` | `pass` | AU task files retain 100 train, 100 held-out, and 50 stress rows |
| `au_authority_validator` | `pass` | /home/qube/civitas/.venv/bin/python3 /home/qube/civitas/paper_eval_6.7b/policy_corpora/validate_au_paper_scope.py passed: PASS: au_finance_paper_scope has resolved AU paper authority bindings |
| `au_taskset_validator` | `pass` | /home/qube/civitas/.venv/bin/python3 /home/qube/civitas/paper_eval_6.7b/tasks/au_finance_v1/validate_au_taskset.py --task-file /home/qube/civitas/paper_eval_6.7b/tasks/au_finance_v1/train_failures_100.jsonl --task-file /home/qube/civitas/paper_eval_6.7b/tasks/au_finance_v1/heldout_eval_100.jsonl --task-file /home/qube/civitas/paper_eval_6.7b/tasks/au_finance_v1/stress_50.jsonl passed: - train_failures: 100 |
| `run_env_values` | `pass` | AU authority hashes and model identity env values are present |
| `model_version_frozen` | `pass` | MODEL_VERSION is frozen as 95e5aad2e60a |
| `run_toolchain` | `pass` | cargo, python3, and protoc are available |
| `rust_fontconfig_build_dependency` | `pass` | pkg-config can resolve fontconfig for Rust plot/font dependencies |
| `ollama_api` | `pass` | Ollama tags endpoint is reachable at http://localhost:11434/api/tags |
| `ollama_model` | `pass` | Ollama model gemma4:e2b-it-q8_0 is installed |

## Blocking Gaps

- none

## Warnings

- none

## Next Actions

- Run RUN_AU_PAPER.sh on this Gemma VM.
