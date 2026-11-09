# volsync-target

![Version: 4.1.1](https://img.shields.io/badge/Version-4.1.1-informational?style=flat-square) ![AppVersion: 0.17.0](https://img.shields.io/badge/AppVersion-0.17.0-informational?style=flat-square)

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
| a | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps02sn/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps02sn/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"repair":{"enabled":false,"token":""},"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"restore":{"enabled":false,"manual":""},"schedule":"0 8 * * *"}` | Tier A: On-prem Synology NAS backup configuration (ps02sn) |
| a.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps02sn/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps02sn/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| a.manual | string | `""` | Manual backup trigger token for this tier |
| a.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| a.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| a.paused | bool | `false` | Pause backups for this tier |
| a.repair | object | `{"enabled":false,"token":""}` | Repair Job for this tier. Set `enabled` and change `token` to run restic repair on demand |
| a.repair.enabled | bool | `false` | Create the repair Job for this tier |
| a.repair.token | string | `""` | Unique token appended to the Job name; change it to re-run the repair |
| a.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| a.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| a.restore | object | `{"enabled":false,"manual":""}` | Restore overrides for this tier. Set `enabled` and a unique `manual` token to run a restore from GitOps |
| a.restore.enabled | bool | `false` | Create a ReplicationDestination for this tier |
| a.restore.manual | string | `""` | Trigger token; change it to run another restore |
| a.schedule | string | `"0 8 * * *"` | 5 character cron schedule |
| additionalLabels | object | `{}` | Add additional labels |
| b | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cl01tl/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cl01tl/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"repair":{"enabled":false,"token":""},"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"restore":{"enabled":false,"manual":""},"schedule":"0 7 * * *"}` | Tier B: In-cluster backup configuration (cl01tl) |
| b.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cl01tl/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cl01tl/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| b.manual | string | `""` | Manual backup trigger token for this tier |
| b.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| b.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| b.paused | bool | `false` | Pause backups for this tier |
| b.repair | object | `{"enabled":false,"token":""}` | Repair Job for this tier. Set `enabled` and change `token` to run restic repair on demand |
| b.repair.enabled | bool | `false` | Create the repair Job for this tier |
| b.repair.token | string | `""` | Unique token appended to the Job name; change it to re-run the repair |
| b.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":7,"hourly":0,"monthly":0,"weekly":4,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| b.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| b.restore | object | `{"enabled":false,"manual":""}` | Restore overrides for this tier. Set `enabled` and a unique `manual` token to run a restore from GitOps |
| b.restore.enabled | bool | `false` | Create a ReplicationDestination for this tier |
| b.restore.manual | string | `""` | Trigger token; change it to run another restore |
| b.schedule | string | `"0 7 * * *"` | 5 character cron schedule |
| c | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps10rp/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps10rp/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"repair":{"enabled":false,"token":""},"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":6,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"restore":{"enabled":false,"manual":""},"schedule":"0 10 * * 0"}` | Tier C: Remote Raspberry Pi backup configuration (ps10rp) |
| c.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/ps10rp/garage/config","bucketProperty":"BUCKET_NAME","credentialPath":"/ps10rp/garage/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| c.manual | string | `""` | Manual backup trigger token for this tier |
| c.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| c.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| c.paused | bool | `false` | Pause backups for this tier |
| c.repair | object | `{"enabled":false,"token":""}` | Repair Job for this tier. Set `enabled` and change `token` to run restic repair on demand |
| c.repair.enabled | bool | `false` | Create the repair Job for this tier |
| c.repair.token | string | `""` | Unique token appended to the Job name; change it to re-run the repair |
| c.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":7,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":6,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| c.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| c.restore | object | `{"enabled":false,"manual":""}` | Restore overrides for this tier. Set `enabled` and a unique `manual` token to run a restore from GitOps |
| c.restore.enabled | bool | `false` | Create a ReplicationDestination for this tier |
| c.restore.manual | string | `""` | Trigger token; change it to run another restore |
| c.schedule | string | `"0 10 * * 0"` | 5 character cron schedule |
| d | object | `{"enabled":false,"externalSecret":{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cs01bb/s3/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cs01bb/s3/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"},"manual":"","maxSyncLag":"","moverSecurityContext":{},"paused":false,"repair":{"enabled":false,"token":""},"restic":{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":35,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":6,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"},"restore":{"enabled":false,"manual":""},"schedule":"0 9 * * 0"}` | Tier D: Cloud DR replication on Backblaze B2 (cs01bb) |
| d.externalSecret | object | `{"accessKeyIdProperty":"AWS_ACCESS_KEY_ID","bucketPath":"/cs01bb/s3/config","bucketProperty":"BUCKET_NAME","credentialPath":"/cs01bb/s3/keys/volsync-backups","enabled":true,"endpointProperty":"ENDPOINT","regionProperty":"AWS_REGION","resticPasswordProperty":"RESTIC_PASSWORD","secretAccessKeyProperty":"AWS_SECRET_ACCESS_KEY","storeName":"openbao"}` | External Secret configuration |
| d.manual | string | `""` | Manual backup trigger token for this tier |
| d.maxSyncLag | string | `""` | Optional override for max sync lag threshold in seconds (auto-computed from schedule if unset) |
| d.moverSecurityContext | object | `{}` | Tier-specific mover security context |
| d.paused | bool | `false` | Pause backups for this tier |
| d.repair | object | `{"enabled":false,"token":""}` | Repair Job for this tier. Set `enabled` and change `token` to run restic repair on demand |
| d.repair.enabled | bool | `false` | Create the repair Job for this tier |
| d.repair.token | string | `""` | Unique token appended to the Job name; change it to re-run the repair |
| d.restic | object | `{"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","copyMethod":"Snapshot","pruneIntervalDays":35,"repository":"","retain":{"daily":0,"hourly":0,"monthly":0,"weekly":6,"yearly":0},"storageClassName":"ceph-block","unlock":"","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Backup configuration, inserted directly into the yaml |
| d.restic.unlock | string | `""` | Unlock token to clear stale restic repository locks for this tier |
| d.restore | object | `{"enabled":false,"manual":""}` | Restore overrides for this tier. Set `enabled` and a unique `manual` token to run a restore from GitOps |
| d.restore.enabled | bool | `false` | Create a ReplicationDestination for this tier |
| d.restore.manual | string | `""` | Trigger token; change it to run another restore |
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
| repair | object | `{"backoffLimit":0,"check":true,"extraArgs":[],"image":{"pullPolicy":"IfNotPresent","repository":"docker.io/restic/restic","tag":"0.19.1"},"podSecurityContext":{},"readDataSubset":"","repairIndex":true,"repairSnapshots":false,"resources":{},"securityContext":{},"ttlSecondsAfterFinished":86400,"unlock":true}` | On demand restic repair Job (defaults shared by all tiers; enable per tier under `<tier>.repair`) |
| repair.backoffLimit | int | `0` | Job backoff limit |
| repair.check | bool | `true` | Run `restic check` after repair |
| repair.extraArgs | list | `[]` | Extra arguments appended to every restic command (e.g. ["--verbose"]) |
| repair.image | object | `{"pullPolicy":"IfNotPresent","repository":"docker.io/restic/restic","tag":"0.19.1"}` | Image used to run restic |
| repair.podSecurityContext | object | `{}` | Job pod security context |
| repair.readDataSubset | string | `""` | Optional `--read-data-subset` for restic check (e.g. "10%"); empty checks structure only |
| repair.repairIndex | bool | `true` | Run `restic repair index` (rebuilds index from pack files) |
| repair.resources | object | `{}` | Job resources |
| repair.securityContext | object | `{}` | Job container security context |
| repair.ttlSecondsAfterFinished | int | `86400` | Seconds before the finished Job is garbage collected |
| repair.unlock | bool | `true` | Run `restic unlock` before repairing |
| restore | object | `{"accessModes":[],"cacheAccessModes":[],"cacheCapacity":"1Gi","cacheStorageClassName":"","capacity":"","copyMethod":"Direct","destinationPVC":"","moverSecurityContext":{},"previous":"","restoreAsOf":"","storageClassName":"ceph-block","volumeSnapshotClassName":"ceph-blockpool-snapshot"}` | Restore from backup via ReplicationDestination (defaults shared by all tiers; override per tier under `<tier>.restore`) |
| restore.accessModes | list | `[]` | Access modes for the destination volume |
| restore.cacheAccessModes | list | `[]` | Restic cache access modes |
| restore.cacheCapacity | string | `"1Gi"` | Restic cache capacity for the mover |
| restore.cacheStorageClassName | string | `""` | Restic cache storage class |
| restore.capacity | string | `""` | Capacity of the destination volume, only needed if the chart/volsync must provision it |
| restore.copyMethod | string | `"Direct"` | Copy method for the restore (Direct writes into destinationPVC, Snapshot creates a VolumeSnapshot) |
| restore.destinationPVC | string | `""` | Restore destination PVC. Defaults to `pvcTarget` |
| restore.moverSecurityContext | object | `{}` | Mover security context for restore |
| restore.previous | string | `""` | Skip this many snapshots back from the selected one (0 = latest) |
| restore.restoreAsOf | string | `""` | Restore the latest snapshot taken at or before this RFC-3339 timestamp (e.g. "2026-11-01T00:00:00Z") |
| restore.storageClassName | string | `"ceph-block"` | Storage class for the destination volume |
| restore.volumeSnapshotClassName | string | `"ceph-blockpool-snapshot"` | Volume snapshot class (used with copyMethod Snapshot) |
| unlock | string | `""` | Global unlock token to clear stale restic repository locks across all tiers |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
