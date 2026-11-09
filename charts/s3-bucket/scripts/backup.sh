#!/usr/bin/env bash
set -eo pipefail

send_ntfy() {
  title="$1"
  priority="$2"
  message="$3"

  if [ "${NTFY_ENABLED}" != "true" ] || [ -z "${NTFY_URL:-}" ]; then
    return 0
  fi

  if [ -n "${NTFY_TOKEN:-}" ]; then
    wget -qO- --header "Authorization: Bearer ${NTFY_TOKEN}" --header "Title: ${title}" --header "Priority: ${priority}" --post-data "${message}" "${NTFY_URL}"
  else
    wget -qO- --header "Title: ${title}" --header "Priority: ${priority}" --post-data "${message}" "${NTFY_URL}"
  fi
}

# --- ${MODE} Phase ---
# shellcheck disable=SC2086
rclone ${MODE} \
  "src:${SRC_BUCKET}" \
  "dest:${DEST_BUCKET}" \
  --s3-no-check-bucket \
  ${RCLONE_EXCLUDE_FLAGS} \
  --verbose 2>&1 | tee /tmp/rclone-sync.log

sync_res=$?

if [ "${NTFY_ENABLED}" = "true" ]; then
  STATS=$(grep "Transferred:" /tmp/rclone-sync.log | tail -n 2)
  DATA_TRANS=$(echo "${STATS}" | head -n 1 | sed 's/.*Transferred:[ \t]*//')
  if [ -z "${DATA_TRANS}" ]; then DATA_TRANS="Unknown"; fi

  if [ ${sync_res} -eq 0 ]; then
    send_ntfy "✅ ${JOB_TYPE_TITLE}Backup - ${SRC_BUCKET} - ${BACKUP_NAME}" "3" "Job for ${BACKUP_NAME} transferred: ${DATA_TRANS}"
  else
    send_ntfy "🚨 ${JOB_TYPE_TITLE}Backup - ${SRC_BUCKET} - ${BACKUP_NAME}" "4" "Job for ${BACKUP_NAME} failed, transferred: ${DATA_TRANS}"
    exit ${sync_res}
  fi
else
  if [ ${sync_res} -ne 0 ]; then exit ${sync_res}; fi
fi

if [ "${PRUNE_ENABLED}" = "true" ]; then
  # --- Prune Phase ---
  rclone delete \
    "dest:${DEST_BUCKET}" \
    --min-age "${PRUNE_AGE}" \
    --verbose 2>&1 | tee /tmp/rclone-prune.log

  prune_res=$?

  if [ "${NTFY_ENABLED}" = "true" ]; then
    STATS=$(grep "Deleted:" /tmp/rclone-prune.log | tail -n 1)
    # shellcheck disable=SC2001
    FILES_PRUNED=$(echo "${STATS}" | sed 's/.*Deleted:[ \t]*//')
    if [ -z "${FILES_PRUNED}" ]; then FILES_PRUNED="0 files"; fi

    if [ ${prune_res} -eq 0 ]; then
      send_ntfy "✅ Prune - ${SRC_BUCKET} - ${BACKUP_NAME}" "3" "Job for ${BACKUP_NAME} pruned: ${FILES_PRUNED}"
    else
      send_ntfy "🚨 Prune - ${SRC_BUCKET} - ${BACKUP_NAME}" "4" "Job for ${BACKUP_NAME} failed, pruned: ${FILES_PRUNED}"
    fi
  fi

  exit ${prune_res}
fi
