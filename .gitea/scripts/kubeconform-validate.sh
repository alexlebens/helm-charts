#!/usr/bin/env bash
set -euo pipefail

# Parse optional command-line flags
CHARTS="${CHARTS:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --charts)
      CHARTS="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--charts <charts>]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [ -z "${CHARTS}" ]; then
  echo ">> No charts specified for Kubeconform validation. Skipping."
  exit 0
fi

SCHEMA_DIR="${HOME}/.schemas"

echo ">> Running kubeconform on changed charts ..."
FAILED_CHARTS=""

for CHART in ${CHARTS}; do
  CHART_PATH="charts/${CHART}"
  if [ -f "${CHART_PATH}/Chart.yaml" ]; then
    (
      cd "${CHART_PATH}"
      echo ""
      echo ">> Running kubeconform for ${CHART} (default values) ..."
      helm template . | kubeconform -strict -summary \
        -schema-location default \
        -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
        -schema-location "${SCHEMA_DIR}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"

      if ls ci/*.yaml 1> /dev/null 2>&1; then
        for values_file in ci/*.yaml; do
          echo ">> Running kubeconform for ${CHART} (${values_file}) ..."
          helm template . -f "${values_file}" | kubeconform -strict -summary \
            -schema-location default \
            -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
            -schema-location "${SCHEMA_DIR}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"
        done
      fi
    ) || {
      FAILED_CHARTS="${FAILED_CHARTS} ${CHART}"
    }
  fi
done

if [ -n "${FAILED_CHARTS}" ]; then
  echo ""
  echo ">> Kubeconform failed for the following charts: ${FAILED_CHARTS}" >&2
  if [ -n "${GITHUB_ENV:-}" ]; then
    echo "FAILED_CHART=${FAILED_CHARTS}" >> "${GITHUB_ENV}"
  fi
  exit 1
fi

echo ""
echo ">> All charts passed Kubeconform validation."
echo "----"
