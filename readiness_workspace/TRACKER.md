# AU Paper Readiness Tracker

## Status

| Field | Value |
| --- | --- |
| Paper-evidence run setup | `handoff_setup_ready` |
| Result evidence status | `pending_full_gemma_run` |
| Final result gate | `paper_evidence_ready` after the run bundle verifies |
| Paper scope | AU finance baseline with APRA/ASIC source subsets contained inside it |
| Current prompt | AU paper package handoff hardening complete |
| Next prompt | Full real-local AU paper lane on the new Gemma box |
| Full prompt plan | 26 controlled prompts before Paper Prompt A |
| Current result blocker | The full non-stub AU matrix, candidate loop, and post-sandbox evaluations have not been run yet |

## Phase Tracker

| Phase | Status | Exit artifact |
| --- | --- | --- |
| Scaffold through readiness gate | Complete | Prompt 11A readiness report |
| AU authority binding | Complete | Resolved AU paper registry lane and Prompt 12B QA |
| AU taskset | Complete | Frozen `au_finance_v1` taskset, hashes, leakage review, and QA-C verdict |
| Real execution | Adapter implemented; full run pending | One scored real-local AU row and full non-stub AU result rows |
| Scoring | Initial path implemented; evidence QA pending | Scored rows plus scoring audit artifacts |
| Governance evidence | Exporters/contracts implemented; evidence rows pending | Cassius/trust/replay evidence |
| Paper repro/reporting | Handoff package ready; full outputs pending | AU setup checker, paper runner, verifier, tables |
| Pilot | Not started | Pilot manifest and fix closeout |
| Full run | Not started | Verified full proof bundle |
| Final evidence QA | Not started | QA-H release verdict |

## Prompt Tracker

| Prompt | Status | Blocking notes |
| --- | --- | --- |
| Prompt 12A | Complete | Registry lane, AU field mapping, validator, and readiness fixture validation landed. |
| Prompt 12B | Complete | `QA_AUTHORITY_BINDING.md` accepted the selected AU authority lane for task curation. |
| Prompt 13A | Complete | AU source map, authoring controls, manifest/leakage templates, and validator landed. |
| Prompt 13B | Complete | Materialized 100 train-failure AU curation rows under the source map. |
| Prompt 13C | Complete | Materialized 100 held-out AU curation rows under sealed split metadata. |
| Prompt 13D | Complete | Materialized 50 stress rows plus manifest, authoring notes, and automated leakage review. |
| QA-C | Complete | `QA_DATASET.md` froze post-fix AU task hashes for execution work. |
| Prompt 14A-14D | In progress | Real-local adapter exists and one AU row was scored; full 6.5B/6.7B/sandbox matrix moves to the new Gemma box. |
| QA-D | Pending | Stub/state-mutation red team. |
| Prompt 15A-15B | In progress | Scoring script, audit schema, and one real-row audit exist; scorer QA/freeze remains open. |
| QA-E | Pending | Scoring red team. |
| Prompt 16A-16C | Setup complete | Candidate-bound Cassius and trust-region exports plus replay/canary post-eval export exist; run evidence remains pending. |
| QA-F | Pending | Governance red team. |
| Prompt 17A-17B | Setup complete | AU setup checker, paper runner, verifier, final QA entrypoint, and final statistical tables exist; full-run artifacts remain pending. |
| QA-G | Pending | Dry-run readiness gate. |
| Prompt 18A-18B | Pending | Pilot and freeze gate. |
| Prompt 19A | Pending | Full AU evidence run. |
| QA-H | Pending | Final evidence release gate. |

## Evidence Blockers

| Blocker | Why it blocks | Close with |
| --- | --- | --- |
| Full real-local AU run absent | One-row adapter proof is not the full condition matrix or paper evidence. | New Gemma box full AU run / QA-D |
| Real scorer not QA-frozen | Metrics labels are not paper-grade until the scorer and review protocol pass QA. | Prompt 15A-15B / QA-E |
| Real Cassius candidate receipts absent | Export path exists, but real candidate approvals still need candidate-bound Cassius evidence from the full run. | Prompt 16A / QA-F |
| Replay run evidence absent | Replay/canary exporter exists, but actual canary/replay rows require the full sandbox run. | New Gemma box run / QA-F |
| Paper bundle absent | Evidence cannot be shared or verified as one unit. | New Gemma box run / final QA |

## Compact 12A To 16 Status

This maps the user-facing compressed work list to the expanded tracker above.

| Item | Status |
| --- | --- |
| `12A` AU authority binding | Complete |
| `12B` final AU benchmark dataset | Complete |
| `13A` real local Gemma/Ollama execution | Adapter complete; one-row AU pilot scored; full AU run pending on the new Gemma box |
| `13B` scoring/adjudication | Initial scoring and audit path complete; final QA/freeze pending |
| `14A` Cassius candidate evidence | Export/gate path complete; real candidate evidence waits on full train candidates |
| `14B` trust/replay/canary strengthening | Setup complete; evidence rows wait on the full sandbox run |
| `15A` AU paper runner/verifier | Implemented; full-run proof pending |
| `15B` final paper statistics | Setup complete; final tables emit from full run artifacts |
| `16` final paper evidence QA | QA entrypoint exists; verdict waits on the evidence bundle |

## Tracker Update Rule

When a prompt changes evidence status:

1. Update the phase tracker.
2. Update the prompt tracker.
3. Check completed items in `AU_PAPER_READY_CHECKLIST.md`.
4. Link the run manifest or evidence artifact here if one exists.
5. Do not mark a phase complete on smoke-only artifacts.
