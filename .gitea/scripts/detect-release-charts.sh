#!/usr/bin/env bash
set -euo pipefail

INPUT_CHART="${INPUT_CHART:-}"
EVENT_NAME="${EVENT_NAME:-${GITHUB_EVENT_NAME:-workflow_run}}"
EVENT_BEFORE="${EVENT_BEFORE:-}"
OUTPUT_FILE="${GITHUB_OUTPUT:-${GITEA_OUTPUT:-}}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input-chart)
      INPUT_CHART="$2"
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
      echo "Usage: $0 [--input-chart <name>] [--event-name <name>] [--event-before <sha>]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

echo ">> Detecting charts to release ..."

if [ "${EVENT_NAME}" = "workflow_dispatch" ]; then
  if [ -n "${INPUT_CHART}" ]; then
    echo ">> Manual dispatch for specific chart: ${INPUT_CHART}"
    if [ -n "${OUTPUT_FILE}" ]; then
      echo "changes-detected=true" >> "${OUTPUT_FILE}"
      echo "matrix=[\"${INPUT_CHART}\"]" >> "${OUTPUT_FILE}"
    fi
    exit 0
  else
    echo ">> Manual dispatch for all charts"
    CHARTS=($(find charts -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
  fi
else
  if [ -n "${EVENT_BEFORE}" ] && [ "${EVENT_BEFORE}" != "0000000000000000000000000000000000000000" ]; then
    echo ">> Getting git diff from event.before (${EVENT_BEFORE}..HEAD) ..."
    GIT_DIFF=$(git diff --name-only "${EVENT_BEFORE}..HEAD" | grep -E "^charts/" || true)
  else
    echo ">> Getting git diff from HEAD^1..HEAD ..."
    GIT_DIFF=$(git diff --name-only HEAD^1 HEAD | grep -E "^charts/" || true)
  fi

  CHARTS=()
  if [ -n "${GIT_DIFF}" ]; then
    for path in ${GIT_DIFF}; do
      chart_name=$(echo "${path}" | awk -F '/' '{print $2}')
      if [ -n "${chart_name}" ] && [ -f "charts/${chart_name}/Chart.yaml" ]; then
        CHARTS+=("${chart_name}")
      fi
    done
  fi
fi

if [ ${#CHARTS[@]} -gt 0 ]; then
  UNIQUE_CHARTS=($(printf "%s\n" "${CHARTS[@]}" | sort -u))
  CHARTS_JSON=$(printf '%s\n' "${UNIQUE_CHARTS[@]}" | jq -R -s -c 'split("\n") | map(select(length > 0))')

  echo ">> Charts to release: ${UNIQUE_CHARTS[*]}"
  echo ""
  echo "----"
  if [ -n "${OUTPUT_FILE}" ]; then
    echo "changes-detected=true" >> "${OUTPUT_FILE}"
    echo "matrix=${CHARTS_JSON}" >> "${OUTPUT_FILE}"
  fi
else
  echo ">> No charts changed."
  echo ""
  echo "----"
  if [ -n "${OUTPUT_FILE}" ]; then
    echo "changes-detected=false" >> "${OUTPUT_FILE}"
    echo "matrix=[]" >> "${OUTPUT_FILE}"
  fi
fi
