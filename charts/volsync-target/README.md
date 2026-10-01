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
| a | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps02sn/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps02sn/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"restic":{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 8 * * *"}` | Tier A: On-prem Synology NAS backup configuration (ps02sn) |
| a.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps02sn/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps02sn/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| a.restic | object | `{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| a.schedule | string | `"0 8 * * *"` | 5 character cron schedule |
| additionalLabels | object | `{}` | Add additional labels |
| b | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cl01tl/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cl01tl/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"restic":{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 7 * * *"}` | Tier B: In-cluster backup configuration (cl01tl) |
| b.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cl01tl/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cl01tl/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| b.restic | object | `{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| b.schedule | string | `"0 7 * * *"` | 5 character cron schedule |
| c | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps10rp/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps10rp/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"restic":{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 10 * * 0"}` | Tier C: Remote Raspberry Pi backup configuration (ps10rp) |
| c.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps10rp/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps10rp/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| c.restic | object | `{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| c.schedule | string | `"0 10 * * 0"` | 5 character cron schedule |
| d | object | `{"enabled":true,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cs01bb/s3/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cs01bb/s3/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"restic":{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":35,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"schedule":"0 9 * * 0"}` | Tier D: Cloud DR replication on Backblaze B2 (cs01bb) |
| d.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cs01bb/s3/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cs01bb/s3/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| d.restic | object | `{"cacheCapacity":"1Gi","copyMethod":"Snapshot","pruneIntervalDays":35,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":12,"yearly":0},"storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| d.schedule | string | `"0 9 * * 0"` | 5 character cron schedule |
| externalSecrets | object | `{"enabled":true}` | Use external secrets |
| kubernetesClusterName | string | `"cl01tl"` | Kubernetes cluster name |
| moverSecurityContext | object | `{}` | Glocal security context for restic mover |
| nameOverride | string | `""` | Default pattern follows <pvcTarget>-backup |
| namespaceOverride | string | `""` | Override the namespace of the chart |
| prometheusRule | object | `{"enabled":true}` | Prometheus Rule |
| pvcTarget | string | `"data"` | Name of the PVC target |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
