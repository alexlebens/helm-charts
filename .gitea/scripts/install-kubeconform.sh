#!/usr/bin/env bash
set -euo pipefail

KUBECONFORM_VERSION="${KUBECONFORM_VERSION:-v0.6.4}"
BIN_DIR="${HOME}/.local/bin"
mkdir -p "${BIN_DIR}"

if [ ! -f "${BIN_DIR}/kubeconform" ]; then
  echo ">> Downloading Kubeconform ${KUBECONFORM_VERSION} ..."
  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "${TMP_DIR}"' EXIT

  wget -qO "${TMP_DIR}/kubeconform.tar.gz" "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz"
  tar -xzf "${TMP_DIR}/kubeconform.tar.gz" -C "${TMP_DIR}"
  mv "${TMP_DIR}/kubeconform" "${BIN_DIR}/"
  chmod +x "${BIN_DIR}/kubeconform"
fi

if [ -n "${GITHUB_PATH:-}" ]; then
  echo "${BIN_DIR}" >> "${GITHUB_PATH}"
fi
export PATH="${BIN_DIR}:${PATH}"

echo ""
echo ">> Kubeconform installed successfully:"
kubeconform -v
echo "----"
