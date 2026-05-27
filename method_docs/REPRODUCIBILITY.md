# Reproducibility

## Reproduction Contract

Each research run should make the paper claim replayable enough to audit the
inputs, candidate lifecycle, gate decision, scoring path, and reported metric
envelope without mutating production state.

`paper/EVALUATION_PROTOCOL.md`, `paper/BENCHMARK_RUNBOOK.md`, and
`paper/EVIDENCE_REQUIREMENTS.md` are the paper-facing protocol surfaces. This
document remains the reproducibility contract those runbook steps must satisfy.

Record at minimum:

- Civitas 6.7B revision and configuration for every condition.
- Frozen Civitas 6.5B baseline revision when `C65_FROZEN` is used.
- Frozen `policy_corpora/policy_corpus_registry.yaml` hash and the selected
  `au_finance_paper_scope` authority mapping for the first AU paper run.
- Task split manifest hashes and task IDs.
- Active-law hash, active-law epoch root when available, policy graph hash,
  trust-region hash, Praxis bundle ID/version, and exact source document refs
  used by each real corpus task set.
- Rubric version, policy context version, scoring configuration, and judge
  configuration when a judge is used.
- Random seeds, decoding settings, candidate generator settings, and trust
  region parameters.
- Provider, backend kind, model ID and available model version for every model
  lane. Record the local Ollama tag, run family, temperature, max-token bound,
  seed or determinism setting, API config status, and whether the lane is
  claim-supporting.
- Candidate package IDs, critique artifacts, gate decisions, reason codes, and
  receipts.
- Sandbox or simulation markers proving no production mutation occurred.
- Result artifact hashes, aggregation code revision, and replay outcome.

For the AU paper lane, archive `policy_corpora/AU_PAPER_SCOPE_BINDING.md`
beside the registry snapshot. That file records why task `active_law_hash`
uses the selected active-law epoch root, why `policy_graph_hash` uses the
selected constitutional-graph digest, and which active trust-region digest is
bound for gating.

`repro/AU_PAPER_ENV.sh` is the committed cross-box source for non-secret AU
paper-lane authority hashes and local Ollama defaults. It is safe to commit
and safe to source on a larger Gemma box. It does not replace the run manifest:
the run manifest must still freeze the actual model tag/version and result-row
settings used on that box.

## Split Discipline

- The training/failure-discovery split may drive recurring-failure detection and
  candidate generation.
- The held-out evaluation split may score selected conditions but must not tune
  candidate content or gates.
- The adversarial stress split may probe drift and safety failures but must not
  be quietly folded into training or hidden from reporting.

## Replay Accounting

Replay manifests should say which outputs are expected to match exactly and
which are evaluated within a declared tolerance or score envelope. The replay
reproducibility rate must use that declared replay unit and denominator.

Receipt completeness checks should cover:

1. Failure-discovery evidence.
2. Candidate generation artifacts.
3. Candidate critique artifacts.
4. Gate decision artifacts.
5. Approval or rejection reason codes.
6. Held-out and adversarial scoring artifacts.
7. Sandbox or simulation boundary evidence.

## Safety During Reproduction

- Reproductions must not mutate production state.
- Reproductions must not add a live promotion path.
- Sandboxed or simulated promotion artifacts must be visibly labeled as such.
- A missing receipt or reason code is a reproducibility defect and a claim
  boundary defect, not a paperwork exception.

## Directory Use

- Put split manifests under `tasks/`.
- Put scored summaries and aggregate tables under `results/`.
- Put candidate packages, receipts, manifests, and replay evidence under
  `artifacts/`.
- Keep `scripts/` evaluation-only if helpers are added later.

## Smoke Bundle

Prompt 9 adds `paper_eval_6.7b/repro/` as the smoke reproducibility entrypoint.
Run from the repository root:

```bash
bash paper_eval_6.7b/repro/RUN_ALL.sh prompt9-smoke
```

The script writes run-specific artifacts under
`paper_eval_6.7b/repro/runs/<run_id>/`:

- baseline JSONL rows for the Civitas 6.5B and Civitas 6.7B no-improvement
  deterministic stub conditions
- a synthetic scored train smoke copy kept inside the run directory so the
  failure-discovery and candidate lifecycle phases have failure evidence
- failure clusters, candidates, gate results, sandbox overlays/promotions,
  held-out/stress results, aggregate tables, `RESULTS_SUMMARY.md`, and a
  run-specific `MANIFEST.md`

The scored smoke copy does not change source task rows or source baseline
artifacts. It is an explicit harness fixture and is not paper evidence. The
smoke script passes `governance_gate --cassius-not-required`, so smoke gate
rows are explicitly non-claim-supporting and do not imply a Cassius pass.

## Smoke Verification

Verify a run from the repository root:

```bash
bash paper_eval_6.7b/repro/VERIFY_RESULTS.sh \
  paper_eval_6.7b/repro/runs/prompt9-smoke
```

The verifier checks expected JSONL, CSV, summary, manifest, sandbox marker, and
safety-count artifacts. It requires zero production mutations and zero
unauthorized promotions. It also checks that source task hashes do not change
during verification. Claim-supporting gate rows must have required, passed,
receipt-bound Cassius evidence; the verifier rejects approved or
claim-supporting rows that hide failed or unavailable Cassius state. Manual
archival review should still retain the run manifest, command log context,
sandbox overlays, result tables, and all JSONL inputs to aggregation.

## Moving Beyond Smoke

### Smoke To Pilot

Before a pilot:

1. Replace placeholder task rows with reviewed public-source task rows and
   frozen task hashes.
2. Freeze the policy corpus registry hash plus the active-law hash, available
   active-law epoch root, policy-graph hash, trust-region hash, Praxis bundle
   ID/version, and source document refs used by those task rows.
3. Replace the synthetic scored smoke copy with scored pilot result rows from
   the declared rubric and scoring path.
4. Record pilot model backend, model id, decode settings, judge settings if
   used, active-law hash, policy-graph hash, and trust-region hash in the run
   manifest.
5. Export receipt-bound Cassius challenge evidence keyed to each candidate and
   pass it to the gate with `--cassius-challenge-evidence`.
6. Preserve train/held-out/stress split isolation and keep sandbox promotion
   only.

### Pilot To Full Benchmark

Before a full paper run:

1. Freeze the complete benchmark splits, rubrics, aggregate script revision,
   model/config revisions, policy corpus registry hash, and allowed
   policy-corpus versions.
2. Archive the Cassius challenge evidence file and its receipt lineage beside
   the gated candidate artifacts.
3. Add replay/canary artifacts. Canary evidence is exported from scored
   sandbox held-out/stress rows by the AU paper runner. Replay reproducibility
   remains `not_available` until replay rerun rows are supplied.
4. Archive gate receipts, rejection reason codes, sandbox state, held-out and
   stress outputs, CSV tables, and the results summary with the manifest.
5. Review statistical claims separately. This scaffold does not implement
   significance tests.

## Evidence Archive

Archive these files for a paper-evidence candidate run:

- run-specific `MANIFEST.md`
- frozen `policy_corpora/policy_corpus_registry.yaml`, selected
  `policy_corpora/AU_PAPER_SCOPE_BINDING.md`, and their hashes for the AU
  paper run
- exact task JSONL files and hashes
- active-law, available epoch-root, policy-graph, trust-region, Praxis bundle,
  and source-document bindings used by the archived task set
- baseline/scored behavior JSONL files used by failure discovery
- failure cluster, candidate, Cassius challenge-evidence, trust-region gate
  evidence, replay/canary evidence, gate, and sandbox-promotion JSONL files
- sandbox state and overlay files
- held-out and stress JSONL result files
- aggregate CSV tables and `RESULTS_SUMMARY.md`
- verifier output plus replay outputs when replay is available

Smoke outputs cannot support the paper claim: they use placeholder tasks,
deterministic stub behavior, synthetic smoke scoring, unavailable replay
reproducibility, explicit non-claim Cassius `not_required` gates, and
unavailable live Aegis/Senate checks.

## Evidence Tiers

- Smoke bundles prove scaffold wiring only. Archive the smoke manifest,
  placeholder task hashes, emitted pipeline artifacts, verifier output, and
  explicit non-claim markers.
- Pilot bundles use reviewed AU tasks, local model metadata, task/registry
  hashes, raw/scored/audit rows, Cassius evidence for governed approval
  interpretation, gate/sandbox outputs, held-out/stress outputs, and pilot
  readiness/verifier evidence.
- Full paper bundles add the frozen paper taskset, final QA/readiness reports,
  final tables, all Cassius/trust/replay/canary evidence surfaces, containment
  counts, and the exact archive needed to lock paper tables.

Every evidence tier keeps failed tasks, rejected candidates, missing replay
status, and optional API skip metadata visible. A copied bundle must be
re-verified on the receiving box before its paper status is locked.

## Model Comparator Metadata

Real benchmark manifests must separate the primary local lane from any optional
API lane:

- Local reproducible lane: provider `ollama`, backend kind `local`, run family
  `local_reproducible`, default local tag `gemma4:e2b-it-q8_0`, and fallback
  local tag `gemma3n:e2b` when used.
- Optional API portability lane: backend kind `api`, run family
  `api_portability`, configured provider/model ID/version, and frozen API
  config status without storing credentials.

When API configuration is absent, record `api_backend_enabled=false` and a
specific `api_backend_skip_reason`. Do not fail or downgrade the local lane,
do not store API keys, and do not claim cross-model portability from an absent
or skipped API lane.
