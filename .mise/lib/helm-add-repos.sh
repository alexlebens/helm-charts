#!/usr/bin/env bash
# Sourceable or runnable helper to add Helm repositories required by chart dependencies.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"
REPO_ROOT="${MISE_PROJECT_ROOT:-$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd -- "$SCRIPT_DIR/../.." &>/dev/null && pwd -P))}"
# shellcheck source=log.sh
source "${REPO_ROOT}/.mise/lib/log.sh"

MAIN_DIR="${MAIN_DIR:-${REPO_ROOT}}"
CHARTS="${CHARTS:-${CHART:-}}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --main-dir)
      MAIN_DIR="$2"
      shift 2
      ;;
    --chart)
      CHARTS="${CHARTS} $2"
      shift 2
      ;;
    --charts)
      CHARTS="${CHARTS} $2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: helm-add-repos [--main-dir <dir>] [--chart <chart>] [--charts <charts...>]"
      echo "Adds Helm repositories required by chart dependencies, deduplicating shared repositories."
      exit 0
      ;;
    *)
      log_fatal "Unknown argument: $1"
      ;;
  esac
done

CHARTS=$(echo "${CHARTS}" | xargs)

if [ -z "${CHARTS}" ]; then
  log_info "No charts specified. Skipping repository addition."
  exit 0
fi

if [ -d "${MAIN_DIR}" ]; then
  MAIN_DIR="$(cd "${MAIN_DIR}" && pwd)"
fi

log_step "Checking dependencies for chart(s): ${CHARTS}"

# Extract and deduplicate non-OCI repository dependencies across all charts
REPO_LIST=$(
  for C in ${CHARTS}; do
    CHART_PATH="${MAIN_DIR}/charts/${C}"
    if [ -f "${CHART_PATH}/Chart.yaml" ]; then
      helm dependency list --max-col-width 120 "${CHART_PATH}" 2>/dev/null || true
    fi
  done | awk '$1 != "NAME" && $3 !~ /^oci:\/\// && NF >= 3 { print $1, $3 }' | sort -u
)

if [ -n "${REPO_LIST}" ]; then
  log_step "Adding Helm repositories"
  while read -r REPO_NAME REPO_URL; do
    if [ -n "${REPO_NAME}" ] && [ -n "${REPO_URL}" ]; then
      log_info "Adding repo: ${REPO_NAME} (${REPO_URL})"
      helm repo add "${REPO_NAME}" "${REPO_URL}" --force-update >/dev/null 2>&1 || true
    fi
  done <<< "${REPO_LIST}"

  if [ "$(helm repo list 2>/dev/null | wc -l)" -gt 1 ]; then
    log_info "Updating repository cache ..."
    helm repo update >/dev/null 2>&1 || true
  fi
else
  log_info "No external Helm repositories required."
fi
log_success "Helm repositories configured!"
