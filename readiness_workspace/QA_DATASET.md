# QA-C AU Dataset Review

## Verdict

`PASS`

The AU finance v1 taskset is accepted as the frozen task input for real
execution work. This verdict covers dataset scope, source binding, governed
task character, split controls, and taskset hashes. It does not claim model
evidence before real non-stub runs exist.

## Findings

### Fixed During QA

The first generated unsafe-action prompts used awkward materializer wording for
some rows, such as object repetition around a waiver or narrative artifact.
`build_taskset.py` was fixed to state the controlled action using only the
visible artifact, the `100/100/50` files were regenerated, and the task hashes
were updated before freeze.

### Blocking Findings

None remain.

## Acceptance Checks

| Check | Result | Evidence |
| --- | --- | --- |
| AU scope only | PASS | All final rows use `jurisdiction=AU` and `policy_corpus_id=au_finance_paper_scope`. |
| No placeholder or EU claim metadata | PASS | `validate_au_taskset.py` rejects placeholder, `synthetic_`, and `PENDING_*` markers. |
| APRA/ASIC refs stay baseline-contained | PASS | `AU_SOURCE_MAP.yaml` allows only APRA CPS 234 and ASIC RG source indexes in the frozen AU baseline. |
| Governed failure buckets are covered | PASS | Manifest records all six buckets across train, held-out, and stress. |
| Rows are not policy recall Q&A | PASS | Sampled prompts pressure controlled actions, assurances, escalation, supersession, paraphrase, and repeat-failure handling. |
| Expected control actions and basis are reviewable | PASS | Rows expose evidence limits, control-action labels, policy-basis text, success criteria, and failure modes. |
| Split labels and source files agree | PASS | Validator enforces split-per-file naming. |
| Duplicate and near-duplicate prompts are blocked across splits | PASS | `LEAKAGE_REVIEW.md` records the normalized cross-split leakage gate. |
| Task hashes are frozen | PASS | `TASKSET_MANIFEST.md` records post-fix hashes and `status=frozen_after_QA-C`. |

## Review Sample

The QA pass sampled:

- APRA CPS 234 train, held-out, and stress rows
- ASIC RG 234 advertising/disclosure rows
- ASIC RG 271 complaint handling rows
- ASIC RG 274 design/distribution rows
- a stress repeat-failure row

## Residual Risk

The taskset is built from a reproducible scenario matrix. That regularity is
intentional for auditability and split accounting, but the pilot should still
watch whether prompt pattern regularity reduces challenge diversity or scoring
discrimination.
