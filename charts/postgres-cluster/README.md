# postgres-cluster

![Version: 4.0.2](https://img.shields.io/badge/Version-4.0.2-informational?style=flat-square) ![AppVersion: v1.25.0](https://img.shields.io/badge/AppVersion-v1.25.0-informational?style=flat-square)

Chart for cloudnative-pg cluster

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://github.com/cloudnative-pg/cloudnative-pg>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.backupIndex | int | `1` | Generate external cluster name, creates: postgresql-{{ .Release.Name }}-cluster-backup-index-{{ .Values.backups.backupIndex }}" |
| backup.backupName | string | `""` | Name of the backup cluster in the object store, defaults to "cluster.name" |
| backup.data.compression | string | `"snappy"` | Data compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| backup.data.encryption | string | `""` | Whether to instruct the storage provider to encrypt data files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| backup.data.jobs | int | `2` | Number of data files to be archived or restored in parallel. |
| backup.destinationPath | string | `""` | S3 path starting with "s3://" |
| backup.enabled | bool | `false` |  |
| backup.endpointCA | string | `""` | Specifies secret that contains a CA bundle to validate a privately signed certificate, should contain the key ca-bundle.crt |
| backup.endpointCredentials | string | `""` | Specifies secret that contains S3 credentials, should contain the keys ACCESS_KEY_ID and ACCESS_SECRET_KEY |
| backup.endpointURL | string | `""` | S3 endpoint starting with "https://" |
| backup.historyTags.backupRetentionPolicy | string | `""` |  |
| backup.retentionPolicy | string | `"14d"` | Retention policy for backups |
| backup.schedule | string | `"0 0 0 * * *"` | Scheduled backup in cron format |
| backup.tags | object | `{"backupRetentionPolicy":""}` | Tags to add to backups. Add in key value beneath the type. |
| backup.wal.compression | string | `"snappy"` | WAL compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| backup.wal.encryption | string | `""` | Whether to instruct the storage provider to encrypt WAL files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| backup.wal.maxParallel | int | `2` | Number of WAL files to be archived or restored in parallel. |
| bootstrap | object | `{"initdb":{}}` | Bootstrap is the configuration of the bootstrap process when initdb is used. See: https://cloudnative-pg.io/documentation/current/bootstrap/ See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-bootstrapinitdb |
| bootstrap.initdb | object | `{}` | Example values database: app owner: app secret: "" # Name of the secret containing the initial credentials for the owner of the user database. If empty a new secret will be created from scratch postInitApplicationSQL:   - CREATE TABLE IF NOT EXISTS example; |
| cluster.additionalLabels | object | `{}` |  |
| cluster.affinity | object | `{"enablePodAntiAffinity":true,"topologyKey":"kubernetes.io/hostname"}` | See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-AffinityConfiguration |
| cluster.annotations | object | `{}` |  |
| cluster.enableSuperuserAccess | bool | `false` | Create secret containing credentials of superuser |
| cluster.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/cloudnative-pg/postgresql","tag":"17.2-22"}` | Default image |
| cluster.instances | int | `3` |  |
| cluster.logLevel | string | `"info"` |  |
| cluster.monitoring | object | `{"enabled":false,"podMonitor":{"enabled":true},"prometheusRule":{"enabled":false,"excludeRules":[]}}` | Enable default monitoring and alert rules |
| cluster.postgresGID | int | `26` |  |
| cluster.postgresUID | int | `26` | The UID and GID of the postgres user inside the image |
| cluster.postgresql | object | `{"parameters":{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"128MB"},"shared_preload_libraries":[]}` | Parameters to be set for the database itself See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-PostgresConfiguration |
| cluster.primaryUpdateMethod | string | `"switchover"` | Method to follow to upgrade the primary server during a rolling update procedure, after all replicas have been successfully updated. It can be switchover (default) or in-place (restart). |
| cluster.primaryUpdateStrategy | string | `"unsupervised"` | Strategy to follow to upgrade the primary server during a rolling update procedure, after all replicas have been successfully updated: it can be automated (unsupervised - default) or manual (supervised) |
| cluster.priorityClassName | string | `""` |  |
| cluster.resources | object | `{"limits":{"cpu":"800m","hugepages-2Mi":"256Mi","memory":"1Gi"},"requests":{"cpu":"10m","memory":"256Mi"}}` | Default resources |
| cluster.storage.size | string | `"10Gi"` |  |
| cluster.storage.storageClass | string | `""` |  |
| cluster.walStorage | object | `{"size":"2Gi","storageClass":""}` | Default storage size |
| mode | string | `"standalone"` | Cluster mode of operation. Available modes: * `standalone` - Default mode. Creates new or updates an existing CNPG cluster. * `recovery` - Same as standalone but creates a cluster from a backup, object store or via pg_basebackup * `replica` - Create database as a replica from another CNPG cluster |
| nameOverride | string | `""` | Override the name of the cluster |
| recovery | object | `{"data":{"compression":"snappy","encryption":"","jobs":2},"destinationPath":"","endpointCA":"","endpointCredentials":"","endpointURL":"","pitrTarget":{"time":""},"recoveryIndex":1,"recoveryInstanceName":"","recoveryServerName":"","wal":{"compression":"snappy","encryption":"","maxParallel":2}}` | Recovery settings when booting cluster from external cluster |
| recovery.data.compression | string | `"snappy"` | Data compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| recovery.data.encryption | string | `""` | Whether to instruct the storage provider to encrypt data files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| recovery.data.jobs | int | `2` | Number of data files to be archived or restored in parallel. |
| recovery.endpointCA | string | `""` | Specifies secret that contains a CA bundle to validate a privately signed certificate, should contain the key ca-bundle.crt |
| recovery.endpointCredentials | string | `""` | Specifies secret that contains S3 credentials, should contain the keys ACCESS_KEY_ID and ACCESS_SECRET_KEY |
| recovery.endpointURL | string | `""` | S3 https endpoint and the s3:// path |
| recovery.pitrTarget | object | `{"time":""}` | Point in time recovery target in RFC3339 format |
| recovery.recoveryIndex | int | `1` | Generate external cluster name, uses: {{ .Release.Name }}postgresql-<major version>-cluster-backup-index-{{ .Values.recovery.recoveryIndex }} |
| recovery.recoveryInstanceName | string | `""` | Name of the recovery cluster in the object store, defaults to ".Release.Name" |
| recovery.recoveryServerName | string | `""` | Name of the recovery cluster in the object store, defaults to "cluster.name" |
| recovery.wal.compression | string | `"snappy"` | WAL compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| recovery.wal.encryption | string | `""` | Whether to instruct the storage provider to encrypt WAL files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| recovery.wal.maxParallel | int | `2` | Number of WAL files to be archived or restored in parallel. |
| replica.externalCluster | object | `{"connectionParameters":{"dbname":"app","host":"postgresql","user":"app"},"password":{"key":"password","name":"postgresql"}}` | External cluster connection, password specifies a secret name and the key containing the password value |
| replica.importDatabases | list | `["app"]` | If type microservice only one database is allowed, default is app as standard in cnpg clusters |
| replica.importRoles | list | `[]` | If type microservice no roles are imported and ignored |
| replica.importType | string | `"microservice"` | See [here](https://cloudnative-pg.io/documentation/current/database_import/) for different import types * `microservice` - Single database import as expected from cnpg clusters * `monolith` - Import multiple databases and roles |
| replica.postImportApplicationSQL | list | `[]` | If import type is monolith postImportApplicationSQL is not supported and ignored |
| type | string | `"postgresql"` | Type of the CNPG database. Available types: * `postgresql` * `postgis` * `timescaledb` * `tensorchord` |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
