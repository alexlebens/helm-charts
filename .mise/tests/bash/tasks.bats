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
# check-chart
# -----------------------------------------------------------------------------

@test "check-chart: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/check-chart" --help
  assert_success
  assert_output --partial "Usage: mise run check-chart"
}

# -----------------------------------------------------------------------------
# helm:plugins
# -----------------------------------------------------------------------------

@test "helm:plugins: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/helm/plugins" --help
  assert_success
  assert_output --partial "Usage: mise run helm:plugins"
}

# -----------------------------------------------------------------------------
# helm:repo
# -----------------------------------------------------------------------------

@test "helm:repo: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/helm/repo" --help
  assert_success
  assert_output --partial "Usage: mise run helm:repo"
}

# -----------------------------------------------------------------------------
# helm:dep
# -----------------------------------------------------------------------------

@test "helm:dep: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/helm/dep" --help
  assert_success
  assert_output --partial "Usage: mise run helm:dep"
}

# -----------------------------------------------------------------------------
# helm:lint
# -----------------------------------------------------------------------------

@test "helm:lint: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/helm/lint" --help
  assert_success
  assert_output --partial "Usage: mise run helm:lint"
}

# -----------------------------------------------------------------------------
# helm:build
# -----------------------------------------------------------------------------

@test "helm:build: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/helm/build" --help
  assert_success
  assert_output --partial "Usage: mise run helm:build"
}

# -----------------------------------------------------------------------------
# check:chart
# -----------------------------------------------------------------------------

@test "check:chart: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/check/chart" --help
  assert_success
  assert_output --partial "Usage: mise run check:chart"
}

# -----------------------------------------------------------------------------
# check:kubeconform
# -----------------------------------------------------------------------------

@test "check:kubeconform: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/check/kubeconform" --help
  assert_success
  assert_output --partial "Usage: mise run check:kubeconform"
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
# generate:docs
# -----------------------------------------------------------------------------

@test "generate:docs: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/generate/docs" --help
  assert_success
  assert_output --partial "Usage: mise run generate:docs"
}
