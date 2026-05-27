# Paper Evidence Readiness

`paper_eval_6.7b/repro/CHECK_PAPER_READINESS.sh` is the final pre-run
readiness gate for the Civitas 6.7B governed self-improvement evaluation. It
audits the scaffold and selected input artifacts. It does not run benchmark
tasks, create scientific evidence, promote candidates, or mutate production.

## Readiness States

| State | Meaning |
| --- | --- |
| `smoke_ready` | The placeholder smoke scaffold can exercise the research pipeline with explicit non-claim boundaries. |
| `pilot_ready` | Selected non-placeholder pilot tasks are registry-linked and can enter a reproducible pilot run after governed approval evidence is loaded where needed. |
| `paper_evidence_ready` | Selected curated task, Cassius, sandbox, containment, model, and reproducibility bindings are complete enough to start a paper-evidence run. |
| `not_ready` | At least one blocking claim-boundary, corpus, Cassius, API, sandbox, or reproducibility requirement failed. |

Smoke readiness deliberately allows placeholder tasks, deterministic stub
metadata, Cassius `not_required`, skipped API portability, pending policy refs,
and unresolved EU registry status. Its reports must keep
`claim_supporting_run=false`, deny paper-evidence claims, deny a Cassius-backed
governed claim, and deny an API portability claim.

Pilot readiness is narrower. The selected task rows must be non-placeholder,
task `policy_corpus_id` values must link to the policy corpus registry, linked
registry refs and task provenance for the selected claim lane must not retain
`PENDING_*` values, and a reproducibility run directory must be selected.
Pilot readiness does not promise full sample size, an EU lane, or an API lane.
Cassius evidence may be loaded after pilot setup, but governed claim-supporting
approval still cannot proceed without passed receipt-bound Cassius evidence.

Paper-evidence readiness is fail-closed. It requires curated task rows, linked
registry values without pending claim refs, active-law bindings, any claimed
policy-graph and trust-region hashes, receipt-bound Cassius evidence JSONL,
sandbox-only containment, frozen comparator metadata, and a reproducibility
run that passes `VERIFY_RESULTS.sh`. A skipped API lane is allowed only when
API portability is excluded from claims.

## Usage

Run from the repository root:

```bash
bash paper_eval_6.7b/repro/CHECK_PAPER_READINESS.sh
```

Smoke mode is the default. Select explicit inputs for pilot or paper review:

```bash
bash paper_eval_6.7b/repro/CHECK_PAPER_READINESS.sh \
  --mode pilot \
  --tasks path/to/pilot_tasks.jsonl \
  --registry paper_eval_6.7b/policy_corpora/policy_corpus_registry.yaml \
  --run-dir path/to/pilot_repro_run

bash paper_eval_6.7b/repro/CHECK_PAPER_READINESS.sh \
  --mode paper \
  --tasks path/to/curated_train.jsonl \
  --tasks path/to/curated_heldout.jsonl \
  --tasks path/to/curated_stress.jsonl \
  --cassius-evidence path/to/cassius_challenge_evidence.jsonl \
  --run-dir path/to/verified_repro_run
```

Use `--claim-api-portability --api-backend-enabled` only when an actual API
lane is configured and archived. Without those flags the report records the
API path as excluded/skipped rather than failed local readiness.

## Reports

The checker writes:

- `paper_eval_6.7b/repro/readiness_report.json`
- `paper_eval_6.7b/repro/readiness_report.md`

The JSON is the machine-readable contract. It includes `readiness_status`,
`checked_at`, input paths, all `checks`, `blocking_gaps`, `warnings`,
`allowed_claims`, `disallowed_claims`, and `next_required_actions`. The
Markdown report renders the same result for review and keeps the claim boundary
visible beside the status.

## Checks

The checker inspects:

- policy corpus registry existence and required `au_finance_baseline`, `asic`,
  `apra`, and `eu` entries
- unresolved `PENDING_*` refs in the selected task and linked registry lane
- task file existence, JSONL parsing, task schema validation, placeholder
  metadata, and registry corpus linkage
- Cassius gate/schema/verifier fail-closed contract plus receipt-bound Cassius
  evidence JSONL for paper mode
- reproducibility manifest/verifier surfaces, selected run manifest, run
  containment counts, sandbox-only schema/state markers, and paper-mode
  verifier result
- comparator metadata support, frozen paper-mode model markers in the selected
  run manifest, and whether an API portability claim was made while the
  optional API backend remains skipped

## Corpus And Claim Boundaries

The selected first paper lane is `au_finance_paper_scope`. It freezes Praxis
AU finance baseline refs and the selected Aegis active-governance bindings for
the AU run. ASIC/APRA refs remain baseline-contained framing; EU remains out of
the selected taskset. The readiness gate reports those boundaries; it does not
fill missing hashes, copy policy documents, or turn a placeholder registry lane
into active policy authority.

For this lane the task `active_law_hash` copies the selected active-law epoch
root, `policy_graph_hash` copies the selected active constitutional-graph
digest, and `trust_region_hash` copies the selected active trust-region digest.
`policy_corpora/AU_PAPER_SCOPE_BINDING.md` records the mapping.

Smoke outputs remain harness evidence only. Pilot and paper runs must archive
their selected task files, policy corpus registry hash, active-law and
trust-region bindings, model metadata, Cassius evidence, sandbox receipts, and
reproducibility verifier outputs before their results can be reviewed as claim
supporting.
