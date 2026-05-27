# Prompt 12B Authority Binding QA

## Verdict

`PASS`

The selected AU authority lane is ready to bound dataset curation. This review
does not make task rows or model results paper evidence; it closes the registry
and hash-mapping ambiguity that would poison those later artifacts.

## Findings

No blocking finding remains after Prompt 12A.

The selected paper corpus id is `au_finance_paper_scope`. It binds the frozen
Praxis `baseline-au-finance` source lane to one selected Aegis
active-governance artifact and carries structured active-law, graph, and
trust-region fields. The lane has no `PENDING_*` values in its selected claim
fields, and the validator fails if that regresses.

## Checks

| Check | Result | Evidence |
| --- | --- | --- |
| Selected AU paper registry lane exists | PASS | `policy_corpora/policy_corpus_registry.yaml` |
| Praxis baseline ref, release id, version, and artifact URI are structured | PASS | `au_finance_paper_scope` entry |
| Aegis active-governance bundle id/version are structured | PASS | `aegis_active_governance_bundle_id` and `aegis_active_governance_bundle_version` |
| `active_law_hash` mapping is explicit | PASS | `policy_corpora/AU_PAPER_SCOPE_BINDING.md` |
| `policy_graph_hash` mapping is explicit | PASS | `policy_corpora/AU_PAPER_SCOPE_BINDING.md` |
| `trust_region_hash` mapping is explicit | PASS | `policy_corpora/AU_PAPER_SCOPE_BINDING.md` |
| APRA/ASIC remain baseline-contained source subsets | PASS | Registry scope notes and paper-ready docs |
| Standalone APRA/ASIC/EU placeholders do not imply selected-lane readiness | PASS | Non-selected lanes remain pending/discovery-only and docs direct paper tasks to the selected lane |
| AU authority validator passes | PASS | `python3 paper_eval_6.7b/policy_corpora/validate_au_paper_scope.py` |
| Readiness pilot fixture accepts selected AU lane | PASS | `python3 -B -m unittest discover -s paper_eval_6.7b/repro -p test_paper_readiness.py` |

## Claim Boundary

The authority QA accepts only this paper scope:

> Civitas 6.7B AU finance evaluation using the frozen Praxis AU finance
> baseline and APRA/ASIC source references contained inside that baseline,
> bound to the selected Aegis active-governance artifact for claim task
> provenance.

It does not accept:

- a standalone APRA active corpus claim
- a standalone ASIC active corpus claim
- an EU lane
- a claim that a registry binding alone is behavioral evidence

## Residual Risk

Dataset curation now becomes the main paper risk. Task rows must use
`au_finance_paper_scope`, copy the selected AU authority hashes into claim
metadata, use exact allowed AU source refs, and pass source-map and leakage
review before any final taskset hash is frozen.
