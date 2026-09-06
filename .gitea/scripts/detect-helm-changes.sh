#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse optional command-line flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base-branch)
      BASE_BRANCH="$2"
      shift 2
      ;;
    --event-name)
      EVENT_NAME="$2"
      shift 2
      ;;
    --event-before)
      EVENT_BEFORE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--base-branch <branch>] [--event-name <name>] [--event-before <sha>]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

# Resolve configuration from arguments or environment variables
BASE_BRANCH="${BASE_BRANCH:-origin/main}"
EVENT_NAME="${EVENT_NAME:-${GITHUB_EVENT_NAME:-pull_request}}"
EVENT_BEFORE="${EVENT_BEFORE:-}"
OUTPUT_FILE="${GITHUB_OUTPUT:-${GITEA_OUTPUT:-}}"

echo ">> Target branch for diff is: ${BASE_BRANCH}"

# Resolve diff target using shared helper
source "${SCRIPT_DIR}/helper_resolve-diff-target.sh"
resolve_diff_target

# Find changed charts under charts/
RAW_CHARTS=$( (git diff --name-only "${DIFF_TARGET}" | grep -E "^charts/" || true) | awk -F '/' '{print $2}' | sort -u)
VALID_CHARTS=""

for C in $RAW_CHARTS; do
  if [ -n "$C" ] && [ -f "charts/${C}/Chart.yaml" ]; then
    VALID_CHARTS="${VALID_CHARTS} ${C}"
  fi
done

VALID_CHARTS=$(echo "${VALID_CHARTS}" | xargs)

if [ -n "${VALID_CHARTS}" ]; then
  CHARTS_JSON=$(printf '%s\n' ${VALID_CHARTS} | jq -R -s -c 'split("\n") | map(select(length > 0))')

  echo ""
  echo ">> Charts to test:"
  echo "${VALID_CHARTS}"

  echo ""
  echo "----"
  if [ -n "${OUTPUT_FILE}" ]; then
    echo "changes-detected=true" >> "${OUTPUT_FILE}"
    echo "matrix=${CHARTS_JSON}" >> "${OUTPUT_FILE}"
    echo "charts=${VALID_CHARTS}" >> "${OUTPUT_FILE}"
  fi
else
  echo ""
  echo ">> No chart changes detected."
  echo ""
  echo "----"
  if [ -n "${OUTPUT_FILE}" ]; then
    echo "changes-detected=false" >> "${OUTPUT_FILE}"
    echo "matrix=[]" >> "${OUTPUT_FILE}"
    echo "charts=" >> "${OUTPUT_FILE}"
  fi
fi
