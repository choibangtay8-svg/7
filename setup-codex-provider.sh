#!/usr/bin/env bash
clear

set -e

# Cleanup biến cũ trong session hiện tại
unset PROVIDER_ID
unset PROVIDER_NAME
unset MODEL_ID
unset BASE_URL
unset KEY_ENV
unset WIRE_API
unset REASONING_EFFORT
unset API_KEY

mkdir -p ~/.codex
