# Prompt Sequence To AU Paper Evidence

## Count

Use **26 controlled prompts** after Prompt 11A before Paper Prompt A.

That count intentionally includes red-team QA gates, pilot closure, and final
evidence release QA. Prompts may be collapsed only when a QA gate proves the
merged work kept the same acceptance coverage.

## Prompt Queue

| Seq | Prompt | Purpose | Exit gate |
| ---: | --- | --- | --- |
| 1 | Prompt 12A | Create `au_finance_paper_scope`; bind Praxis AU baseline and selected Aegis active-governance refs; document hash mappings. | AU authority lane has no claim blockers. |
| 2 | Prompt 12B | Red-team AU authority binding and paper-readiness rules. | No unresolved AU registry ambiguity reaches task curation. |
| 3 | Prompt 13A | Add AU task source map, curation controls, taskset manifest contract, and leakage review tooling. | Task authors have bounded AU sources and split rules. |
| 4 | Prompt 13B | Curate AU `train_failures` 100 rows. | Train rows validate and are governed-failure rows. |
| 5 | Prompt 13C | Curate AU `heldout_eval` 100 sealed rows. | Held-out rows validate and stay sealed. |
| 6 | Prompt 13D | Curate AU `stress` 50 rows and run cross-split leakage audit. | Final taskset hashes freeze. |
| 7 | QA-C | Red-team dataset quality, source refs, leakage, policy basis, and non-QA character. | AU dataset accepted or fix pack issued. |
| 8 | Prompt 14A | Discover real execution surfaces for local Gemma/Ollama, Civitas 6.7B, and frozen 6.5B. | Adapter plan cites real surfaces and blockers. |
| 9 | Prompt 14B | Wire real local Civitas 6.7B no-improvement execution. | Non-stub 6.7B control rows emit. |
| 10 | Prompt 14C | Wire frozen Civitas 6.5B comparator execution. | Frozen comparator rows emit with config hashes. |
| 11 | Prompt 14D | Wire governed sandbox improvement and ungated sandbox ablation execution. | Sandbox conditions emit real rows only. |
| 12 | QA-D | Red-team execution adapters for stubs, state mutation, receipts, errors, and model/config freeze. | Real execution lane accepted or blocked. |
| 13 | Prompt 15A | Freeze scoring/adjudication contract and review protocol. | Scoring labels and evidence contract are defendable. |
| 14 | Prompt 15B | Implement scorer exports and scoring audit artifacts. | Scored rows feed aggregation without dropped failures. |
| 15 | QA-E | Red-team scorer, judge config, policy-label drift, and error accounting. | Scoring accepted or fix pack issued. |
| 16 | Prompt 16A | Add Cassius challenge evidence export/load path for candidate hashes. | Claim gates can consume real Cassius receipts. |
| 17 | Prompt 16B | Add trust-region and evaluated replay/canary evidence artifacts. | Governance evidence goes beyond unchecked hashes. |
| 18 | Prompt 16C | Add evidence-loaded Aegis/Senate status where reachable or lock the narrower claim boundary. | No live-approval ambiguity remains. |
| 19 | QA-F | Red-team candidate generation and governance evidence. | Gate evidence accepted or blocked. |
| 20 | Prompt 17A | Add AU paper run entrypoint, manifest, verifier, and proof-bundle assembly. | A paper bundle can be built and checked. |
| 21 | Prompt 17B | Add predeclared AU paper metrics, held-out delta uncertainty, and final table exports. | Tables are paper-reportable. |
| 22 | QA-G | Dry-run final readiness audit before pilot. | Pilot path has no known readiness blocker. |
| 23 | Prompt 18A | Run AU pilot on declared small split subset. | Pilot evidence surfaces run end to end. |
| 24 | Prompt 18B | Fix pilot defects and freeze full AU configs/taskset/scorer/gate inputs. | Full-run inputs are frozen. |
| 25 | Prompt 19A | Run full AU paper evidence bundle and paper-mode readiness check. | Full run verifies or stops. |
| 26 | QA-H | Final evidence release audit and proof-bundle closeout. | Paper Prompt A may consume evidence. |

## Prompt Families

| Family | Prompts | Primary risk |
| --- | --- | --- |
| Authority | 12A-12B | Wrong active-law or graph mapping poisons every task. |
| Dataset | 13A-QA-C | Placeholder or leakage makes evidence indefensible. |
| Execution | 14A-QA-D | Smoke stubs or mutable runtime state leak into claim rows. |
| Scoring | 15A-QA-E | Labels become arbitrary or failed rows disappear. |
| Governance | 16A-QA-F | “Governed” becomes unproven or receipt-free. |
| Repro/reporting | 17A-QA-G | Tables cannot be reproduced or overclaim uncertainty. |
| Runs/release | 18A-QA-H | Pilot defects reach full evidence or archive is incomplete. |

## Standard Prompt Closeout

Every prompt after Prompt 11A must return:

1. files changed
2. contract or behavior added
3. safety boundary check
4. evidence artifacts emitted or deferred
5. focused tests/checks run
6. acceptance checklist status
7. exact tracker updates
8. whether the next prompt is safe

Each QA prompt must lead with findings. A blocking finding must stop the next
phase until a fix prompt closes it.
