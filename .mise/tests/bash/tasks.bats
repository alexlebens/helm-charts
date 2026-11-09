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
# check:trivy
# -----------------------------------------------------------------------------

@test "check:trivy: --help prints usage" {
  run "${PROJECT_ROOT}/.mise/tasks/check/trivy" --help
  assert_success
  assert_output --partial "Usage: mise run check:trivy"
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

# -----------------------------------------------------------------------------
# helm:lint unit test coverage gate
# -----------------------------------------------------------------------------

_setup_lint_sandbox() {
  LINT_ROOT="${BATS_TEST_TMPDIR}/repo"
  mkdir -p "${LINT_ROOT}/.mise" "${LINT_ROOT}/charts/${1}/templates"
  cp -R "${PROJECT_ROOT}/.mise/lib" "${LINT_ROOT}/.mise/lib"
  printf 'apiVersion: v2\nname: %s\nversion: 0.1.0\n' "${1}" > "${LINT_ROOT}/charts/${1}/Chart.yaml"
  printf 'kind: ConfigMap\n' > "${LINT_ROOT}/charts/${1}/templates/config-map.yaml"
  printf '{}\n' > "${LINT_ROOT}/charts/${1}/values.schema.json"
  _stub helm 'exit 0'
  export MISE_PROJECT_ROOT="${LINT_ROOT}"
}

@test "helm:lint: fails for a chart with templates but no unit tests" {
  _setup_lint_sandbox demo
  run "${PROJECT_ROOT}/.mise/tasks/helm/lint" demo
  assert_failure
  assert_output --partial "has templates but no unit tests"
}

@test "helm:lint: passes the coverage gate when unit tests exist" {
  _setup_lint_sandbox demo
  mkdir -p "${LINT_ROOT}/charts/demo/tests"
  printf 'suite: demo\ntests: []\n' > "${LINT_ROOT}/charts/demo/tests/config-map_test.yaml"
  run "${PROJECT_ROOT}/.mise/tasks/helm/lint" demo
  assert_success
}

@test "helm:lint: does not require unit tests for charts without templates" {
  _setup_lint_sandbox demo
  rm "${LINT_ROOT}/charts/demo/templates/config-map.yaml"
  run "${PROJECT_ROOT}/.mise/tasks/helm/lint" demo
  assert_success
}

@test "helm:lint: fails for a chart without values.schema.json" {
  _setup_lint_sandbox demo
  mkdir -p "${LINT_ROOT}/charts/demo/tests"
  printf 'suite: demo\ntests: []\n' > "${LINT_ROOT}/charts/demo/tests/config-map_test.yaml"
  rm "${LINT_ROOT}/charts/demo/values.schema.json"
  run "${PROJECT_ROOT}/.mise/tasks/helm/lint" demo
  assert_failure
  assert_output --partial "has no values schema"
}
