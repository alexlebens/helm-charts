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
  echo ">> No charts specified for lockfile verification. Skipping."
  exit 0
fi

echo ">> Verifying Chart.lock files are up-to-date ..."
FAILED_LOCKS=""

for CHART in ${CHARTS}; do
  CHART_PATH="charts/${CHART}"
  if [ -f "${CHART_PATH}/Chart.yaml" ]; then
    if [ ! -f "${CHART_PATH}/Chart.lock" ] && ! helm dependency list "${CHART_PATH}" 2> /dev/null | tail +2 | grep -q '[^[:space:]]'; then
      echo ">> No dependencies found for ${CHART}, skipping lockfile verification ..."
      continue
    fi

    (
      cd "${CHART_PATH}"
      echo ""
      echo ">> Updating helm dependencies for ${CHART} ..."
      helm dependency update . --skip-refresh

      if [ -n "$(git status --porcelain Chart.lock)" ]; then
        echo "::error file=${CHART_PATH}/Chart.lock::Chart.lock is out of date. Please run 'helm dependency update' locally and commit the changes."
        exit 1
      fi
    ) || {
      FAILED_LOCKS="${FAILED_LOCKS} ${CHART}"
    }
  fi
done

if [ -n "${FAILED_LOCKS}" ]; then
  echo ""
  echo ">> Lockfile validation failed for charts: ${FAILED_LOCKS}" >&2
  exit 1
fi

echo ""
echo ">> All Chart.lock files verified successfully."
echo "----"
