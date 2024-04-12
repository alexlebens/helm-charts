## Introduction

[CloudNative PG](https://github.com/cloudnative-pg/cloudnative-pg)

CloudNativePG is the Kubernetes operator that covers the full lifecycle of a highly available PostgreSQL database cluster with a primary/standby architecture, using native streaming replication.

This chart bootstraps a [CNPG](https://github.com/cloudnative-pg/cloudnative-pg) cluster upgraade on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The process is designed to be used in conjunction with the [postgres-cluster](https://github.com/alexlebens/helm-charts/tree/main/charts/postgres-cluster) chart. The cluster in this chart connects to the orignal cluster, peforms an upgrade, then backups to the objectStore endpoint. Afterwards the upgrade cluster is removed and the orignal cluster bootstraps from the upgrade's backup.

## Prerequisites

- Kubernetes
- Helm
- CloudNative PG Operator

## Parameters

See the [values files](values.yaml).
