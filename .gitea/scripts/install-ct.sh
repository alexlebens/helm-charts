#!/usr/bin/env bash
set -euo pipefail

CT_VERSION="${CT_VERSION:-v3.12.0}"
YAMLLINT_VERSION="${YAMLLINT_VERSION:-1.35.1}"
YAMALE_VERSION="${YAMALE_VERSION:-6.0.0}"

if ! command -v ct >/dev/null 2>&1; then
  echo "Error: 'ct' (chart-testing) is required on PATH." >&2
  exit 1
fi

if ! command -v yamllint >/dev/null 2>&1 || ! command -v yamale >/dev/null 2>&1; then
  echo ">> Installing yamllint and yamale ..."
  uv tool install "yamllint==${YAMLLINT_VERSION}"
  uv tool install "yamale==${YAMALE_VERSION}"
fi

echo ""
echo ">> chart-testing ready:"
ct version
echo "----"
