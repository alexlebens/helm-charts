#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
SCHEMA_DIR="${HOME}/.schemas"

mkdir -p "${BIN_DIR}" "${SCHEMA_DIR}"

if [ ! -f "${BIN_DIR}/openapi2jsonschema.py" ]; then
  echo ">> Downloading openapi2jsonschema.py ..."
  wget -qO "${BIN_DIR}/openapi2jsonschema.py" "https://raw.githubusercontent.com/yannh/kubeconform/master/scripts/openapi2jsonschema.py"
  chmod +x "${BIN_DIR}/openapi2jsonschema.py"
fi

echo ">> Downloading CRD definitions ..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

cd "${TMP_DIR}"

# Garage Operator CRDs
wget -q "https://raw.githubusercontent.com/rajsinghtech/garage-operator/main/charts/garage-operator/crd-bases/garage.rajsingh.info_garagebuckets.yaml"
wget -q "https://raw.githubusercontent.com/rajsinghtech/garage-operator/main/charts/garage-operator/crd-bases/garage.rajsingh.info_garageclusters.yaml"
wget -q "https://raw.githubusercontent.com/rajsinghtech/garage-operator/main/charts/garage-operator/crd-bases/garage.rajsingh.info_garagekeys.yaml"
wget -q "https://raw.githubusercontent.com/rajsinghtech/garage-operator/main/charts/garage-operator/crd-bases/garage.rajsingh.info_garagereferencegrants.yaml"

# CloudNative-PG CRDs
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_backups.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_clusterimagecatalogs.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_clusters.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_databaseroles.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_databases.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_failoverquorums.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_imagecatalogs.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_poolers.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_publications.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_scheduledbackups.yaml"
wget -q "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/config/crd/bases/postgresql.cnpg.io_subscriptions.yaml"

echo ">> Formatting CRD schemas into JSON ..."
export FILENAME_FORMAT='{kind}_{version}'
python3 "${BIN_DIR}/openapi2jsonschema.py" *.yaml

mv *.json "${SCHEMA_DIR}/"

echo ">> Schemas generated successfully in ${SCHEMA_DIR}:"
ls -1 "${SCHEMA_DIR}"/*.json | wc -l | awk '{print ">> Generated " $1 " JSON schemas"}'
echo "----"
