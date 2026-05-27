# Public Evidence Pack Scripts

These scripts are included for method transparency and reproduction attempts in
a compatible Civitas 6.7B checkout.

## Contents

- `eval/`: aggregation, scoring, replay-canary export, and unit tests for the
  paper-evaluation harness.
- `repro/`: AU paper-run wrappers, readiness checks, verification checks, and
  reproduction tests.
- `taskset/`: AU finance taskset builder, validator, authoring controls, and
  taskset QA notes.

## Reproduction Boundary

The scripts are not a standalone product. They assume the surrounding Civitas
research checkout, Python dependencies, local Ollama/Gemma execution lane, and
the source-corpus references used by the locked AU taskset. They do not provide
production credentials, hosted model-provider credentials, live authority
services, or production-promotion rights.

The phrase `local_reproducible`, where it appears in scripts or reports, is an
internal lane/status label. It is not a paper claim that replay reproducibility
has been demonstrated from this public package alone.
