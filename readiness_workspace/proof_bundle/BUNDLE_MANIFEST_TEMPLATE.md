# AU Finance Paper Proof Bundle Manifest

## Bundle Identity

| Field | Value |
| --- | --- |
| Bundle id | `REQUIRED` |
| Full run id | `REQUIRED` |
| Timestamp | `REQUIRED` |
| Paper scope | AU finance baseline with APRA/ASIC source subsets contained inside it |
| Readiness result | `REQUIRED: paper_evidence_ready` |

## Authority Snapshot

| Artifact | Path | Hash |
| --- | --- | --- |
| AU paper registry snapshot | `REQUIRED` | `REQUIRED` |
| AU authority mapping | `REQUIRED` | `REQUIRED` |
| Praxis source refs manifest | `REQUIRED` | `REQUIRED` |
| Aegis active-governance ref | `REQUIRED` | `REQUIRED` |

## Frozen Taskset

| Split | Path | Rows | Hash |
| --- | --- | ---: | --- |
| Train failures | `REQUIRED` | `100` | `REQUIRED` |
| Held-out eval | `REQUIRED` | `100` | `REQUIRED` |
| Stress | `REQUIRED` | `50` | `REQUIRED` |

## Models And Configs

| Lane | Revision/config | Model/backend | Hash/ref |
| --- | --- | --- | --- |
| Civitas 6.5B frozen comparator | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Civitas 6.7B no improvement | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Civitas 6.7B governed sandbox | `REQUIRED` | `REQUIRED` | `REQUIRED` |
| Ungated sandbox ablation | `REQUIRED or explicitly excluded` | `REQUIRED` | `REQUIRED` |

## Scoring

| Artifact | Path | Hash |
| --- | --- | --- |
| Rubric | `REQUIRED` | `REQUIRED` |
| Scorer config | `REQUIRED` | `REQUIRED` |
| Adjudication audit | `REQUIRED` | `REQUIRED` |

## Governance Evidence

| Artifact | Path | Hash |
| --- | --- | --- |
| Failure clusters | `REQUIRED` | `REQUIRED` |
| Candidate records | `REQUIRED` | `REQUIRED` |
| Cassius evidence | `REQUIRED` | `REQUIRED` |
| Gate results | `REQUIRED` | `REQUIRED` |
| Trust-region evidence | `REQUIRED` | `REQUIRED` |
| Replay/canary evidence | `REQUIRED or bounded limitation` | `REQUIRED` |

## Sandbox And Results

| Artifact | Path | Hash |
| --- | --- | --- |
| Sandbox promotion rows | `REQUIRED` | `REQUIRED` |
| Sandbox state and overlays | `REQUIRED` | `REQUIRED` |
| Held-out results | `REQUIRED` | `REQUIRED` |
| Stress results | `REQUIRED` | `REQUIRED` |
| Aggregate tables | `REQUIRED` | `REQUIRED` |
| Results summary | `REQUIRED` | `REQUIRED` |

## Verification

| Check | Result | Artifact |
| --- | --- | --- |
| Full AU verifier | `REQUIRED: pass` | `REQUIRED` |
| Paper readiness | `REQUIRED: paper_evidence_ready` | `REQUIRED` |
| Production mutation count | `REQUIRED: 0` | `REQUIRED` |
| Unauthorized promotion count | `REQUIRED: 0` | `REQUIRED` |
| Split leakage audit | `REQUIRED: pass` | `REQUIRED` |

## Claim Boundary

- EU is not claimed.
- APRA and ASIC appear as AU-baseline-contained source subsets unless a later
  standalone authority bundle is separately frozen.
- Sandbox approval is not production approval.
- API portability is not claimed unless a real optional API lane is archived.
