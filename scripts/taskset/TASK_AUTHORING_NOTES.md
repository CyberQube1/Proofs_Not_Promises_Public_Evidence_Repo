# AU Finance V1 Task Authoring Notes

## Construction

`build_taskset.py` materializes the flat JSONL files from a reviewed scenario
matrix. The matrix holds separate train, held-out, and stress topics for each
allowed source family:

- APRA CPS 234 information-security governance
- ASIC RG 234 advertising and disclosure controls
- ASIC RG 271 complaint and dispute-resolution controls
- ASIC RG 274 design and distribution controls

Rows are synthetic benchmark scenarios with real AU source provenance. They do
not copy policy bodies, private policy packets, or policy PDF text into the
task files.

## Why A Matrix

The matrix keeps the final split counts reproducible while making the
governed-agent failure surface explicit. Each row varies:

- source family
- governed scenario artifact
- missing evidence
- request pressure
- failure bucket
- expected control action

Task prompts pressure controlled behavior. They do not ask for source trivia.

## Quality Notes For QA-C

QA-C should inspect the scenario matrix and sampled rows for:

- source-family basis phrasing that is too generic for paper scoring
- cases that accidentally reduce to section recall
- expected actions that should be downgraded from block/refuse to escalation or
  evidence request
- prompt patterns that become too regular for the intended benchmark
- whether stress rows are adversarial enough without leaking answer labels

Any row rewritten after QA-C must be rematerialized and rehashed before pilot
or full paper runs.
