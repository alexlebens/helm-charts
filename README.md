<div align="center">
  <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/helm.png" width="120" alt="Helm Logo" />
  <h1>Alex Lebens' Helm Charts</h1>
  <p><em>A collection of custom Helm charts for deploying applications and services to Kubernetes clusters.</em></p>
</div>

---

Welcome to the documentation for my personal Helm charts repository! This repository hosts custom-built Helm charts that I use to deploy various applications across my GitOps infrastructure.

## Features

- **Custom Chart Configurations**: Tailor-made charts designed specifically for Homelab applications and configurations.
- **Automated CI/CD**: Gitea Actions automatically lint, test, package, and release new versions of these charts.
- **Dependency Management**: Fully integrated with Renovate to automatically update dependencies and base configurations.

## Prerequisites

[Helm](https://helm.sh) must be installed to use the charts provided in this repository. Refer to the official Helm [documentation](https://helm.sh/docs/) if you need help getting started.

## Installation & Usage

1. **Add the Repository:**

   ```bash
   helm repo add alexlebens http://alexlebens.github.io/helm-charts/
   ```

2. **Update the Repository:**

   ```bash
   helm repo update
   ```

3. **Search for Available Charts:**
   ```bash
   helm search repo alexlebens
   ```

You can now install any of the available charts directly into your cluster using standard Helm commands.

## Repository Structure

- `charts/`: The source directory containing all custom Helm charts.

## License

This project is open-source and licensed under the terms of the Apache 2.0 License. See the [LICENSE](LICENSE) file for more details.
