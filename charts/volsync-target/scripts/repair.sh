#!/bin/sh
set -e

restic version

# shellcheck disable=SC2086
if [ "${UNLOCK:-false}" = "true" ]; then
  restic unlock ${EXTRA_ARGS}
fi

# shellcheck disable=SC2086
if [ "${REPAIR_INDEX:-false}" = "true" ]; then
  restic repair index ${EXTRA_ARGS}
fi

# shellcheck disable=SC2086
if [ "${REPAIR_SNAPSHOTS:-false}" = "true" ]; then
  restic repair snapshots --forget ${EXTRA_ARGS}
fi

# shellcheck disable=SC2086
if [ "${CHECK:-false}" = "true" ]; then
  if [ -n "${READ_DATA_SUBSET:-}" ]; then
    restic check --read-data-subset="${READ_DATA_SUBSET}" ${EXTRA_ARGS}
  else
    restic check ${EXTRA_ARGS}
  fi
fi
