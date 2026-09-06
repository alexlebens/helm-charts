#!/usr/bin/env bash
set -euo pipefail

CT_VERSION="${CT_VERSION:-v3.12.0}"
YAMLLINT_VERSION="${YAMLLINT_VERSION:-1.35.1}"
YAMALE_VERSION="${YAMALE_VERSION:-6.0.0}"

if [ ! -f "$HOME/.ct-bin/ct" ]; then
  echo ">> Installing chart-testing ${CT_VERSION} ..."
  CT_VERSION_NO_V="${CT_VERSION#v}"
  curl -sSLo ct.tar.gz "https://github.com/helm/chart-testing/releases/download/${CT_VERSION}/chart-testing_${CT_VERSION_NO_V}_linux_amd64.tar.gz"
  tar -xzf ct.tar.gz
  mkdir -p "$HOME/.ct-bin"
  mv ct "$HOME/.ct-bin/"
  mkdir -p "$HOME/.ct"
  if [ -d "etc" ]; then
    mv etc/* "$HOME/.ct/"
  fi
  rm -f ct.tar.gz
fi

if [ -n "${GITHUB_PATH:-}" ]; then
  echo "$HOME/.ct-bin" >> "$GITHUB_PATH"
fi
export PATH="$HOME/.ct-bin:$PATH"

echo ">> Installing yamllint and yamale ..."
pip3 install "yamllint==${YAMLLINT_VERSION}" "yamale==${YAMALE_VERSION}"

echo ""
echo ">> chart-testing installed successfully:"
ct version
echo "----"
