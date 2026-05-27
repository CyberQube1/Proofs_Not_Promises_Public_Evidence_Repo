#!/usr/bin/env bash
# Committed non-secret AU paper-lane defaults for cross-box evidence runs.

: "${ACTIVE_LAW_HASH:=sha256:2cc5fdbc5fa2a1dad655079eeb7b140970acabe9c54bf86f3b8931b931d9f91a}"
: "${POLICY_GRAPH_HASH:=8acf1fc1023cb85f56a5948392655424abd6dd32c985de891f697f830b05edd7e451930467e89d45930009510bd20460385e34179745ba146f33cae1c01ff40d}"
: "${TRUST_REGION_HASH:=fc01b58453552a49a22d100c31480d521969925d5abba93f38f525451f733c52bb1b2ddbdbbb26abf0aae5e747806403c4542848db9add91f292f87fc911c5d7}"
: "${MODEL_ID:=gemma4:e2b-it-q8_0}"
: "${MODEL_VERSION:=record-ollama-tag-before-run}"
: "${OLLAMA_HOST:=http://localhost:11434}"
: "${OLLAMA_TIMEOUT_SECONDS:=120}"
: "${TEMPERATURE:=0}"
: "${MAX_TOKENS:=512}"
: "${SEED_NOTE:=ollama-seed-unavailable}"
: "${DETERMINISTIC_MODE:=false}"

export ACTIVE_LAW_HASH
export POLICY_GRAPH_HASH
export TRUST_REGION_HASH
export MODEL_ID
export MODEL_VERSION
export OLLAMA_HOST
export OLLAMA_TIMEOUT_SECONDS
export TEMPERATURE
export MAX_TOKENS
export SEED_NOTE
export DETERMINISTIC_MODE
