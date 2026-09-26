# s3-bucket

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![AppVersion: v1.75.1](https://img.shields.io/badge/AppVersion-v1.75.1-informational?style=flat-square)

Unified S3 Bucket subchart with ExternalSecret and Rclone backups

**Homepage:** <https://gitea.alexlebens.dev/alexlebens/helm-charts/src/branch/main/charts/s3-bucket>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://gitea.alexlebens.dev/alexlebens/helm-charts>
* <https://github.com/rclone/rclone>
* <https://hub.docker.com/r/rclone/rclone>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels | object | `{}` | Add additional labels |
| backups | object | `{"a":{"cronJob":{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 3 * * *","successfulJobsHistoryLimit":1,"suspend":false,"timeZone":"America/Chicago"},"destination":{"bucketName":"","endpoint":"http://synology.alexlebens.dev:3900","providerType":"Other"},"enabled":false,"externalSecret":{"accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"regionKeyProperty":"ACCESS_REGION","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPathPrefix":"/garage/home-infra","storeName":"openbao"}},"b":{"cronJob":{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 1 * * *","successfulJobsHistoryLimit":1,"suspend":false,"timeZone":"America/Chicago"},"destination":{"bucketName":"","endpoint":"http://garage-cluster-b.garage-operator:3900","providerType":"Other"},"enabled":false,"externalSecret":{"accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"regionKeyProperty":"ACCESS_REGION","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPathPrefix":"/garage/home-infra","storeName":"openbao"}},"c":{"cronJob":{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 4 * * *","successfulJobsHistoryLimit":1,"suspend":false,"timeZone":"America/Chicago"},"destination":{"bucketName":"","endpoint":"http://ps10rp.alexlebens.dev:3900","providerType":"Other"},"enabled":false,"externalSecret":{"accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"regionKeyProperty":"ACCESS_REGION","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPathPrefix":"/garage/home-infra","storeName":"openbao"}},"d":{"cronJob":{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 2 * * *","successfulJobsHistoryLimit":1,"suspend":false,"timeZone":"America/Chicago"},"destination":{"bucketName":"","endpoint":"https://s3.us-east-005.backblazeb2.com","providerType":"Other"},"enabled":false,"externalSecret":{"accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"regionKeyProperty":"ACCESS_REGION","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPathPrefix":"/backblaze/home-infra","storeName":"openbao"},"prune":{"ageToPrune":"90d","enabled":false}},"image":{"repository":"rclone/rclone","tag":"1.75.1@sha256:45401ad7410db1d67ffdb58e19059ad20b0d8e0285a60e38bbec55cc1019c7a5"}}` | Rclone Backup Configuration Targets can be single-letter shorthands ("a", "b", "c", "d") or full keys ("a_ps02sn", "b_cl01tl", etc.) |
| bucketName | string | `""` | The name of the bucket to create (defaults to .Release.Name) |
| cors | object | `{"allowedHeaders":["*"],"allowedMethods":["GET","HEAD"],"allowedOrigins":["*"],"enabled":false,"exposeHeaders":["ETag"],"maxAgeSeconds":3600}` | CORS Configuration (provisioned via OpenTofu) |
| externalSecret | object | `{"accessKeyIdPath":"","accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"regionKeyPath":"","regionProperty":"ACCESS_REGION","secretAccessKeyPath":"","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPath":"","secretPathPrefix":"/garage/home-infra","storeName":"openbao"}` | ExternalSecret configuration to fetch bucket credentials from OpenBao |
| ntfy | object | `{"enabled":true,"externalSecret":{"enabled":true,"storeName":"openbao","tokenPath":"/cl01tl/ntfy/users/cl01tl","tokenProperty":"token","topicPath":"/cl01tl/ntfy/topics","topicProperty":"rclone","urlPath":"/cl01tl/ntfy/config","urlProperty":"internal-endpoint"}}` | Ntfy notifications for backup/prune results |
| podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for CronJob pods |
| resources | object | `{"limits":{"memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits for CronJob containers |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Security context for CronJob containers |
| target | string | `"b"` | Primary target tier. Single letter shorthands preferred: - "a" or "a_ps02sn": Heavy data stores & bulk backups on Synology NAS (ps02sn) - "b" or "b_cl01tl": Low-latency lightweight app assets on Talos K8s cluster (cl01tl) - "c" or "c_ps10rp": Secondary on-prem storage on Raspberry Pi (ps10rp) - "d" or "d_cs01bb": Offsite cloud DR replication on Backblaze B2 (cs01bb) |
| website | object | `{"enabled":false,"errorDocument":"error.html","indexDocument":"index.html"}` | Bucket Website (provisioned via OpenTofu) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
