# Policy Corpora Registry

`policy_corpus_registry.yaml` is the Civitas 6.7B paper-eval linkage registry.
It points task rows at frozen Praxis and Aegis governance artifact references.
It does not ingest policy documents into Civitas and it is not an activation or
publication path.

## Authority Boundary

- Praxis remains the policy ingestion source of truth.
- Aegis active-governance refs remain the active-law source of truth.
- Registry entries with pending active-law fields are not active-law claims.
- `loaded_in_praxis` means discovered Praxis bundle metadata exists. It does
  not mean the entry is `active_in_aegis`.
- `au_finance_paper_scope` is the selected AU paper lane. It binds the frozen
  AU Praxis baseline to selected Aegis active-governance evidence.
- ASIC and APRA currently name source indexes contained by the AU finance
  baseline found in Prompt 10A. Dedicated corpus authority is still pending.

## Entry Status

| Entry | Current registry status | Meaning |
| --- | --- | --- |
| `au_finance_paper_scope` | `active_in_aegis` | Selected AU paper lane with frozen Praxis baseline refs and selected Aegis active bindings. |
| `au_finance_baseline` | `loaded_in_praxis` | Prompt 10A found a frozen Praxis baseline release and governance prefix. |
| `asic` | `discovered_unverified` | Prompt 10A found baseline-contained ASIC source index refs only. |
| `apra` | `discovered_unverified` | Prompt 10A found baseline-contained APRA CPS 234 index refs only. |
| `eu` | `planned` | Prompt 10A found no resolved EU source refs in the inspected targets. |

## Task Linkage

Real benchmark tasks should set `policy_corpus_id` to a registry `corpus_id`,
keep the exact allowed `policy_source_refs`, and populate optional task
provenance fields when the registry or selected Aegis active-law ref provides
them:

- `active_law_epoch_id`
- `policy_graph_hash`
- `trust_region_hash`
- `praxis_bundle_id`
- `source_document_refs`

The registry never substitutes for task-level allowed evidence. A task must
still declare which source refs its prompt and scoring basis may use.

For the selected AU paper lane, use `AU_PAPER_SCOPE_BINDING.md` for the
field mapping:

- task `active_law_hash` copies the selected `active_law_epoch_root`
- task `policy_graph_hash` copies the selected
  `constitutional_graph_sha3_512` binding exposed as registry
  `policy_graph_hash`
- task `trust_region_hash` copies the selected active trust-region digest

Do not author paper task rows against the unresolved baseline, standalone APRA,
standalone ASIC, or EU lanes.

## Files

- `DISCOVERY_REPORT.md` records Prompt 10A read-only discovery and confidence.
- `AU_PAPER_SCOPE_BINDING.md` records the selected AU paper authority mapping.
- `discovered_policy_refs.draft.yaml` preserves the discovery draft.
- `policy_corpus_registry.yaml` is the Prompt 10B registry for dataset and
  reproducibility binding.
- `validate_au_paper_scope.py` fails if selected AU claim bindings regress to
  pending values or lose APRA/ASIC source refs.
