# Agent Guidelines (Helm Charts)

- **Git & Safety**: Read-only git (`status`, `diff`, `log`). Never edit generated `.tgz` packages directly. Use `tmp/`
  for scratch files.
- **Rules & Skills**: Follow `.agents/rules/chart-core.md` and load the `helm-package-authoring` skill when authoring,
  modifying, or testing reusable charts.
- **Validation**: Validate changes with `mise run check-chart <name>` (or `mise run helm:build <name>`),
  `mise run check:chart --charts "<name>"`, `mise run check:kubeconform --chart "<name>"`,
  `mise run check:trivy --chart "<name>"`, and `mise run test`.
- **Documentation Sync**: When modifying chart defaults or versions, update the local chart README and the corresponding
  documentation in `docs/docs/Helm Charts/<name>.md`.
