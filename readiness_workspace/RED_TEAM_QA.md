# AU Paper Red-Team QA Contract

## Review Posture

Every phase is reviewed as if a skeptical paper reviewer and a safety reviewer
are trying to break the claim. QA must lead with findings, not summaries.

## Non-Negotiables

- Do not fabricate policy hashes, model results, receipts, task authority, or
  Cassius passes.
- Do not let smoke or deterministic stub rows enter claim-supporting outputs.
- Do not let held-out or stress rows influence discovery, candidate generation,
  prompt tuning, or gate tuning.
- Do not mutate production config, production state, active law, Aegis state,
  Senate state, or live trust-region config.
- Do not add secrets, credentials, private policy bodies, or copied policy PDFs
  to proof artifacts.
- Do not carry avoidable paper-lane debt as a hidden `TODO`, `TBD`, bypass, or
  undocumented manual step.

## Code Quality Rule

Paper-lane code should be production-grade research code:

- use narrow adapters rather than hidden bypasses
- validate paths, input schemas, state markers, and hash bindings
- fail closed on missing claim evidence
- preserve error rows and rejection rows
- add concise inline comments only where safety, hashing, provenance, or split
  logic is not obvious from the code
- update schemas and runbooks with behavior changes
- run focused tests that cover changed claim contracts

## Phase Attack Checklist

### Authority

- Does the selected AU lane point to source-of-truth Praxis/Aegis refs?
- Is APRA/ASIC framing baseline-contained rather than falsely standalone?
- Are active-law, graph, and trust-region mappings explicit?
- Are unresolved AU claim placeholders absent?

### Dataset

- Are rows governed-agent failure tasks rather than policy recall?
- Are source refs exact and allowed?
- Does every expected action have defensible policy basis?
- Are held-out and stress rows sealed from train failure patterns?
- Are there near duplicates across splits?

### Execution

- Are claim rows real and non-stub?
- Are model and config identities frozen?
- Is 6.5B comparator-only?
- Does governed improvement load sandbox artifacts only?
- Are failures and timeouts emitted, not dropped?

### Scoring

- Are scoring labels reproducible?
- Is judge configuration frozen if a judge is used?
- Are ambiguous rows reviewed consistently?
- Are policy violations distinguished from unsupported claims?
- Are scorer failures reported?

### Governance

- Is every approved claim candidate Cassius-backed?
- Are rejected and blocked candidates visible with reason codes?
- Is trust-region evidence decision-bearing rather than decoration?
- Is replay/canary status truthful?
- Is Aegis/Senate status explicit and not mislabeled as live approval?

### Repro And Proof

- Does the bundle verify from hashes and manifests?
- Are production mutation and unauthorized promotion counts zero?
- Are task, registry, config, scorer, model, and governance inputs frozen?
- Do tables trace back to raw artifacts?
- Do result summaries state limitations without overclaiming?

## Bug Handling

If QA finds a bug that threatens a claim boundary, fix it before moving to the
next phase or issue a blocking fix prompt. A paper-ready phase cannot close
with a known defect in:

- split isolation
- source authority
- stub exclusion
- scoring correctness
- governance evidence
- sandbox containment
- reproducibility or hash verification
