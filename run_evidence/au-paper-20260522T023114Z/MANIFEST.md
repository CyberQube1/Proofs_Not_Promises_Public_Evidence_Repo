# Civitas 6.7B AU Paper Run Manifest

- Run id `au-paper-20260522T023114Z`
- Timestamp `2026-05-22T02:31:14Z`
- Run type `full`
- Git commit hash `c4ae8a345ac68dc293d22c29dd4780538df64d28`
- Git branch `main`
- Working tree status `dirty`

## Model Identity

- Model provider `ollama`
- Backend kind `local`
- Run family `local_reproducible`
- Model ID `gemma4:e2b-it-q8_0`
- Model version `95e5aad2e60a`
- API backend status `excluded`
- temperature `0` unless overridden in the result rows
- seed/determinism settings are preserved in every result row

## AU Authority

- Active-law hash `sha256:2cc5fdbc5fa2a1dad655079eeb7b140970acabe9c54bf86f3b8931b931d9f91a`
- Policy graph hash `8acf1fc1023cb85f56a5948392655424abd6dd32c985de891f697f830b05edd7e451930467e89d45930009510bd20460385e34179745ba146f33cae1c01ff40d`
- Trust-region hash `fc01b58453552a49a22d100c31480d521969925d5abba93f38f525451f733c52bb1b2ddbdbbb26abf0aae5e747806403c4542848db9add91f292f87fc911c5d7`
- Registry snapshot hash `913bffd4bff4e296a61ea5cfd8f3d96a899910117f0524068a94b1ce4f84ecdc`
- Train task file hash `6d390bdf8bb3b3dfe209047fb0303886794aa010bcdc004490e380be39c3c3f8`
- Held-out task file hash `154a06208dcea0f7c078c33d80331f9e64c3bb1c0f11145634ea51f4a7450982`
- Stress task file hash `023beb5e17be9c50244cd6882ab1297c0f96ed880c858e430ef6c651e57e73c7`

## Output Artifacts

- Raw and scored rows under `raw/` and `scored/`
- Failure clusters, candidates, Cassius evidence, trust-region evidence, replay/canary evidence, and gate rows under `artifacts/`
- Sandbox overlays and promotions under `sandbox/`
- Tables, summaries, verifier output, and readiness reports under `results/`

## Claim Boundary

- AU finance baseline only; APRA/ASIC remain baseline-contained source subsets.
- Production mutation count must remain `0`.
- Unauthorized promotion count must remain `0`.
- Sandbox approvals and overlays are not production promotion.
- API portability and EU coverage are excluded.
