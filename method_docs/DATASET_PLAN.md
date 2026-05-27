# Dataset Plan

## Goal

Build a benchmark for recurring governed-agent failure patterns in the Civitas
6.7B governed self-improvement sandbox. The benchmark should test whether
Civitas detects, improves, and preserves control behavior over time; it should
not collapse into generic policy Q&A.

## Current Starter Files

| File | Role | Current state |
| --- | --- | --- |
| `tasks/schema/task.schema.json` | JSONL task-row contract | Initial Prompt 1 schema |
| `tasks/train_failures_100.jsonl` | Failure discovery and candidate-generation input | Synthetic placeholders only |
| `tasks/heldout_eval_100.jsonl` | Held-out outcome measurement | Synthetic placeholders only |
| `tasks/stress_50.jsonl` | Adversarial and safety stress measurement | Synthetic placeholders only |
| `policy_corpora/policy_corpus_registry.yaml` | Linkage registry for Praxis/Aegis corpus refs | AU finance baseline plus ASIC/APRA/EU lane status |

The starter rows are marked as placeholders. They are safe scaffolding for
parser and rubric work, not final benchmark evidence and not paper results.

## Task Buckets

| Bucket | Failure pattern under test |
| --- | --- |
| `unsafe_action_bait` | Pressure to perform, approve, recommend, or bypass a controlled unsafe action. |
| `unsupported_compliance_claim` | Pressure to state compliance or assurance without sufficient allowed evidence. |
| `ambiguous_escalation` | Missing facts or unclear authority where the correct control posture must be selected. |
| `policy_conflict_or_supersession` | Conflict, outdated source use, or unresolved supersession in the policy basis. |
| `adversarial_paraphrase` | Reworded requests that attempt to hide a prohibited or unsupported control outcome. |
| `repeat_failure_pattern` | Recurrence of a known governed-agent failure class from the failure-discovery lane. |

These six families are the required Paper Prompt B families because they test
governed failure recurrence and control posture, not generic policy recall.
`paper/TASK_DESIGN_GUIDE.md` records how the same families must stay split
isolated during task authoring. Multi-turn operational continuity, cross-agent
delegation boundary, active-law mismatch or stale-law bait, and model-router
misuse remain optional later families until the task, scorer, and evidence
lanes support them.

## Task Contract

Each row should remain a flat JSON object validated by
`tasks/schema/task.schema.json`. The task contract binds:

- The failure bucket and split.
- The jurisdiction and versioned policy corpus.
- Allowed source references and active-law hash.
- Optional registry-backed active-law epoch, policy-graph, trust-region,
  Praxis-bundle, and exact source-document refs when available.
- The prompt and scenario evidence boundary.
- The expected governed control action and policy basis.
- Success criteria, failure modes, and scoring notes.

This keeps runner ingestion simple while preserving enough policy provenance for
real public corpus tasks. Prompt 10B adds those optional provenance fields to
`tasks/schema/task.schema.json`; the current placeholder rows remain valid
without them.

## Policy Corpus Registry Linkage

`policy_corpus_id` should match a `corpus_id` in
`policy_corpora/policy_corpus_registry.yaml` for every real benchmark row. The
registry is linkage-only: it freezes references into Praxis/Aegis artifacts but
does not ingest a policy document into Civitas and does not make pending active
law fields authoritative.

Each real task row must still declare its own evidence boundary:

- `policy_source_refs` lists the allowed source or corpus refs for scoring.
- `source_document_refs`, when available, pins exact Praxis/Aegis document or
  index artifact refs used for provenance.
- `active_law_hash` remains required by the task contract.
- `active_law_epoch_id`, `policy_graph_hash`, `trust_region_hash`, and
  `praxis_bundle_id` should be copied only from a frozen registry or scoped
  active-governance binding that the run manifest archives.

Do not turn registry placeholders into task evidence for claim-supporting
pilot or full benchmark rows.

## AU Paper Scope

The first paper-evidence taskset must use `au_finance_paper_scope`, not the
placeholder rows and not unresolved standalone ASIC, APRA, or EU lanes.
`au_finance_paper_scope` keeps the frozen Praxis `baseline-au-finance` source
material and the selected Aegis active-governance bindings together for the AU
paper run.

For every claim-supporting AU row:

- set `policy_corpus_id=au_finance_paper_scope`
- keep APRA CPS 234 and ASIC RG refs as source refs contained by the AU
  baseline
- copy `active_law_hash`, `active_law_epoch_id`, `policy_graph_hash`,
  `trust_region_hash`, and `praxis_bundle_id` from the selected AU paper lane
  rather than inventing task-local values
- preserve exact `policy_source_refs` and `source_document_refs` used by the
  task

`policy_corpora/AU_PAPER_SCOPE_BINDING.md` defines the AU mapping from harness
fields to Aegis active-governance fields. EU is out of the first paper taskset.

## AU Finance V1 Curation Controls

`tasks/au_finance_v1/` is the bounded final-task lane for the first AU paper
run. It adds controls before final rows are frozen:

- `AU_SOURCE_MAP.yaml` limits task provenance to APRA CPS 234 and ASIC RG 234,
  RG 271, and RG 274 source indexes contained by the frozen AU finance
  baseline.
- `TASK_AUTHORING_CONTROLS.md` defines the governed-agent task review rules.
- `TASKSET_MANIFEST_TEMPLATE.md` and `LEAKAGE_REVIEW_TEMPLATE.md` define the
  hash and split-review records required before the taskset is evidence.
- `validate_au_taskset.py` validates selected-corpus provenance, source-map
  membership, required authority fields, `synthetic_placeholder=false`, split
  labels, duplicate prompts, and cross-split near-duplicate prompts.

The task JSON schema now accepts `synthetic_placeholder`; final AU paper rows
must set it to `false`. Root placeholder smoke rows may remain schema-valid,
but the AU validator rejects them.

The current AU v1 folder also contains the frozen post-QA-C `100/100/50`
taskset plus `TASKSET_MANIFEST.md`, `LEAKAGE_REVIEW.md`, and
`TASK_AUTHORING_NOTES.md`. Those rows are source-map valid, hash-recorded, and
dataset-QA accepted for the real execution lane.

## Future Corpus Onboarding

Real tasks should be added only after a corpus snapshot is reviewable and
public-source provenance is recorded.

1. Select a registry entry for the intended corpus lane and resolve
   any placeholders needed for the planned claim. Do not include sensitive
   private policy material or confidential customer facts.
2. Assign the task `policy_corpus_id` from the registry `corpus_id`, record
   allowed `policy_source_refs` and exact `source_document_refs`, and freeze
   the task `active_law_hash` from the active source snapshot used by the task.
3. Record available `active_law_epoch_id`, `policy_graph_hash`,
   `trust_region_hash`, and `praxis_bundle_id` bindings without fabricating
   unavailable values.
4. Record supersession, effective-date, and ambiguity notes before writing
   tasks that depend on active versus archived policy status.
5. Convert reviewed governed-agent failure patterns into task rows with an
   expected control action. Avoid tasks whose only challenge is recalling a
   policy answer.
6. Review `expected_policy_basis`, success criteria, and failure modes against
   the public source snapshot and the scoring rubric.
7. Validate task rows against the schema and record registry hash, corpus,
   rubric, split, and review versions before using them in a scored run.

## Split Discipline

- `train_failures` may drive recurring-failure discovery and candidate
  generation.
- `heldout_eval` must stay sealed from candidate drafting, critique text, gate
  tuning, and threshold selection.
- `stress` probes adversarial pressure, policy conflict, and safety boundary
  behavior. It must be reported and must not be silently recycled into training
  evidence.
- Near-duplicate prompts and paraphrase families should not leak a held-out or
  stress answer pattern into `train_failures`.

The paper protocol treats a split leak as a claim blocker. Pilot and full runs
must retain task manifests, task hashes, and leakage review notes before
candidate generation begins; the held-out and stress files cannot be changed
quietly after candidate content or gate tuning has observed the run.

## Curation Guardrails

- Keep placeholder and final rows visibly distinguishable.
- Do not fabricate final benchmark claims from placeholder rows.
- Use public material or approved synthetic scaffolding only.
- Prefer control-action tasks that expose unsafe action, unsupported claim,
  escalation, refusal, evidence, conflict, or repeat-failure behavior.
- Preserve policy provenance so later adjudicators can distinguish unsupported
  model claims from a task authoring error.
