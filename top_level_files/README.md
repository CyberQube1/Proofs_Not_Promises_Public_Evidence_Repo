# Civitas 6.7B Governed Self-Improvement Paper Eval

This directory is the research-only scaffold for evaluating Civitas 6.7B as a
bounded governed self-improvement system.

The paper question is:

> Can Civitas 6.7B improve governed-agent behavior through a bounded,
> auditable, governance-gated improvement loop?

## What changed

- 2026-05-25: Expanded `public_evidence_pack/` into a
  reproduction-oriented evidence package for reviewer inspection. The pack now
  includes the locked AU task rows, raw outputs, scored rows, scoring audits,
  candidate/Cassius/gate/trust-region/replay/sandbox artifacts, final tables,
  schemas, validation and leakage materials, eval/repro/taskset scripts,
  runbooks, method docs, paper QA notes, proof/readiness workspace,
  manuscript source/build artifacts, legacy context, `REPRODUCTION_GUIDE.md`,
  and `verification/verify_public_pack.sh`. The release archive is
  `civitas_6_7b_public_evidence_pack_20260524.tar.gz`; it still excludes
  production credentials, hosted model credentials, private source documents,
  live authority services, model binaries, and production-promotion rights.
- 2026-05-22: Tightened the paper stack boundary with the Aegis
  runtime-governance source: Aegis owns trusted action-boundary control, while
  Civitas is the embedded deliberative and candidate-improvement runtime
  evaluated by the AU lane.
- 2026-05-22: Updated the JAIR architecture framing so Civitas is the embedded
  agentic governance runtime inside the Aegis active-law envelope rather than
  merely an adjacent system. The draft now includes a Praxis/Aegis/Civitas/
  Senate role-boundary table, a `Civitas Inside Aegis` subsection, and an
  Aegis-envelope figure while preserving the bounded AU Civitas lane and the
  non-claim that Civitas activates law.
- 2026-05-22: Prompt P cleans the JAIR citation architecture and end matter
  without changing locked AU evidence. The manuscript moves References before
  Appendix A, places literature citations beside the exact comparator or
  analogy text they support, classifies citation roles in `CITATION_QA.md`,
  and clears the prior BibTeX warning set for Reflexion, Schneider, TUF, and
  in-toto from the checked build.
- 2026-05-22: Prompt O hardens the JAIR draft for reviewer interpretation
  without changing AU result values. The introduction now explains why the
  improvement attempt must stay inspectable, the sanitized case study has a
  readable candidate walkthrough, related work distinguishes complementary
  comparison families more precisely, the manuscript adds a reviewer-response
  table, and declarations now separate AU facts from release metadata that
  still needs human confirmation.
- 2026-05-22: Prompt N adds mechanism and citation discipline to the JAIR
  draft without changing locked AU evidence. The paper now shows the
  candidate artifact schema, lifecycle-to-artifact map, one sanitized
  unsupported-claim improvement attempt, Cassius/gate mechanics, scoring
  definitions, safe-fallback trap, and a citation/evidence policy that keeps
  literature context separate from AU result support.
- 2026-05-22: Prompt L hardened the JAIR package presentation without changing
  AU evidence. The manuscript now uses LaTeX-native draft lifecycle and
  Praxis/Aegis/Civitas diagrams instead of placeholder boxes, uses clearer
  dense-table typesetting and breakable evidence paths, and tracks remaining
  bibliography and release-metadata work in the LaTeX checklist/build notes.
- 2026-05-22: Prompt K sharpened the JAIR manuscript narrative without adding
  evidence or widening claims. The abstract and introduction now make the
  prompt-repair versus governed-candidate-improvement contrast immediate, the
  manuscript has a short reader map and more meaningful table captions, and
  the locked AU local/sandbox result boundary stays unchanged.
- 2026-05-22: Prompt J materially rewrote `paper/latex_jair/main.tex` into a
  substantive governed-candidate-improvement systems draft. It adds the
  lifecycle model and prompt-repair comparison, expands the architecture,
  falsifiability, results, discussion, and related-work argument, replaces
  visible local citation markers with tracked Civitas 4.0/Aegis manuscript
  keys, and leaves the locked AU evidence values and non-claim boundaries
  intact.
- 2026-05-22: Prompt I QA-audited the JAIR LaTeX package under
  `paper/latex_jair/`: clean rebuild, citation-key and lineage-marker audit,
  locked AU table-value audit, overclaim audit, reviewer checklist refresh,
  and minimal placeholder-figure accessibility descriptions. The manuscript
  is ready for external review with citation and release-metadata cleanup
  still open.

The system under test is Civitas 6.7B. Civitas 6.5B may be used only as a
frozen baseline. This track does not reopen a Civitas 4.0 paper claim and it is
not another Aegis action-boundary paper. Aegis and Senate evidence may be
observed by the evaluation, but this scaffold does not alter their semantics.

## Scaffold Layout

- `docs/` defines the thesis, evaluation plan, claim boundary, experiment
  matrix, result log, reproducibility rules, and phase runbooks.
- `paper/` holds the writing-layer scaffold for the Civitas 6.7B paper:
  thesis, paper claim boundary, outline, contribution bullets, related
  positioning, terms, and the paper-facing evaluation protocol/runbooks.
- `tasks/` holds the task schema plus research split manifests and task rows.
- `policy_corpora/` holds the linkage-only Praxis/Aegis corpus registry and
  the discovery notes that justify real and pending registry refs.
- `rubrics/` defines the scoring contract used by research results.
- `schemas/` defines machine-readable research contracts for baseline results,
  failure clusters, improvement candidates, governance gate results, and
  sandbox promotion, held-out, and stress result records.
- `results/` holds scored research outputs, aggregate table drafts, summary
  Markdown, and a reserved figures directory.
- `artifacts/` is reserved for sandbox receipts, candidate packages, manifests,
  and audit evidence produced by future research runs.
- `scripts/` holds evaluation-only helpers. It must not become a live promotion
  path.
- `repro/` holds the smoke reproducibility bundle, verifier, manifest contract,
  paper-readiness checker, and run-local reproducibility artifacts.
- `paper_ready/` holds the AU-only roadmap, checklist, prompt tracker,
  red-team QA contract, and proof-bundle skeleton for moving from smoke
  readiness to final paper evidence.

## Research Contract

- Do not mutate production state from this directory.
- Do not add live promotion behavior.
- Keep all candidate promotion sandboxed or simulated.
- Record approval and rejection reason codes for every candidate decision.
- Treat unauthorized promotion as a countable safety failure, not an accepted
  optimization event.

The Prompt 0 through Prompt 9A scaffold implements research-only baseline,
failure-discovery, candidate-generation, governance-gate, and sandbox
promotion-simulator runners plus held-out/stress sandbox evaluation and
paper-table aggregation plus smoke reproducibility packaging. It does not
implement model training, production promotion, governance changes, or
production integration.

## Docs

- `docs/PAPER_THESIS.md` states the thesis and the paper identity.
- `docs/EVAL_PLAN.md` defines the research question, task splits, conditions,
  metrics, and evaluation flow.
- `docs/CLAIM_BOUNDARY.md` states what the evidence may and may not support.
- `docs/EXPERIMENT_MATRIX.md` defines the comparison matrix.
- `docs/RESULTS_LOG.md` is the research run log template.
- `docs/REPRODUCIBILITY.md` records reproduction and artifact expectations.
- `docs/DATASET_PLAN.md` explains placeholder task splits, task-to-registry
  linkage, and future public ASIC/APRA/EU corpus onboarding.
- `docs/RUNBOOK_BASELINE.md` explains the first baseline-only smoke path.
- `docs/RUNBOOK_FAILURE_DISCOVERY.md` explains deterministic train-split
  failure clustering and the explicit non-claim debug override.
- `docs/RUNBOOK_CANDIDATE_GENERATION.md` explains cluster-bound candidate
  export records and gate-ready provenance.
- `docs/RUNBOOK_GOVERNANCE_GATE.md` explains deterministic sandbox-only
  candidate gate results, receipt-bound Cassius evidence for claim-supporting
  runs, and explicit unavailable external checks.
- `docs/RUNBOOK_SANDBOX_PROMOTION.md` explains how approved gate rows become
  isolated sandbox overlays and promotion receipts.
- `docs/RUNBOOK_HELDOUT_STRESS.md` explains held-out comparison rows, stress
  regression flags, and sandbox-only artifact loading.
- `docs/RUNBOOK_AGGREGATION.md` explains paper-table draft aggregation,
  partial-input labeling, and smoke limitations.
- `docs/RUNBOOK_REAL_LOCAL_EXECUTION.md` explains non-stub local
  Gemma/Ollama execution and its raw-row boundary.
- `docs/RUNBOOK_SCORING.md` explains scored result and audit exports for raw
  non-stub rows.
- `docs/RUNBOOK_AU_PAPER_EVIDENCE.md` explains the strict AU paper runner and
  verifier path.
- `docs/PAPER_EVIDENCE_READINESS.md` explains the smoke, pilot, and
  paper-evidence pre-run readiness gate.
- `paper_ready/README.md` is the tracked AU paper-readiness entrypoint.
- `docs/REPRODUCIBILITY.md` now also explains the Prompt 9 smoke bundle,
  verification checks, evidence archive, and smoke-to-pilot/full upgrade path.
- `paper/PAPER_THESIS.md`, `paper/CLAIM_BOUNDARY.md`, and
  `paper/PAPER_OUTLINE.md` start the Paper Prompt A writing scaffold without
  converting the verified run bundle into final results prose.
- `paper/EVALUATION_PROTOCOL.md`, `paper/BENCHMARK_RUNBOOK.md`,
  `paper/TASK_DESIGN_GUIDE.md`, `paper/SCORING_AND_ADJUDICATION.md`,
  `paper/EVIDENCE_REQUIREMENTS.md`, and `paper/PILOT_PLAN.md` make the
  Paper Prompt B empirical plan explicit without creating new benchmark
  outputs.
- `paper/FIGURES_AND_TABLES.md`, `paper/RESULTS_SECTION_SKELETON.md`,
  `paper/DISCUSSION_SKELETON.md`, `paper/LIMITATIONS.md`,
  `paper/REVIEWER_ATTACKS.md`, `paper/ABSTRACT_DRAFT.md`,
  `paper/INTRODUCTION_DRAFT.md`, and `paper/CLAIM_TO_EVIDENCE_MAP.md` add
  the Paper Prompt C results-and-narrative shells that Paper Prompt D now
  binds to the verified AU paper evidence bundle.
- `paper/EVIDENCE_BOUND_RESULTS.md`, `paper/PAPER_CLAIM_STRENGTH.md`, and
  `paper/TABLE_LOCK_AU_20260522.md` pin the Paper Prompt D AU result verdict,
  allowed claim strength, mixed behavioral deltas, and selected final table
  artifacts before full-draft assembly.
- `paper/CIVITAS_4_LINEAGE.md`, `paper/AEGIS_POSITIONING.md`, and
  `paper/PAPER_LINEAGE_MAP.md` add the D-Bridge lineage map from the local
  Civitas 4.0 manuscript to the 6.7B candidate-improvement paper while
  keeping Aegis active-law activation outside the Civitas 6.7B contribution.
- `paper/FULL_DRAFT.md` assembles the first evidence-bound paper manuscript
  from the verified AU run, locked table interpretation, lineage bridge, and
  claim boundary for reviewer-style hardening. The Civitas 4.0 LaTeX source
  is a structural/style baseline for the draft shape only, not a 6.7B
  empirical evidence source.
- `paper/latex_jair/` holds the Prompt H JAIR-target LaTeX manuscript package:
  `main.tex`, the controlled 6.7B draft bibliography, explicit figure/table
  asset notes, build notes, and a submission checklist. It converts the
  hardened AU evidence-bound draft without importing Civitas 4.0 result claims
  or treating external citations as support for AU result values.
- `paper/latex_jair/CITATION_QA.md`,
  `paper/latex_jair/TABLE_VALUE_QA.md`, and
  `paper/latex_jair/OVERCLAIM_QA.md` record Prompt I's reviewer-readiness
  audit for cite keys, locked AU manuscript values, and blocked overclaim
  wording.

## Tasks And Rubric

- `tasks/schema/task.schema.json` defines the JSONL task row contract.
- `tasks/au_finance_v1/` holds the bounded AU paper-task source map, authoring
  controls, taskset manifest and leakage-review templates, and the final-task
  validator that rejects placeholder or off-scope AU rows.
- `policy_corpora/policy_corpus_registry.yaml` binds registry `corpus_id`
  values to Praxis/Aegis artifact refs without copying policy documents.
- `policy_corpora/AU_PAPER_SCOPE_BINDING.md` documents the resolved
  `au_finance_paper_scope` authority mapping for first-paper AU task rows.
- `tasks/train_failures_100.jsonl`, `tasks/heldout_eval_100.jsonl`, and
  `tasks/stress_50.jsonl` currently contain clearly labeled synthetic
  placeholder rows only.
- `tasks/au_finance_v1/train_failures_100.jsonl`,
  `tasks/au_finance_v1/heldout_eval_100.jsonl`, and
  `tasks/au_finance_v1/stress_50.jsonl` are the source-map-valid AU taskset
  frozen after QA-C with a manifest and leakage review.
- `rubrics/scoring_rubric.md` defines binary and graded scoring labels for
  governed-agent control behavior.
- `scripts/run_baseline_eval.sh` runs both baseline conditions through the
  deterministic research stub adapter and exports comparable JSONL rows.
- `scripts/aggregate_results.py` rolls raw JSONL artifacts into CSV table
  drafts and `results/RESULTS_SUMMARY.md` without treating smoke outputs as
  paper evidence.
- `scripts/export_replay_canary_evidence.py` exports post-sandbox canary and
  replay-status evidence rows for the final AU bundle without inventing replay
  success.
- `repro/RUN_ALL.sh`, `repro/VERIFY_RESULTS.sh`, and `repro/MANIFEST.md`
  package and verify a run-local smoke bundle under `repro/runs/<run_id>/`.
- `repro/AU_PAPER_ENV.sh` is the committed non-secret cross-box authority and
  local-model default source for the AU paper lane.
- `repro/CHECK_AU_PAPER_SETUP.sh` verifies the commit-and-run AU package and
  the Gemma VM environment without running the full paper matrix.
- `repro/CHECK_PAPER_READINESS.sh` audits selected registry, task, Cassius,
  comparator, sandbox, and reproducibility bindings before smoke, pilot, or
  paper-evidence runs.
- `repro/RUN_AU_PAPER.sh` and `repro/VERIFY_AU_PAPER_RESULTS.sh` define the
  strict non-smoke AU run entrypoint and claim-boundary verifier.
- `repro/QA_AU_PAPER_EVIDENCE.sh` writes the final AU evidence QA report only
  after the paper verifier and readiness checker pass on a run directory.

## Runner And Schema Status

- `baseline` preserves task `split` in every result row.
- `failure_discovery` accepts `train_failures` rows by default and rejects
  held-out or stress input unless a visible non-claim debug override is used.
- `candidate_generation` accepts train-derived clusters by default. Any
  non-train debug candidate export is marked `claim_supporting_run=false`.
- `governance_gate` exports one deterministic sandbox-only gate result per
  candidate, requires passed receipt-bound Cassius challenge evidence for
  claim-supporting approvals, and does not approve held-out, stress, or
  non-claim-supporting candidate inputs.
- `sandbox_promote` writes sandbox state and structured candidate overlays only
  for `approved_for_sandbox` train candidates. Skipped promotion rows keep
  rejected and non-claim inputs visible.
- `heldout_eval` and `stress_eval` require split-pure non-training task files
  and Prompt 6 sandbox state for governed-improvement rows. Governed rows keep
  applied candidate hashes; failed task execution becomes an explicit error
  row.
- `scripts/aggregate_results.py` aggregates behavior, candidate lifecycle,
  rejection reason, governance containment, and held-out delta tables. Behavior
  rows remain condition-level while distinguishing run family, provider,
  backend kind, and model ID. Missing optional inputs remain visible as
  `not_available`.
- `--execution-mode real_local` emits actual local Ollama raw rows with model
  metadata, prompt/config/receipt hashes, parsed control actions, and measured
  latency. One scored one-row AU pilot under `results/au_real/` proves this
  adapter path only; it is not paper evidence.
- `scripts/score_results.py` exports rubric-bound scored rows plus scoring
  audit JSONL without changing the raw real-local result file.
- `trust_region_evidence` exports candidate-bound trust-region rows. The AU
  paper gate uses those rows for `trust_region_check.state=evidence_passed`
  before an approved sandbox candidate can pass the AU verifier.
- `repro/RUN_ALL.sh` executes the existing smoke phases into a run directory,
  writes a run manifest with hashes and safety counts, and leaves source task
  artifacts unchanged. Its synthetic scored train copy is smoke-only failure
  evidence for the deterministic baseline stub.
- `repro/CHECK_PAPER_READINESS.sh` writes JSON and Markdown readiness reports.
  Smoke may pass with placeholder tasks and Cassius `not_required`; paper mode
  fails closed on pending claim refs, missing receipt-bound Cassius evidence,
  skipped API portability claims, containment defects, or failed reproducible
  verification.
- `schemas/baseline_result.schema.json`,
  `schemas/failure_cluster.schema.json`, and
  `schemas/improvement_candidate.schema.json`, plus
  `schemas/governance_gate_result.schema.json` and
  `schemas/sandbox_promotion.schema.json` and
  `schemas/heldout_stress_result.schema.json`, plus
  `schemas/trust_region_gate_evidence.schema.json` and
  `schemas/replay_canary_evidence.schema.json` pin the current phase contracts.

The Prompt 4A QA-A fix pack closed the midpoint contract gaps before Prompt 5.
Prompt 5 added the research gate record. Prompt 6 added sandbox overlay
simulation only. Prompt 7 consumes those overlays for held-out and stress
evaluation without loading production config. Prompt 8 adds table draft and
Markdown summary aggregation with explicit smoke limitations. Prompt 9 adds
smoke reproducibility packaging and verification. Prompt 9A makes Cassius
challenge coverage explicit in the gate, containment aggregation, and
reproducibility verifier. Prompt 10B adds a linkage-only policy corpus registry
and optional task provenance fields for frozen Praxis/Aegis source bindings;
live promotion and policy ingestion remain absent. Prompt 11 adds the primary
Gemma/Ollama local model lane and an optional API portability metadata lane;
API absence is an explicit skip, not leaderboard or cross-model evidence.
Prompt 11A adds a pre-run readiness gate that keeps smoke, pilot, and
paper-evidence readiness separate before Paper Prompt A. The AU
`paper_ready/` program now tracks the 26-prompt path from that readiness gate
to a shareable verified proof bundle. Prompt 12B closes the AU authority QA
gate, and Prompt 13A adds bounded source-map and leakage controls before final
AU task rows are curated. The current AU `100/100/50` curation candidate is
materialized under those controls, fixed during dataset red-team QA, and frozen
for real execution work. The repo now also carries the AU run env source,
strict AU setup checker, trust-region and replay/canary evidence contracts,
final table outputs, and final QA entrypoint. The setup checker closes the
commit-and-run handoff boundary before a large model job starts. The full
non-stub AU run bundle `repro/runs/au-paper-20260522T023114Z/` has now been
copied back and verified on the old box: `QA_AU_PAPER_EVIDENCE.sh` passed and
paper readiness returned `paper_evidence_ready`. That verification is
bookkeeping only and did not generate new benchmark evidence. The next paper
steps are Paper Prompt A, then B, then C. Paper Prompt A now creates the
writing scaffold under `paper/`, with results interpretation still deferred to
later evidence-bound paper drafting. Paper Prompt B now adds the paper-facing
evaluation protocol, benchmark runbook, task/scoring guidance, evidence tiers,
and pilot plan on top of the existing AU harness and verified evidence bundle.
Paper Prompt C now wires figures, table shells, result interpretation
templates, reviewer-attack responses, and abstract/introduction placeholders
without filling paper values before evidence-bound table lock. Paper Prompt D
now uses the verified AU bundle for that table lock: the paper can proceed as a
governed-containment systems result with selected held-out risk reductions, but
the mixed correct-control/regression outcomes, 8-of-8 sandbox approval
selectivity limit, local-only model scope, unavailable replay status, and
non-claims for API, EU, production promotion, and statistical significance stay
explicit. The D-Bridge pass now cross-references the local Civitas 4.0 source
before full-draft assembly so 6.7B reads as the next governed-improvement
surface after reflexive governance, not as an isolated AU table report; Aegis
still owns active-law activation. Paper Prompt E now assembles those locked
inputs into `paper/FULL_DRAFT.md` for reviewer-style critique without creating
new benchmark evidence or widening the AU evidence boundary. The full draft
uses the 4.0 Springer LaTeX shape and declaration/appendix pattern as lineage
only and does not import 4.0 phase metrics as 6.7B evidence.
