#!/bin/sh
set -e

export HOME=/home/vault
export BAO_ADDR="${VAULT_ADDR}"

echo ">> Authenticating to OpenBao via Kubernetes auth..."
bao login -method=kubernetes -no-print \
  role="${VAULT_ROLE}" \
  mount_path="${AUTH_PATH}" \
  jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

SECRET_PATH="${SECRET_PATH#/}"
echo ">> Checking if secret exists at: ${SECRET_PATH}"

if bao kv get -mount="${VAULT_MOUNT}" "${SECRET_PATH}" > /dev/null 2>&1; then
  echo ">> Secret already exists at ${SECRET_PATH}, skipping seed."
  exit 0
fi

echo ">> Secret not found, generating new credentials..."

# Generate secrets using OpenBao's server-side random generation
CLIENT_SECRET=$(bao write -f -field=random_bytes sys/tools/random/48 format=hex)

echo ">> Writing secrets to ${SECRET_PATH}..."
if [ "${MODE}" = "oauth" ]; then
  COOKIE_SECRET=$(bao write -f -field=random_bytes sys/tools/random/16 format=hex)
  bao kv put -mount="${VAULT_MOUNT}" "${SECRET_PATH}" \
    clientId="${CLIENT_ID}" \
    clientSecret="${CLIENT_SECRET}" \
    cookie="${COOKIE_SECRET}"
else
  bao kv put -mount="${VAULT_MOUNT}" "${SECRET_PATH}" \
    clientId="${CLIENT_ID}" \
    clientSecret="${CLIENT_SECRET}"
fi

echo ">> Seed complete for ${APP_NAME}"
