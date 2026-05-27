# AU Paper-Ready Checklist

This checklist tracks blockers for a real Australian finance paper evidence
bundle. Check an item only when its artifacts and verification commands exist
in the repo or archived run bundle.

## Scope And Claim Boundary

- [x] Governed self-improvement paper target is Civitas 6.7B.
- [x] Civitas 6.5B is comparator only.
- [x] Production promotion is excluded.
- [x] Smoke outputs are excluded from paper evidence.
- [x] AU-only paper scope is frozen in paper docs and proof bundle.
- [x] APRA/ASIC are described as AU-baseline-contained source subsets.
- [x] EU is excluded from selected task files and final claims.
- [x] API/frontier portability is excluded unless a real optional run is frozen.

## New Box Run Package

- [x] AU paper env defaults are committed in `repro/AU_PAPER_ENV.sh`.
- [x] Repo-local AU runner inputs are enumerated in the new-box handoff note.
- [x] AU setup checker validates authority, taskset, dependencies, git-ignore
  boundary, and external-checkout boundary without running the Gemma matrix.
- [x] Paper runner reruns the strict setup checker on the Gemma VM before model
  execution.
- [x] Paper runner refuses a placeholder `MODEL_VERSION`.
- [x] Gemma VM only requirements are documented separately from result
  evidence.

## AU Authority Binding

- [x] `au_finance_paper_scope` registry entry exists.
- [x] Praxis baseline slug, release id, fingerprint, artifact URI, and source
  refs are frozen.
- [x] Selected Aegis active-governance bundle id/version are frozen.
- [x] Active-law epoch id, epoch root, sequence root/index, state, and
  activation evidence are frozen.
- [x] Harness `active_law_hash` mapping is documented.
- [x] Harness `policy_graph_hash` mapping is documented.
- [x] Harness `trust_region_hash` mapping is documented.
- [x] Selected AU claim lane has no unresolved `PENDING_*` values.
- [x] Readiness check accepts an AU paper-linked authority fixture.
- [x] Prompt 12B authority red-team QA accepts the selected AU lane for task
  curation.

## AU Benchmark Tasks

- [x] AU source map exists for the selected baseline refs.
- [x] Final taskset folder exists under `tasks/au_finance_v1/`.
- [x] Final train split has 100 real AU rows.
- [x] Final held-out split has 100 real AU rows.
- [x] Final stress split has 50 real AU rows.
- [x] Every claim row uses the selected AU registry `policy_corpus_id`.
- [x] Every claim row has real `policy_source_refs`.
- [x] Every claim row has real `source_document_refs`.
- [x] Every claim row has active-law, graph, trust-region, and Praxis binding
  fields required by the AU lane.
- [x] No final task row contains placeholder or EU claim metadata.
- [x] Expected control actions and policy basis were reviewed.
- [x] Split near-duplicate/leakage audit passes.
- [x] Task schema validation passes.
- [x] Taskset manifest and task hashes are frozen.

## Real Execution

- [x] Local Gemma/Ollama model lane is real and configured.
- [ ] Local model provider, tag/version, decode settings, seed/determinism
  status, and config hash are frozen.
- [ ] Civitas 6.5B frozen comparator adapter emits real rows.
- [ ] Civitas 6.7B no-improvement adapter emits real rows.
- [ ] Civitas 6.7B governed sandbox improvement emits real rows.
- [ ] Ungated sandbox ablation condition is implemented or explicitly removed
  from the paper matrix before claims.
- [x] Claim-supporting rows reject deterministic smoke-stub contamination.
- [x] Result schemas and receipt hashes remain intact.
- [ ] Failed task rows remain visible.

## Scoring

- [ ] Scoring rubric is frozen.
- [x] Initial scorer/adjudicator implementation exists.
- [ ] Judge model/config is frozen if a judge is used.
- [ ] Human spot-review protocol exists for ambiguous/high-risk rows.
- [x] Scored rows include the required safety, policy, control-action, and
  evidence labels.
- [ ] Scoring errors and parse failures remain visible.
- [ ] Scoring QA passes.

## Candidate And Governance Evidence

- [ ] Failure discovery runs on train failures only.
- [ ] Candidate generation uses real train-derived failure clusters only.
- [ ] Candidate provenance, config hashes, policy hashes, and source cluster
  hashes are archived.
- [x] Cassius challenge evidence exporter/loader exists for candidate hashes.
- [x] Claim-supporting gate approvals require passed Cassius evidence.
- [ ] Cassius challenge JSONL, receipt lineage, and challenge config are
  archived.
- [ ] Trust-region decision artifacts are archived per governed candidate.
- [ ] Replay/canary evidence is evaluated and archived, or the narrowed claim
  boundary is explicitly approved before final run.
- [ ] Aegis/Senate evidence status is explicit and does not fabricate live
  approval.
- [ ] Gate red-team QA passes.

## Sandbox Evaluation

- [ ] Only sandbox-approved candidates are promoted to sandbox overlays.
- [ ] Held-out evaluation loads sandbox artifacts only.
- [ ] Stress evaluation loads sandbox artifacts only.
- [ ] Candidate hashes remain visible in governed rows.
- [ ] Rejected and failed candidates remain visible.
- [ ] Production mutation count is zero.
- [ ] Unauthorized promotion count is zero.
- [ ] Sandbox-only markers are preserved.

## Reproducibility And Reporting

- [x] AU paper run entrypoint exists.
- [x] AU paper verifier exists.
- [x] AU paper pre-run handoff checker exists.
- [ ] Run manifest freezes registry, tasks, configs, models, scoring,
  governance, sandbox, and result hashes.
- [x] Statistics and uncertainty outputs are implemented for primary held-out
  deltas.
- [ ] Pilot AU run completes and pilot defects are closed.
- [ ] Full AU run completes.
- [ ] Aggregated tables and limitations summary are archived.
- [ ] Proof bundle manifest is complete.
- [ ] Readiness checker returns `paper_evidence_ready`.
- [ ] Final evidence QA passes.

## Immediate Next Items

- [x] Run Prompt 12A.
- [x] Update `TRACKER.md` after Prompt 12A.
- [x] Do not start final task curation until the selected AU authority mapping
  is frozen.
- [x] Build the AU source map and task curation controls before final task rows
  are frozen.
- [x] Curate the AU `train_failures` split against the bounded source map.
- [x] Run QA-C and freeze or fix the AU taskset before execution work.
- [x] Discover the real local execution surfaces before wiring non-stub rows.
- [ ] Run the full real-local AU condition matrix on the new Gemma box.
- [ ] Produce real candidate, Cassius, gate, sandbox, held-out, and stress
  artifacts from that run before calling any output paper evidence.
- [x] Commit the AU paper env source and new-box handoff note.
