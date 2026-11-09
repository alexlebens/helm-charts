---
name: helm-package-authoring
description:
  Standards, conventions, and validation workflows for authoring, packaging, and releasing reusable homelab Helm charts.
---

# Helm Package Authoring Workflow

This skill governs creating, updating, testing, and releasing reusable Helm charts in
[`helm-charts/`](file:///Users/alexlebens/projects/helm-charts). Unlike infrastructure deployment charts which target
live cluster namespaces, charts in this repository are published as reusable artifacts to Harbor OCI
(`oci://harbor.alexlebens.dev/helm-charts`) and the Gitea ChartMuseum registry.

---

## 1. Chart Metadata & Schema Standards (`Chart.yaml`)

Every chart in `charts/<chart-name>/` must adhere to standard Helm v2 API requirements:

- **`apiVersion`**: Always `v2`.
- **`name`**: Matching directory name in kebab-case (e.g., `valkey`, `s3-bucket`, `pocket-id-client`).
- **`version`**: Semantic versioning (`X.Y.Z`). Increment patch on fixes/docs, minor on feature/dependency upgrades,
  major on breaking schema changes.
- **`appVersion`**: Matching the primary workload/tool version.
- **Renovate Annotation**: Always place the Renovate directive directly above `appVersion`:
  ```yaml
  # renovate: datasource=github-releases depName=org/repo
  appVersion: 1.2.3
  ```
  _(or `datasource=docker depName=...` if pinning to an upstream container image)._
- **`home` & `sources`**: Point `home` to the chart directory in Gitea, and list upstream source repositories.
- **`maintainers`**: List `alexlebens`.
- **`icon`**: Use selfh.st icons via `https://cdn.jsdelivr.net/gh/selfhst/icons@main/png/<name>.png`.

---

## 2. Values & Templating Standards

- **Kebab-Case Templates**: Every template under `templates/` must represent one resource kind named in kebab-case (e.g.
  `service-account.yaml`, `external-secret.yaml`, `config-map.yaml`). Never use generic names like `config.yaml`.
- **Documented Values**: All keys in `values.yaml` must include clear comments explaining their function and default
  state.
- **Dependencies (`Chart.yaml` & `Chart.lock`)**:
  - Declare external upstream dependencies in `dependencies:`.
  - Always run `helm dependency build charts/<name>` to generate or refresh `Chart.lock` before testing.

---

## 3. Testing & Validation

Always run the full validation pipeline before submitting changes:

```bash
# 0. Ensure required Helm plugins are installed (cm-push, unittest)
mise run helm:plugins

# 1. Validate the chart, update repos, build dependencies, and run unit tests
mise run check-chart <chart-name>
# Or test individual steps:
# mise run helm:repo <chart-name>
# mise run helm:dep <chart-name>
# mise run helm:lint <chart-name>
# mise run helm:build <chart-name>

# 2. Run chart-testing (ct lint)
mise run check:chart --charts "<chart-name>"

# 3. Validate rendered manifests against Kubernetes & CRD schemas with kubeconform
mise run check:kubeconform --chart "<chart-name>"

# 4. Scan rendered manifests with Trivy for security misconfigurations
mise run check:trivy --chart "<chart-name>"

# 5. Run Bats tests for .mise tasks and automation scripts
mise run test
```

### Test Conventions

- **Unit tests required**: every chart with `templates/*.yaml` must have `tests/*_test.yaml` helm-unittest suites (one
  per template, named `<template>_test.yaml`). `mise run helm:lint` fails otherwise.
- **CI scenarios**: add non-default values under `charts/<name>/ci/*-values.yaml`; `ct lint` and kubeconform render
  each.
- **Snapshots**: use `matchSnapshot` for large rendered resources; commit `tests/__snapshot__/`.
- **Schemas**: provide a permissive `values.schema.json` typing key values (avoid `additionalProperties: false`).
- **Known bugs**: mark with `skip: { reason: ... }` plus a comment rather than deleting the test.

---

## 4. Documentation & Downstream Sync

- Whenever modifying values, defaults, or capabilities of a chart in `helm-charts/`, update its local
  `charts/<chart-name>/README.md` (and generate schema if applicable).
- Update the sibling documentation repository (`docs/docs/Helm Charts/<chart-name>.md`) following
  `docs/.agents/rules/docs-core.md` to reflect the new chart version and configuration changes.
