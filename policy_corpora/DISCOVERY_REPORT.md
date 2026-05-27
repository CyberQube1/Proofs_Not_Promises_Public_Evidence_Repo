# Civitas 6.7B Policy Corpus Reference Discovery

## Scope

Prompt 10A is a read-only discovery pass for Praxis and Aegis references that a
later Civitas 6.7B paper-eval registry may point at without copying policy
documents. The pass inspected published bundle metadata, active-governance
metadata, bundle index filenames, and API route docs. It did not call
authenticated APIs, publish bundles, activate bundles, copy policy documents, or
change production state.

## Search Commands Run

The initial broad scans were intentionally narrowed after confirming that
compiled published bundle artifacts contain policy internals. The report uses
metadata and index references from the narrower scans.

```bash
rg --files /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance /home/spqr-admin/praxis-admin/runtime/mesh-judged /home/spqr-admin/praxis-admin/engine/dist /home/spqr-admin/praxis-admin/backend/storage/published_bundles
rg -n -i "ASIC|APRA|CPS 234|European|\bEU\b|baseline-au-finance|baseline-au-demo|governance[_ -]bundle|bundle_id|policy_bundle_id|praxis_bundle|corpus_id|active_law|active law|active_law_epoch|law_hash|policy_graph|trust_region|trust_region_sha3_512|published_root|published_minio_prefix|baseline_minio_prefix|source_bundle_root|signed canonical bundle root|praxis-governance|praxis-runtime|praxis-artifacts|MinIO|S3|bucket|object key" /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance /home/spqr-admin/praxis-admin/runtime/mesh-judged /home/spqr-admin/praxis-admin/engine/dist /home/spqr-admin/praxis-admin/backend/storage/published_bundles
rg -n "/api/policy-bundles/orgs/\{org_id\}|/api/policy-bundles/\{bundle_id\}|/api/policy-bundles/\{bundle_id\}/log|/api/runtime/agents/\{agent_id\}/policy|/api/runtime/bundles/\{bundle_id\}/log|/api/runtime/bundles/\{bundle_id\}/artifacts/\{artifact_path\}|policy-bundles|runtime/bundles" /home/spqr-admin/praxis-admin
```

```bash
jq -c '{file:input_filename,schema,policy_ref_id,bundle_id,bundle_version,version,org_id,tenant_id,published_root,published_minio_prefix,source_bundle_root,trust_region_ref,trust_region_sha3_512,active_law_epoch_id,active_law_epoch_root,active_law_epoch_sequence_root,active_law_epoch_sequence_index,active_law_state}' /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/policy-59a029a9874a79e6.json /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/policy-b305d36e9ba180f2.json /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/smc_94c4ce2decc3494c612a785e.json /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/policy-62a592c5b516a0e3.json
sed -n '100,145p' /home/spqr-admin/praxis-admin/runtime/mesh-judged/smc_94c4ce2decc3494c612a785e.json
sed -n '1,180p' /home/spqr-admin/praxis-admin/engine/dist/manifest.json
sed -n '1,180p' /home/spqr-admin/praxis-admin/engine/dist/last_build.json
sed -n '1,220p' /home/spqr-admin/praxis-admin/engine/dist/policy/regulatory_manifest.baseline.json
sed -n '1,120p' /home/spqr-admin/praxis-admin/engine/dist/policy/trust_region.yaml
rg --files /home/spqr-admin/praxis-admin/engine/dist/index/by_stem
rg -n "GOVERNANCE_STORAGE_BUCKET|RUNTIME_STORAGE_BUCKET|S3_BUCKET|MINIO|MinIO|bucket" /home/spqr-admin/praxis-admin/docker-compose.yml /home/spqr-admin/praxis-admin/docker-compose.demo.yml
```

```bash
jq -c '{file:input_filename,keys:keys}' /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/bundle_manifest.json /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/manifest.json /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/publication.json /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/index/active_docs.baseline-au-finance.json
jq -c '{schema,law_bundle_schema,bundle_id,bundle_version,bundle_root_sha3_512,published_fingerprint,scope_kind,tenant_id,org_id,baseline_slug,baseline_release_id,document_entry_count:(.document_entries|length)}' /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/manifest.json
jq -c '{schema,bundle_id,bundle_version,bundle_root_sha3_512,published_fingerprint,scope_kind,activation_status,minio_bucket,minio_prefix,bundle_ref,manifest_ref,publication_ref,active_ref,archive_ref,verification_status,signature_status,document_ref_count:(.document_refs|length)}' /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/publication.json
jq -c '.document_entries[] | {path,ref,sha3_512,kind,title,filename}' /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/manifest.json
jq -c '.docs[] | {id,title,filename,source,jurisdiction,scope,hash,hash_alg}' /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/index/active_docs.baseline-au-finance.json
```

```bash
find /home/spqr-admin/praxis-admin/engine/dist/index/by_stem /home/spqr-admin/praxis-admin/backend/storage/published_bundles -type f -iname '*europe*'
find /home/spqr-admin/praxis-admin/engine/dist/index/by_stem /home/spqr-admin/praxis-admin/backend/storage/published_bundles -type f -iname '*gdpr*'
rg -n -i "\bEU\b|European|GDPR" /home/spqr-admin/praxis-admin/engine/dist/manifest.json /home/spqr-admin/praxis-admin/engine/dist/last_build.json /home/spqr-admin/praxis-admin/engine/dist/policy/regulatory_manifest.baseline.json /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance /home/spqr-admin/praxis-admin/runtime/mesh-judged/smc_94c4ce2decc3494c612a785e.json
rg -n "active_law_hash|law_hash|active_law_epoch|policy_graph_hash|policy_graph" /home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/policy-59a029a9874a79e6.json /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/manifest.json /home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/governance/publication.json /home/spqr-admin/praxis-admin/engine/dist/manifest.json
rg -n "S3_BUCKET|ARTIFACT_STORAGE_BUCKET|GOVERNANCE_STORAGE_BUCKET|RUNTIME_STORAGE_BUCKET" /home/spqr-admin/praxis-admin/docker-compose.yml /home/spqr-admin/praxis-admin/docker-compose.demo.yml /home/spqr-admin/praxis-admin/backend /home/spqr-admin/praxis-admin/docs /home/spqr-admin/praxis-admin/README.md
```

## Directories And Files Inspected

- `/home/spqr-admin/praxis-admin/runtime/mesh-judged/active-governance/*.json`
- `/home/spqr-admin/praxis-admin/runtime/mesh-judged/*.json`, with the Aegis
  paper runtime bundle ref inspected directly at
  `smc_94c4ce2decc3494c612a785e.json`
- `/home/spqr-admin/praxis-admin/engine/dist/manifest.json`
- `/home/spqr-admin/praxis-admin/engine/dist/last_build.json`
- `/home/spqr-admin/praxis-admin/engine/dist/policy/regulatory_manifest.baseline.json`
- `/home/spqr-admin/praxis-admin/engine/dist/policy/trust_region.yaml`
- `/home/spqr-admin/praxis-admin/engine/dist/index/by_stem/`
- `/home/spqr-admin/praxis-admin/backend/storage/published_bundles/`
- AU finance published bundle metadata under
  `/home/spqr-admin/praxis-admin/backend/storage/published_bundles/baselines/baseline-au-finance/bundles/10cf217f862c/`
- `/home/spqr-admin/praxis-admin/docker-compose.yml`
- `/home/spqr-admin/praxis-admin/docker-compose.demo.yml`
- API docs/router evidence in Praxis diagnostics and backend router files:
  `diagnostics/diagnose_20260219T020411Z.txt`,
  `backend/app/routers/policy_bundles.py`,
  `backend/app/routers/runtime.py`, and
  `backend/app/routers/runtime_artifacts.py`

## Candidate API Routes

Praxis diagnostics list the requested lookup surfaces, and the router files
confirm the policy-bundle and runtime route prefixes:

| Route | Discovery source | Intended read use | Confidence |
| --- | --- | --- | --- |
| `/api/policy-bundles/orgs/{org_id}` | diagnostics and `policy_bundles.py` | bundle listing for an org | high |
| `/api/policy-bundles/{bundle_id}` | diagnostics and `policy_bundles.py` | bundle lookup | high |
| `/api/policy-bundles/{bundle_id}/log` | diagnostics and `policy_bundles.py` | bundle build log | high |
| `/api/runtime/agents/{agent_id}/policy` | diagnostics and `runtime.py` | runtime policy lookup | high |
| `/api/runtime/bundles/{bundle_id}/log` | diagnostics and `runtime_artifacts.py` | runtime bundle log | high |
| `/api/runtime/bundles/{bundle_id}/artifacts/{artifact_path}` | diagnostics and `runtime_artifacts.py` | runtime artifact fetch | high |

No authenticated API route was called in this prompt.

## Candidate Praxis Corpus Refs

| Item | Candidate value | Evidence | Confidence |
| --- | --- | --- | --- |
| AU finance baseline corpus slug | `baseline-au-finance` | baseline active-governance ref, baseline bundle manifest, publication metadata | high |
| AU finance bundle ref | `bundles/10cf217f862c` | baseline `LATEST`, publication `bundle_ref`, Aegis paper `baseline_binding` | high |
| AU finance governance artifact URI | `s3://praxis-governance/baselines/baseline-au-finance/bundles/10cf217f862c` | publication `minio_bucket` and `minio_prefix` | high |
| ASIC source subset | RG 234, RG 271, RG 274 by-stem index refs inside the AU finance baseline | baseline governance manifest document entries | medium |
| APRA source subset | APRA CPS 234 by-stem index ref inside the AU finance baseline | baseline governance manifest document entries and active-doc filenames | high |
| EU source subset | none found in inspected target metadata and index filenames | EU/GDPR filename and metadata searches returned no hit | low |

The ASIC and APRA hits are contained by the AU finance baseline. This discovery
does not establish standalone Praxis corpus refs for dedicated ASIC or APRA
paper-eval corpora.

## Candidate Governance Bundle IDs

| Candidate bundle ID | Scope discovered | Confidence | Registry note |
| --- | --- | --- | --- |
| `br_1e6d12c254a3` | platform baseline `baseline-au-finance` | high | recommended AU finance baseline bundle ID |
| `br_3aaeb4d7f600` | platform baseline `baseline-au-demo` | medium | demo baseline, not recommended for the finance paper registry |
| `pb_7d2cdbf37fef9037b12cb87888728156` | Aegis paper org active-governance bundle | high | useful baseline-binding and active-law context, not the baseline release ID |
| `pb_e40e29654d80cd43782340b954e0109a` | demo org active-governance bundle | low | out of Prompt 10A registry scope |
| `pb_ebd1e4793f84c3f457fb541e8e1a07e3` | demo scoped active-governance candidate | low | out of Prompt 10A registry scope |
| `pb_7610ee383790046c32a17c8f10933722` | demo-acme active-governance bundle | low | out of Prompt 10A registry scope |

## Candidate Baseline Release IDs

| Baseline | Release ID | Bundle version | Confidence |
| --- | --- | --- | --- |
| `baseline-au-finance` | `br_1e6d12c254a3` | `10cf217f862c` | high |
| `baseline-au-demo` | `br_3aaeb4d7f600` | `eaa28a5c0bb8` | medium |

## Candidate S3 And MinIO Locations

| Item | Candidate value | Confidence |
| --- | --- | --- |
| Published governance bucket | `praxis-governance` | high |
| Runtime bucket | `praxis-runtime` | high |
| General artifact bucket | `praxis-artifacts` | high |
| AU finance governance prefix | `baselines/baseline-au-finance/bundles/10cf217f862c` | high |
| AU finance local published root | `/app/storage/published_bundles/baselines/baseline-au-finance` | high |
| Aegis paper org published prefix | `orgs/os_2ba447dd80bd94f1/bundles/3ee7b6741b35` | medium |

The general artifact bucket is separate from the published governance bucket for
the baseline publication metadata inspected here.

## Candidate Active-Law Epoch Refs

The AU finance baseline active-governance ref does not expose
`active_law_epoch_*` fields. The Aegis paper org ref that binds that baseline
does expose active-law epochs:

| Ref file | Epoch ID | Epoch root | Sequence root | Confidence |
| --- | --- | --- | --- | --- |
| `active-governance/smc_94c4ce2decc3494c612a785e.json` | `ale_36e8fca1efdb131047beb98f9fa426a4` | `sha256:2cc5fdbc5fa2a1dad655079eeb7b140970acabe9c54bf86f3b8931b931d9f91a` | `sha256:b37b1d2ee2ecc6c5958fa49ddbbc52d6b84894f6b0987f57ef06fc3513ce9046` | medium |
| `active-governance/policy-62a592c5b516a0e3.json` | `ale_43b3a1ff95c1a807e1edade20293a366` | `sha256:74791a34fecee88eef4b9f82d0c6e1c0c9d4251e6f86989f42d8b02f5af29bf8` | `sha256:3f4d72f15854ca6076d600b653002e9cecdabc976f0ab64b515db32a2be7c3d4` | medium |

These are real active-law references for the Aegis paper org bundle, not a
direct active-law hash for the AU finance baseline entry. Prompt 10B should keep
baseline `active_law_hash` and baseline epoch fields pending unless it chooses a
scoped active org binding and documents that choice.

## Candidate Trust-Region Refs And Hashes

| Scope | Ref | Hash | Confidence |
| --- | --- | --- | --- |
| AU finance baseline | `governance/documents/policy/trust_region.yaml` | `bcd91f3a754618f321165fb15a56ec09f3ddffb6ba930dff6f9b74ac351358ce6045f7e983b2c806ac43918ac659b51068a16013384fd87df4b79c78ee02b3bb` | high |
| Aegis paper org | `governance/documents/policy/trust_region.yaml` | `fc01b58453552a49a22d100c31480d521969925d5abba93f38f525451f733c52bb1b2ddbdbbb26abf0aae5e747806403c4542848db9add91f292f87fc911c5d7` | high |

The baseline trust-region hash is repeated by the active-governance baseline
ref and the published baseline governance manifest.

## Candidate Policy Graph Hashes

No explicit `policy_graph_hash` field was found in the inspected AU finance
baseline active-governance ref, baseline governance manifest, baseline
publication metadata, or engine dist manifest. The baseline manifest does carry
a SHA3-512 entry for `artifacts/constitutional_graph.json`, but Prompt 10A does
not reinterpret that artifact digest as a policy graph hash.

Registry fields named `policy_graph_hash` remain placeholders.

## Candidate Source Bundle Roots

| Scope | Root | Confidence | Note |
| --- | --- | --- | --- |
| AU finance baseline governance root | `bc482c79bccfc7c13bd3b8964be363f20194cf2653b1812f7af70c6d949e8a9752230cca07df02c99bb038e88c0b54a9b20126268c2fe58fb9d382a1ea24d675` | high | published baseline `bundle_root_sha3_512` |
| Aegis paper org source bundle root | `sha3-512:ca4934c2e3c72b760685f89f510d7239c33190d6a61d3c5cb41a496a0bd5f4e2f8dffd711997edad342f2215e63e7827d379bf4cb68d80aa32b715df28ae2cb4` | high | active-governance org bundle source root |
| AU finance baseline `source_bundle_root` | not found | high | baseline ref and publication expose bundle root, not `source_bundle_root` |

## ASIC, APRA, And EU Document Or Index Refs

| Lane | Candidate ref | Confidence | Assessment |
| --- | --- | --- | --- |
| APRA | `index/by_stem/APRA CPS 234 Information Security.index.json` inside AU finance baseline `10cf217f862c` | high | directly listed by baseline governance manifest and active docs |
| APRA | `index/by_stem/cps_234_july_2019_for_public_release.index.json` inside AU finance baseline `10cf217f862c` | high | same manifest hash as the APRA CPS 234 index entry |
| ASIC | `index/by_stem/rg234-published-15-november-2012-20211008.index.json` | medium | ASIC regulatory-guide filename inside AU finance baseline |
| ASIC | `index/by_stem/rg271-published-2-september-2021.index.json` | medium | ASIC regulatory-guide filename inside AU finance baseline |
| ASIC | `index/by_stem/rg274-published-10-september-2024.index.json` | medium | ASIC regulatory-guide filename inside AU finance baseline |
| EU | none found | low | no EU, European, or GDPR filename/metadata hit in inspected targets |

These are artifact references only. No policy PDF or compiled policy body was
copied into `paper_eval_6.7b`.

## Gaps Still Unresolved

1. No standalone Praxis corpus ref or bundle ID was discovered for dedicated
   ASIC, APRA, or EU corpus entries.
2. No direct AU finance baseline `active_law_hash` or baseline
   `active_law_epoch_*` ref was found. The Aegis paper org active-law refs are
   scoped org refs that bind the baseline.
3. No explicit `policy_graph_hash` was found in the inspected source-of-truth
   metadata.
4. EU source refs remain unresolved in the inspected active-governance,
   engine-dist metadata, and published bundle index filenames.
5. The AU finance baseline publication says `activation_status=not_activated`
   while Aegis active-governance also has a baseline ref. Prompt 10B should
   record registry authority scope precisely instead of collapsing publication
   and runtime binding states.

## Recommended Prompt 10B Registry Values

Use these directly for the AU finance baseline draft registry entry:

- Corpus slug/ref: `baseline-au-finance`
- Praxis bundle and baseline release ID: `br_1e6d12c254a3`
- Bundle version/fingerprint: `10cf217f862c`
- Artifact URI:
  `s3://praxis-governance/baselines/baseline-au-finance/bundles/10cf217f862c`
- Published bundle ref: `bundles/10cf217f862c`
- Published local root:
  `/app/storage/published_bundles/baselines/baseline-au-finance`
- Governance manifest ref: `governance/manifest.json`
- Governance publication ref: `governance/publication.json`
- Trust-region ref:
  `governance/documents/policy/trust_region.yaml`
- Trust-region SHA3-512:
  `bcd91f3a754618f321165fb15a56ec09f3ddffb6ba930dff6f9b74ac351358ce6045f7e983b2c806ac43918ac659b51068a16013384fd87df4b79c78ee02b3bb`

Use the APRA CPS 234 and ASIC RG index refs as source-ref candidates contained
by the AU finance baseline. Do not claim that they are dedicated active corpus
bundles until Praxis authority metadata for those dedicated lanes is found.

## Values That Must Remain Placeholders

- Dedicated ASIC, APRA, and EU `praxis_corpus_ref`
- Dedicated ASIC, APRA, and EU `praxis_bundle_id`
- Dedicated ASIC, APRA, and EU artifact URIs
- Baseline and dedicated-lane `active_law_hash` unless a scoped active-law
  authority reference is selected and recorded
- Baseline and dedicated-lane `active_law_epoch_id` and
  `active_law_epoch_root` unless direct authority evidence is selected
- All `policy_graph_hash` fields
- EU source refs

## Secret Handling

`REDACTED_SECRET_PRESENT`

A docker-compose search crossed credential-bearing environment lines. Secret
values were not written into this report or the draft YAML.
