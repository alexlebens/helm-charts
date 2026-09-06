#!/usr/bin/env bash
set -euo pipefail

CHART=""
HARBOR_HOST="${HARBOR_HOST:-}"
HARBOR_USER="${HARBOR_USER:-}"
HARBOR_SECRET="${HARBOR_SECRET:-}"
GITEA_SERVER_URL="${GITEA_SERVER_URL:-${gitea_server_url:-}}"
GITEA_ACTOR="${GITEA_ACTOR:-}"
GIT_TOKEN="${GIT_TOKEN:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chart)
      CHART="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 --chart <chart-name>"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [ -z "${CHART}" ]; then
  echo "Error: --chart is required." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHART_PATH="charts/${CHART}"
if [ ! -f "${CHART_PATH}/Chart.yaml" ]; then
  echo "Error: ${CHART_PATH}/Chart.yaml does not exist." >&2
  exit 1
fi

# Add dependency repositories
"${SCRIPT_DIR}/helm-add-repos.sh" --chart "${CHART}"

echo ">> Processing release for chart: ${CHART}"
cd "${CHART_PATH}"

echo ">> Building helm dependencies for ${CHART} ..."
helm dependency build . --skip-refresh --debug

echo ">> Packaging chart: ${CHART} ..."
PACKAGE_OUTPUT=$(helm package .)
RAW_PACKAGE_PATH=$(echo "${PACKAGE_OUTPUT}" | awk '{print $NF}')
if [[ "${RAW_PACKAGE_PATH}" = /* ]]; then
  PACKAGE_PATH="${RAW_PACKAGE_PATH}"
else
  PACKAGE_PATH="$(pwd)/${RAW_PACKAGE_PATH}"
fi

CHART_VERSION=$(yq '.version' Chart.yaml)
CHART_NAME=$(yq '.name' Chart.yaml)

cd - > /dev/null

if [ ! -f "${PACKAGE_PATH}" ]; then
  echo "Error: Packaged file not found at ${PACKAGE_PATH}" >&2
  exit 1
fi

echo ">> Successfully packaged ${CHART_NAME} v${CHART_VERSION} at ${PACKAGE_PATH}"

# Push to Harbor OCI Registry
if [ -n "${HARBOR_HOST}" ] && [ -n "${HARBOR_SECRET}" ]; then
  echo ">> Logging into Harbor (${HARBOR_HOST}) ..."
  echo "${HARBOR_SECRET}" | helm registry login "${HARBOR_HOST}" --username "${HARBOR_USER}" --password-stdin --debug

  echo ">> Pushing chart to Harbor OCI ..."
  helm push "${PACKAGE_PATH}" "oci://${HARBOR_HOST}/helm-charts" --debug
fi

# Push to Gitea ChartMuseum Registry
if [ -n "${GITEA_SERVER_URL}" ] && [ -n "${GIT_TOKEN}" ]; then
  echo ">> Installing ChartMuseum plugin if not installed ..."
  if ! helm plugin list | grep -q "cm-push"; then
    helm plugin install https://github.com/chartmuseum/helm-push --verify=false --debug
  fi

  echo ">> Adding Gitea repository ..."
  helm repo add --username "${GITEA_ACTOR}" --password "${GIT_TOKEN}" helm-charts "${GITEA_SERVER_URL}/api/packages/alexlebens/helm" --debug || true

  echo ">> Pushing chart to Gitea ..."
  helm cm-push "${PACKAGE_PATH}" helm-charts --debug
fi

# Generate release notes
echo ">> Generating release notes ..."
RELEASE_NOTES_FILE="release_notes.md"
echo "## What's Changed in \`${CHART_NAME}\` v${CHART_VERSION}" > "${RELEASE_NOTES_FILE}"
echo "" >> "${RELEASE_NOTES_FILE}"

LAST_TAG=$(git describe --tags --abbrev=0 --match "${CHART_NAME}-*" HEAD^ 2>/dev/null || echo "")

if [ -z "${LAST_TAG}" ]; then
  echo "### Initial Release" >> "${RELEASE_NOTES_FILE}"
  echo "" >> "${RELEASE_NOTES_FILE}"
  git log --format="* %s (\`%h\`) - *%an*" -- "charts/${CHART_NAME}" >> "${RELEASE_NOTES_FILE}"
else
  echo "### Changes since \`${LAST_TAG}\`" >> "${RELEASE_NOTES_FILE}"
  echo "" >> "${RELEASE_NOTES_FILE}"
  git log "${LAST_TAG}..HEAD" --format="* %s (\`%h\`) - *%an*" -- "charts/${CHART_NAME}" >> "${RELEASE_NOTES_FILE}"
fi

echo ">> Generated ${RELEASE_NOTES_FILE}:"
cat "${RELEASE_NOTES_FILE}"
echo "----"

# Export environment variables for subsequent workflow steps
if [ -n "${GITHUB_ENV:-}" ]; then
  echo "PACKAGE_PATH=${PACKAGE_PATH}" >> "${GITHUB_ENV}"
  echo "CHART_VERSION=${CHART_VERSION}" >> "${GITHUB_ENV}"
  echo "CHART_NAME=${CHART_NAME}" >> "${GITHUB_ENV}"
fi
