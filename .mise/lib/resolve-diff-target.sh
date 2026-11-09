#!/usr/bin/env bash
# Sourceable diff target resolver for Git change detection.

resolve_diff_target() {
  if [ -n "${GITHUB_BASE_REF:-}" ]; then
    DIFF_TARGET="origin/${GITHUB_BASE_REF}"
    git fetch --depth=1 origin "${GITHUB_BASE_REF}" 2>/dev/null || true
  elif [ "${EVENT_NAME}" = "pull_request" ]; then
    DIFF_TARGET="${BASE_BRANCH}"
    TARGET_BRANCH_NAME="${BASE_BRANCH#origin/}"
    git fetch --depth=1 origin "${TARGET_BRANCH_NAME}" 2>/dev/null || true
  elif [ -n "${EVENT_BEFORE}" ] && [ "${EVENT_BEFORE}" != "0000000000000000000000000000000000000000" ]; then
    DIFF_TARGET="${EVENT_BEFORE}"
  elif git rev-parse --verify HEAD^1 >/dev/null 2>&1; then
    DIFF_TARGET="HEAD^1"
  else
    DIFF_TARGET="4b825dc642cb6eb9a060e54bf8d69288fbee4904"
  fi
  export DIFF_TARGET
}
