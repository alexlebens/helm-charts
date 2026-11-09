# Helm Package Standards

- Always adhere to Helm v2 `Chart.yaml` schema with semantic versioning (`X.Y.Z`) and Renovate annotations above
  `appVersion`.
- Strictly use kebab-case resource kind naming for all template files (e.g. `service-account.yaml`, never
  `config.yaml`).
- Always validate chart modifications locally using `mise run check-chart <name>` (or `mise run helm:build <name>`),
  `mise run check:chart --charts "<name>"`, and `mise run check:kubeconform --chart "<name>"`.
- Load the `helm-package-authoring` skill when authoring, modifying, or testing charts.
- Whenever changing chart versions, inputs, or dependencies, update `charts/<name>/README.md` and sync
  `docs/docs/Helm Charts/<name>.md`.
