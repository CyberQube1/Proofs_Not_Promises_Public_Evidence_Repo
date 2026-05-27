# Civitas 6.7B Public Evidence Pack

This directory is the public evidence package for the Civitas 6.7B AU paper
claim. It is a reproduction-oriented derivative of the locked local evidence
bundle:

`paper_eval_6.7b/repro/runs/au-paper-20260522T023114Z`

The pack is designed to support external inspection of the paper's bounded
systems claim and to make the AU run reproducible for a reviewer who also has
the required Civitas 6.7B/runtime access, local model lane, and source-corpus
access. It includes task rows, scripts, schemas, raw and scored run evidence,
governance artifacts, sandbox evidence, result tables, and summary reports.

The pack does not include production credentials, live production authority,
hosted model-provider credentials, private source documents, or any right to
activate, promote, or deploy candidates. Some files contain internal source
reference URIs and local-lane metadata because those references are part of the
run's evidence chain.

## What This Pack Supports

- AU finance paper-evidence lane only.
- Local Ollama/Gemma execution lane only.
- 250 curated AU task rows: 100 training failure rows, 100 held-out rows, and
  50 stress rows.
- Eight generated governed candidates.
- Eight sandbox-only approvals/promotions.
- Cassius-required and Cassius-passed approvals: 8/8.
- Zero production mutation.
- Zero unauthorized promotion.
- Receipt completeness: 1.000000.
- Held-out unsupported-claim rate reduction: 0.110000 to 0.057500.
- Mixed behavioral interpretation, including unfavorable control-action and
  regression outcomes.

## What This Pack Does Not Support

- API portability.
- EU results.
- Production promotion.
- Live production self-modification.
- Replay reproducibility.
- Statistical significance.
- Proven gate selectivity.
- Broad behavioral superiority.
- General safe autonomous self-improvement.

## Directory Layout

- `tables/`: public locked result tables used by the manuscript.
- `summaries/`: redacted QA, readiness, manifest, and result summaries.
- `run_evidence/`: complete locked AU run evidence, including inputs, raw
  outputs, scored rows, governance artifacts, sandbox records, run summaries,
  and result tables.
- `taskset/`: AU finance task rows, task manifest, leakage review, and source
  map used by the locked run.
- `scripts/`: evaluation, reproduction, and taskset scripts needed to inspect
  or rerun the pipeline in a compatible Civitas 6.7B checkout.
- `schemas/`: JSON schemas for task, candidate, governance, scoring, and
  sandbox evidence surfaces.
- `governance/`: redacted governance artifact projections for quick review
  without opening the full run evidence.
- `validation/`: taskset, leakage, and scoring validation materials.
- `verification/`: public-pack verification helper.
- `method_docs/`: runbooks, dataset plans, evaluation plans, claim-boundary
  notes, and reproducibility notes used to produce the paper evidence lane.
- `manuscript_workspace/`: manuscript drafts, paper QA notes, bibliography
  notes, and the JAIR LaTeX source/build artifacts.
- `readiness_workspace/`: paper-ready tracker, QA notes, proof-bundle planning,
  and handoff material.
- `legacy_results/`: earlier pilot, smoke, and table outputs retained for
  historical inspection; the paper result uses the locked AU run under
  `run_evidence/`.
- `legacy_artifacts/`: earlier artifact placeholders or pilot artifacts
  retained for workspace completeness.
- `policy_corpora/`: AU corpus scope bindings, registry files, discovery
  report, and validation helpers.
- `top_level_files/`: root-level class files, prompt notes, and README material
  from the paper-evaluation workspace.
- `metadata/`: claim-to-evidence notes and locked-value notes from the paper
  workspace.
- `excluded_hashes/`: SHA-256 hash manifest for source files that were not
  released publicly.
- `paper/`: reserved for the release-approved manuscript PDF or citation
  metadata. The current package does not include a manuscript PDF.

## Source Bundle

The source bundle was extracted from repository commit:

`0af6f33f6b341e80ec878e88d707892ff1f48250`

The public pack now carries the locked AU task rows and run evidence needed to
inspect the reported AU values. It does not carry private source documents,
production services, credentials, hosted-model access, or the Civitas runtime
itself.

## Review Status

Status: reproduction-oriented release-candidate evidence pack.

Remaining human release checks:

- Confirm that task rows and generated outputs are acceptable for the intended
  public archive.
- Confirm that source reference URIs are acceptable to expose as evidence
  pointers without granting source-bucket access.
- Confirm final manuscript PDF/citation metadata before uploading to an
  external archive.
- Confirm whether the external archive should include the full
  `manuscript_workspace/` history or only the final JAIR source/PDF.
