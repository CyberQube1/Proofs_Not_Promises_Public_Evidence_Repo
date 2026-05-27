# AU Finance Paper Scope Binding

`au_finance_paper_scope` is the selected claim-supporting registry lane for
the Australian finance Civitas 6.7B paper evidence run.

## Authority Model

The lane combines two source-of-truth layers without copying policy documents:

1. The frozen Praxis AU finance baseline carries the AU source material,
   including APRA CPS 234 and ASIC RG source indexes contained inside the
   baseline.
2. The selected Aegis active-governance record supplies the active-law epoch,
   constitutional graph, and trust-region bindings used for the paper run.

## Frozen Praxis Baseline

| Binding | Value |
| --- | --- |
| Praxis corpus ref | `baseline-au-finance` |
| Baseline release id | `br_1e6d12c254a3` |
| Baseline fingerprint/version | `10cf217f862c` |
| Artifact URI | `s3://praxis-governance/baselines/baseline-au-finance/bundles/10cf217f862c` |
| Governance prefix | `baselines/baseline-au-finance/bundles/10cf217f862c` |

The APRA and ASIC task source refs used by the paper must remain references
inside this baseline. They are not standalone active corpora.

## Selected Aegis Active Governance

Source artifact:

```text
/home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/smc_94c4ce2decc3494c612a785e.json
```

| Binding | Value |
| --- | --- |
| Bundle id | `pb_7d2cdbf37fef9037b12cb87888728156` |
| Bundle fingerprint/version | `3ee7b6741b35` |
| Active-law epoch id | `ale_36e8fca1efdb131047beb98f9fa426a4` |
| Active-law epoch root | `sha256:2cc5fdbc5fa2a1dad655079eeb7b140970acabe9c54bf86f3b8931b931d9f91a` |
| Sequence root | `sha256:b37b1d2ee2ecc6c5958fa49ddbbc52d6b84894f6b0987f57ef06fc3513ce9046` |
| Sequence index | `2` |
| Active-law state | `active` |
| Constitutional graph SHA3-512 | `8acf1fc1023cb85f56a5948392655424abd6dd32c985de891f697f830b05edd7e451930467e89d45930009510bd20460385e34179745ba146f33cae1c01ff40d` |
| Trust-region SHA3-512 | `fc01b58453552a49a22d100c31480d521969925d5abba93f38f525451f733c52bb1b2ddbdbbb26abf0aae5e747806403c4542848db9add91f292f87fc911c5d7` |
| Activated at | `2026-05-10T00:12:38.767412411Z` |

## Harness Field Mapping

The paper harness uses generic fields. In this AU lane they mean:

| Harness field | AU paper mapping | Reason |
| --- | --- | --- |
| `active_law_hash` | `active_law_epoch_root` | The selected Aegis active-governance record exposes the active epoch root as the authority digest for the scoped active law. |
| `policy_graph_hash` | `constitutional_graph_sha3_512` | The selected active governance record binds the constitutional governance graph; this lane uses that graph digest as the policy-graph digest required by the paper harness. |
| `trust_region_hash` | `trust_region_sha3_512` | The selected active trust-region digest is the gate-time trust binding for the paper scope. |

Paper tasks should copy these mapped values from
`policy_corpus_registry.yaml`. A task author must not substitute the older
unresolved baseline placeholder lane or invent a task-local hash.

The registry carries the Aegis active-governance artifact ref, bundle id, bundle
version, and constitutional graph ref as explicit fields so validation can fail
if the selected authority binding regresses into prose-only evidence notes.

## Claim Boundary

- The AU paper run may cite APRA and ASIC material contained in the frozen AU
  finance baseline.
- The AU paper run does not claim separate APRA or ASIC active-law corpora.
- EU remains out of the selected paper lane.
- The registry is linkage metadata. It does not publish or activate bundles.
