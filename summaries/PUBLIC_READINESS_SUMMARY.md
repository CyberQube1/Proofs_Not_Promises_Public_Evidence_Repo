# Public Readiness Summary

Status: release-candidate public evidence pack.

The source AU evidence bundle is marked `paper_evidence_ready` in the redacted
QA/readiness summaries. This public pack is not the raw bundle. It is a
release-facing subset that carries final locked tables, redacted summaries,
claim-boundary notes, and hashes for excluded raw/private-detail artifacts.

## Included Evidence

- Final locked result tables are included in `tables/`.
- Redacted QA/readiness/result summaries are included in `summaries/`.
- Claim and locked-value notes are included in `metadata/`.
- SHA-256 hashes for excluded source files are included in
  `excluded_hashes/SOURCE_FILE_HASHES.tsv`.

## Excluded Evidence

Raw task rows, raw model outputs, scored rows, detailed candidate artifacts,
detailed gate/Cassius artifacts, and sandbox overlays are excluded from this
public pack pending task-release and internal-artifact release review.

## Release Interpretation

The public pack is sufficient to inspect the paper's locked tables and claim
boundary. It is not sufficient to replay the run, and it does not create any
claim of API portability, EU results, production promotion, live production
self-modification, statistical significance, replay reproducibility, proven
gate selectivity, or broad behavioral superiority.
