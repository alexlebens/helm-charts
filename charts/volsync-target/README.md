# volsync-target

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![AppVersion: 0.16.0](https://img.shields.io/badge/AppVersion-0.16.0-informational?style=flat-square)

Volsync Replication set to target specific PVC with preconfigured settings

**Homepage:** <https://gitea.alexlebens.dev/alexlebens/helm-charts/src/branch/main/charts/volsync-target>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://gitea.alexlebens.dev/alexlebens/helm-charts>
* <https://github.com/backube/volsync>
* <https://github.com/backube/volsync/tree/main/helm/volsync>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| a | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps02sn/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps02sn/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 8 * * *"}` | Tier A: On-prem Synology NAS backup configuration (ps02sn) |
| a.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps02sn/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps02sn/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| a.manual | string | `""` | Manual backup trigger token for this tier |
| a.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| a.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| a.paused | bool | `false` | Pause backups for this tier |
| a.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| a.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| a.schedule | string | `"0 8 * * *"` | 5 character cron schedule |
| additionalLabels | object | `{}` | Add additional labels |
| b | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cl01tl/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cl01tl/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 7 * * *"}` | Tier B: In-cluster backup configuration (cl01tl) |
| b.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cl01tl/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cl01tl/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| b.manual | string | `""` | Manual backup trigger token for this tier |
| b.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| b.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| b.paused | bool | `false` | Pause backups for this tier |
| b.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| b.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| b.schedule | string | `"0 7 * * *"` | 5 character cron schedule |
| c | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps10rp/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps10rp/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 10 * * 0"}` | Tier C: Remote Raspberry Pi backup configuration (ps10rp) |
| c.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps10rp/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps10rp/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| c.manual | string | `""` | Manual backup trigger token for this tier |
| c.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| c.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| c.paused | bool | `false` | Pause backups for this tier |
| c.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| c.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| c.schedule | string | `"0 10 * * 0"` | 5 character cron schedule |
| d | object | `{"enabled":true,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cs01bb/s3/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cs01bb/s3/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":35,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 9 * * 0"}` | Tier D: Cloud DR replication on Backblaze B2 (cs01bb) |
| d.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cs01bb/s3/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cs01bb/s3/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| d.manual | string | `""` | Manual backup trigger token for this tier |
| d.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| d.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| d.paused | bool | `false` | Pause backups for this tier |
| d.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":35,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| d.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| d.schedule | string | `"0 9 * * 0"` | 5 character cron schedule |
| externalSecrets | object | `{"enabled":true}` | Use external secrets |
| kubernetesClusterName | string | `"cl01tl"` | Kubernetes cluster name |
| manual | string | `""` | Trigger manual backup execution across all tiers by setting an arbitrary token (e.g. "run-1") |
| moverSecurityContext | object | `{}` | Global security context for restic mover |
| nameOverride | string | `""` | Default pattern follows <pvcTarget>-backup |
| namespaceOverride | string | `""` | Override the namespace of the chart |
| paused | bool | `false` | Pause all backups globally across all tiers |
| prometheusRule | object | `{"backupDelayed":{"enabled":true,"maxSyncLag":""},"enabled":true}` | Prometheus Rule |
| prometheusRule.backupDelayed | object | `{"enabled":true,"maxSyncLag":""}` | Alert on delayed/stale backups based on cron schedule |
| prometheusRule.backupDelayed.maxSyncLag | string | `""` | Override max sync lag threshold in seconds (auto-computed from cron schedule if unset) |
| pvcTarget | string | `"data"` | Name of the PVC target |
| unlock | string | `""` | Global unlock token to clear stale restic repository locks across all tiers |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
