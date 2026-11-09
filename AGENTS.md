# Agent Guidelines (Helm Charts)

- **Git & Safety**: Read-only git (`status`, `diff`, `log`). Never edit generated `.tgz` packages directly. Use `tmp/`
  for scratch files.
- **Rules & Automation**: Follow declarative chart patterns using `helm lint`, `helm unittest`, and `ct lint`. Run tasks
  via `mise run <task>` (or globally via `mrh <task>`).
- **Validation**: Validate changes with `mise run lint:chart <name>`, `mise run test:chart`,
  `mise run validate:kubeconform --chart <name>`, and `mise run test`.
- **Documentation Sync**: When modifying chart defaults or dependencies, update the corresponding docs in `docs/`
  (`docs/Helm Charts/<chart>.md`).
