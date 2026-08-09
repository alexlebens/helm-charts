# garage-bucket

![Version: 0.2.3](https://img.shields.io/badge/Version-0.2.3-informational?style=flat-square) ![AppVersion: v0.7.3](https://img.shields.io/badge/AppVersion-v0.7.3-informational?style=flat-square)

Garage Bucket deployment with Rclone backups

**Homepage:** <https://gitea.alexlebens.net/alexlebens/helm-charts/src/branch/main/charts/garage-bucket>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://gitea.alexlebens.net/alexlebens/helm-charts>
* <https://git.deuxfleurs.fr/Deuxfleurs/garage>
* <https://github.com/rajsinghtech/garage-operator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels | object | `{}` | Add additional labels |
| backups | object | `{"primary":{"cronJob":{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 0 * * *","successfulJobsHistoryLimit":3,"suspend":false,"timeZone":"America/Chicago"},"destination":{"bucketName":"","endpoint":"https://garage-ps10rp.boreal-beaufort.ts.net:3900","providerType":"Other","region":"us-east-1"},"enabled":false,"externalSecret":{"accessKeyIdPath":"","accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"secretAccessKeyPath":"","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPath":"","secretPathPrefix":"/garage/home-infra","storeName":"openbao"},"image":{"repository":"rclone/rclone","tag":"1.75.0@sha256:b06aed988cf5967de7c25be5925240983981c757f4ed1ac9d2fa659d51d60548"},"prune":{"ageToPrune":"90d","enabled":false}},"secondary":{"cronJob":{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 0 * * *","successfulJobsHistoryLimit":3,"suspend":false,"timeZone":"America/Chicago"},"destination":{"bucketName":"","endpoint":"s3.us-east-005.backblazeb2.com","providerType":"Other","region":"us-east-005"},"enabled":false,"externalSecret":{"accessKeyIdPath":"","accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"secretAccessKeyPath":"","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPath":"","secretPathPrefix":"/backblaze/home-infra","storeName":"openbao"},"image":{"repository":"rclone/rclone","tag":"1.75.0@sha256:b06aed988cf5967de7c25be5925240983981c757f4ed1ac9d2fa659d51d60548"},"prune":{"ageToPrune":"90d","enabled":false}}}` | Rclone Backup Configuration Maps dynamically generated GarageBucket to offsite locations via CronJobs. |
| backups.primary.cronJob | object | `{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 0 * * *","successfulJobsHistoryLimit":3,"suspend":false,"timeZone":"America/Chicago"}` | CronJob configuration |
| backups.primary.destination | object | `{"bucketName":"","endpoint":"https://garage-ps10rp.boreal-beaufort.ts.net:3900","providerType":"Other","region":"us-east-1"}` | Destination Bucket |
| backups.primary.externalSecret | object | `{"accessKeyIdPath":"","accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"secretAccessKeyPath":"","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPath":"","secretPathPrefix":"/garage/home-infra","storeName":"openbao"}` | Using ExternalSecret to pull destination credentials from OpenBao/Vault |
| backups.primary.externalSecret.accessKeyIdPath | string | `""` | Override paths per key (takes precedence over secretPath) |
| backups.primary.externalSecret.secretPath | string | `""` | Shared path for both keys (takes precedence over secretPathPrefix) |
| backups.primary.externalSecret.secretPathPrefix | string | `"/garage/home-infra"` | Prefix for auto-generating secretPath as <prefix>/<bucketName> |
| backups.primary.image | object | `{"repository":"rclone/rclone","tag":"1.75.0@sha256:b06aed988cf5967de7c25be5925240983981c757f4ed1ac9d2fa659d51d60548"}` | Default image |
| backups.primary.prune | object | `{"ageToPrune":"90d","enabled":false}` | Prune (optional) |
| backups.secondary.cronJob | object | `{"activeDeadlineSeconds":3600,"backoffLimit":3,"failedJobsHistoryLimit":3,"schedule":"0 0 * * *","successfulJobsHistoryLimit":3,"suspend":false,"timeZone":"America/Chicago"}` | CronJob configuration |
| backups.secondary.destination | object | `{"bucketName":"","endpoint":"s3.us-east-005.backblazeb2.com","providerType":"Other","region":"us-east-005"}` | Destination Bucket |
| backups.secondary.externalSecret | object | `{"accessKeyIdPath":"","accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"secretAccessKeyPath":"","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPath":"","secretPathPrefix":"/backblaze/home-infra","storeName":"openbao"}` | Using ExternalSecret to pull destination credentials from OpenBao/Vault |
| backups.secondary.externalSecret.accessKeyIdPath | string | `""` | Override paths per key (takes precedence over secretPath) |
| backups.secondary.externalSecret.secretPath | string | `""` | Shared path for both keys (takes precedence over secretPathPrefix) |
| backups.secondary.externalSecret.secretPathPrefix | string | `"/backblaze/home-infra"` | Prefix for auto-generating secretPath as <prefix>/<bucketName> |
| backups.secondary.image | object | `{"repository":"rclone/rclone","tag":"1.75.0@sha256:b06aed988cf5967de7c25be5925240983981c757f4ed1ac9d2fa659d51d60548"}` | Default image |
| backups.secondary.prune | object | `{"ageToPrune":"90d","enabled":false}` | Prune (optional) |
| bucketName | string | `""` | The name of the bucket to create (defaults to .Release.Name) |
| externalSecret | object | `{"accessKeyIdPath":"","accessKeyIdProperty":"ACCESS_KEY_ID","enabled":true,"secretAccessKeyPath":"","secretAccessKeyProperty":"ACCESS_SECRET_KEY","secretPath":"","secretPathPrefix":"/garage/home-infra","storeName":"openbao"}` | Configuration for importing an existing key via ExternalSecret If disabled, Garage operator will auto-generate credentials. |
| externalSecret.accessKeyIdPath | string | `""` | Override paths per key (takes precedence over secretPath) |
| externalSecret.secretPath | string | `""` | Shared path for both keys (takes precedence over secretPathPrefix) |
| externalSecret.secretPathPrefix | string | `"/garage/home-infra"` | Prefix for auto-generating secretPath as <prefix>/<bucketName> |
| garageCluster | object | `{"name":"garage-cluster-a","namespace":"garage-operator"}` | GarageCluster reference |
| lifecycle | object | `{"abortIncompleteMultipartUploadDays":7,"expirationDays":0,"rules":[]}` | Bucket Lifecycle Rules (optional) |
| lifecycle.abortIncompleteMultipartUploadDays | int | `7` | Clean up failed multipart uploads after this many days (highly recommended for backups) |
| lifecycle.expirationDays | int | `0` | Delete objects after this many days (set to 0 to disable) |
| lifecycle.rules | list | `[]` | Raw rules array to inject custom lifecycle rules |
| ntfy | object | `{"enabled":true,"externalSecret":{"enabled":true,"storeName":"openbao","tokenPath":"/cl01tl/ntfy/users/cl01tl","tokenProperty":"token","topicPath":"/cl01tl/ntfy/topics","topicProperty":"rclone","urlPath":"/cl01tl/ntfy/config","urlProperty":"internal-endpoint"}}` | Ntfy Sends notifications for results of backup and prune |
| quotas | object | `{"maxObjects":"","maxSize":""}` | Bucket Quotas (optional) |
| referenceGrant | object | `{"enabled":true}` | Configuration for the GarageReferenceGrant Usually the bucket and key are created in the app's namespace. This allows the Garage Operator to process them. Adjust as needed if cross-namespace access is required. |
| resources | object | `{"limits":{"memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits for CronJob and test containers |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for CronJob and test containers |
| website | object | `{"enabled":false,"errorDocument":"error.html","indexDocument":"index.html"}` | Bucket Website (optional) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
