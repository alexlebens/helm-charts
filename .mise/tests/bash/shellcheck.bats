#!/usr/bin/env bats

setup() {
  load 'test_helper/common-setup'
  _common_setup
}

@test "shellcheck: all .mise/lib bash scripts pass shellcheck" {
  local scripts=()
  while IFS= read -r -d '' file; do
    scripts+=("$file")
  done < <(find "${PROJECT_ROOT}/.mise/lib" -type f -name "*.sh" -print0 2>/dev/null)

  if [ ${#scripts[@]} -eq 0 ]; then
    skip "No bash scripts found in .mise/lib"
  fi

  run shellcheck "${scripts[@]}"
  assert_success
}

@test "shellcheck: all .mise/tasks bash scripts pass shellcheck" {
  local scripts=()
  while IFS= read -r -d '' file; do
    if head -n 1 "$file" | grep -qE '^#!/(usr/)?bin/(env )?bash'; then
      scripts+=("$file")
    fi
  done < <(find "${PROJECT_ROOT}/.mise/tasks" -type f -print0 2>/dev/null)

  if [ ${#scripts[@]} -eq 0 ]; then
    skip "No bash scripts found in .mise/tasks"
  fi

  run shellcheck "${scripts[@]}"
  assert_success
}
