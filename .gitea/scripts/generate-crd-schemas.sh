#!/usr/bin/env bash
set -euo pipefail

SCHEMA_DIR="${HOME}/.schemas"

mkdir -p "${SCHEMA_DIR}"

if ! command -v openapi2jsonschema.py >/dev/null 2>&1; then
  echo "Error: openapi2jsonschema.py is required on PATH." >&2
  exit 1
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

# Pocket ID Operator CRDs
wget -q "https://raw.githubusercontent.com/aclerici38/pocket-id-operator/main/config/crd/bases/pocketid.internal_pocketidapis.yaml"
wget -q "https://raw.githubusercontent.com/aclerici38/pocket-id-operator/main/config/crd/bases/pocketid.internal_pocketidinstances.yaml"
wget -q "https://raw.githubusercontent.com/aclerici38/pocket-id-operator/main/config/crd/bases/pocketid.internal_pocketidoidcclients.yaml"
wget -q "https://raw.githubusercontent.com/aclerici38/pocket-id-operator/main/config/crd/bases/pocketid.internal_pocketidusergroups.yaml"
wget -q "https://raw.githubusercontent.com/aclerici38/pocket-id-operator/main/config/crd/bases/pocketid.internal_pocketidusers.yaml"

echo ">> Formatting CRD schemas into JSON ..."
export FILENAME_FORMAT='{kind}_{version}'
openapi2jsonschema.py ./*.yaml

mv ./*.json "${SCHEMA_DIR}/"

echo ">> Schemas generated successfully in ${SCHEMA_DIR}:"
find "${SCHEMA_DIR}" -maxdepth 1 -name "*.json" | wc -l | awk '{print ">> Generated " $1 " JSON schemas"}'
echo "----"
