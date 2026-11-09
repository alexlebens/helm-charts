#!/usr/bin/env bats

setup() {
  load 'test_helper/common-setup'
  _common_setup
}

# -----------------------------------------------------------------------------
# gitea:detect-charts
# -----------------------------------------------------------------------------

@test "gitea:detect-charts: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/gitea/detect-charts" --help
  assert_success
  assert_output --partial "Usage: mise run gitea:detect-charts"
}

# -----------------------------------------------------------------------------
# helm:plugins
# -----------------------------------------------------------------------------

@test "helm:plugins: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/helm-plugins" --help
  assert_success
  assert_output --partial "Usage: mise run helm:plugins"
}

# -----------------------------------------------------------------------------
# lint:chart
# -----------------------------------------------------------------------------

@test "lint:chart: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/lint-chart" --help
  assert_success
  assert_output --partial "Usage: mise run lint:chart"
}

# -----------------------------------------------------------------------------
# test:chart
# -----------------------------------------------------------------------------

@test "test:chart: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/test-chart" --help
  assert_success
  assert_output --partial "Usage: mise run test:chart"
}

# -----------------------------------------------------------------------------
# validate:kubeconform
# -----------------------------------------------------------------------------

@test "validate:kubeconform: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/validate-kubeconform" --help
  assert_success
  assert_output --partial "Usage: mise run validate:kubeconform"
}

# -----------------------------------------------------------------------------
# gitea:release-chart
# -----------------------------------------------------------------------------

@test "gitea:release-chart: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/gitea/release-chart" --help
  assert_success
  assert_output --partial "Usage: mise run gitea:release-chart"
}

# -----------------------------------------------------------------------------
# check:workflows
# -----------------------------------------------------------------------------

@test "check:workflows: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/check/workflows" --help
  assert_success
  assert_output --partial "Usage: mise run check:workflows"
}

# -----------------------------------------------------------------------------
# docs:generate
# -----------------------------------------------------------------------------

@test "docs:generate: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/generate-docs" --help
  assert_success
  assert_output --partial "Usage: mise run docs:generate"
}
