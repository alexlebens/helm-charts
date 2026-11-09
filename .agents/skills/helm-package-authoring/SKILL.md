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

# 1. Lint the chart, update repos, build dependencies, and run unit tests
mise run lint:chart <chart-name>

# 2. Run chart-testing (ct lint)
mise run test:chart --charts "<chart-name>"

# 3. Validate rendered manifests against Kubernetes & CRD schemas with kubeconform
mise run validate:kubeconform --chart "<chart-name>"

# 4. Run Bats tests for .mise tasks and automation scripts
mise run test
```

---

## 4. Documentation & Downstream Sync

- Whenever modifying values, defaults, or capabilities of a chart in `helm-charts/`, update its local
  `charts/<chart-name>/README.md` (and generate schema if applicable).
- Update the sibling documentation repository (`docs/docs/Helm Charts/<chart-name>.md`) following
  `docs/.agents/rules/docs-core.md` to reflect the new chart version and configuration changes.
