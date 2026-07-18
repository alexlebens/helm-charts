# postgres-cluster

![Version: 8.2.0](https://img.shields.io/badge/Version-8.2.0-informational?style=flat-square) ![AppVersion: v1.30.0](https://img.shields.io/badge/AppVersion-v1.30.0-informational?style=flat-square)

Cloudnative-pg Cluster

**Homepage:** <https://gitea.alexlebens.net/alexlebens/helm-charts/src/branch/main/charts/postgres-cluster>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://gitea.alexlebens.net/alexlebens/helm-charts>
* <https://github.com/cloudnative-pg/cloudnative-pg>
* <https://github.com/cloudnative-pg/charts/tree/main/charts/cluster>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup | object | `{"backupServerName":"","method":"objectStore","objectStore":{"data":{"compression":"snappy","encryption":"","jobs":4},"destinationBucket":"postgres-backups","destinationPathOverride":"","enabled":false,"endpointCA":{"createExternalSecret":false,"externalSecretCredentialPath":"","externalSecretProperty":"ca.crt","key":"","name":""},"endpointCredentials":{"createExternalSecret":true,"externalSecretCredentialPath":"/garage/home-infra/postgres-backups","includeRegion":true,"name":""},"endpointURL":"http://garage-main.garage:3900","isWALArchiver":true,"retentionPolicy":"30d","wal":{"compression":"snappy","encryption":"","maxParallel":4}},"scheduledBackup":{"backupOwnerReference":"","enabled":false,"immediate":true,"plugin":"","schedule":"0 0 0 * * *","suspend":false}}` | Backup settings |
| backup.backupServerName | string | `""` | Override name of the backup server, usually this does not need to be used. |
| backup.method | string | `"objectStore"` | Method to create backups, options currently are only objectStore |
| backup.objectStore | object | `{"data":{"compression":"snappy","encryption":"","jobs":4},"destinationBucket":"postgres-backups","destinationPathOverride":"","enabled":false,"endpointCA":{"createExternalSecret":false,"externalSecretCredentialPath":"","externalSecretProperty":"ca.crt","key":"","name":""},"endpointCredentials":{"createExternalSecret":true,"externalSecretCredentialPath":"/garage/home-infra/postgres-backups","includeRegion":true,"name":""},"endpointURL":"http://garage-main.garage:3900","isWALArchiver":true,"retentionPolicy":"30d","wal":{"compression":"snappy","encryption":"","maxParallel":4}}` | Options for object store backups |
| backup.objectStore.data.compression | string | `"snappy"` | Data compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| backup.objectStore.data.encryption | string | `""` | Whether to instruct the storage provider to encrypt data files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| backup.objectStore.data.jobs | int | `4` | Number of data files to be archived or restored in parallel. |
| backup.objectStore.destinationBucket | string | `"postgres-backups"` | Destination bucket |
| backup.objectStore.destinationPathOverride | string | `""` | Overrides the provider specific default path. Defaults to: S3: s3://<bucket><path> Azure: https://<storageAccount>.<serviceName>.core.windows.net/<containerName><path> Google: gs://<bucket><path> |
| backup.objectStore.endpointCA | object | `{"createExternalSecret":false,"externalSecretCredentialPath":"","externalSecretProperty":"ca.crt","key":"","name":""}` | Specifies a CA bundle to validate a privately signed certificate. |
| backup.objectStore.endpointCA.createExternalSecret | bool | `false` | Generates an ExternalSecret if external secrets are enabled. |
| backup.objectStore.endpointCA.externalSecretCredentialPath | string | `""` | Path to the secret in the external secret store if external secrets are enabled. |
| backup.objectStore.endpointCA.externalSecretProperty | string | `"ca.crt"` | Property within the external secret that contains the CA certificate. |
| backup.objectStore.endpointCA.name | string | `""` | Name and key of existing secret containing the certificate. |
| backup.objectStore.endpointCredentials | object | `{"createExternalSecret":true,"externalSecretCredentialPath":"/garage/home-infra/postgres-backups","includeRegion":true,"name":""}` | Configure S3 credentials |
| backup.objectStore.endpointCredentials.createExternalSecret | bool | `true` | Generates an ExternalSecret if external secrets are enabled. |
| backup.objectStore.endpointCredentials.externalSecretCredentialPath | string | `"/garage/home-infra/postgres-backups"` | Path in the external secret store that contains the keys ACCESS_KEY_ID and ACCESS_SECRET_KEY |
| backup.objectStore.endpointCredentials.includeRegion | bool | `true` | If the S3 endpoint require the ACCESS_REGION variable set in credentials |
| backup.objectStore.endpointCredentials.name | string | `""` | Override secret name that contains S3 credentials |
| backup.objectStore.endpointURL | string | `"http://garage-main.garage:3900"` | Overrides the provider specific default endpoint. |
| backup.objectStore.isWALArchiver | bool | `true` | Specificies if this backup will do WALs |
| backup.objectStore.retentionPolicy | string | `"30d"` | Retention policy for backups |
| backup.objectStore.wal | object | `{"compression":"snappy","encryption":"","maxParallel":4}` | Storage |
| backup.objectStore.wal.compression | string | `"snappy"` | WAL compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| backup.objectStore.wal.encryption | string | `""` | Whether to instruct the storage provider to encrypt WAL files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| backup.objectStore.wal.maxParallel | int | `4` | Number of WAL files to be archived or restored in parallel. |
| backup.scheduledBackup | object | `{"backupOwnerReference":"","enabled":false,"immediate":true,"plugin":"","schedule":"0 0 0 * * *","suspend":false}` | Scheduled backup configuration |
| backup.scheduledBackup.backupOwnerReference | string | `""` | Backup owner reference |
| backup.scheduledBackup.immediate | bool | `true` | Start backup on deployment |
| backup.scheduledBackup.plugin | string | `""` | Backup method, can be `barman-cloud.cloudnative-pg.io` (default) |
| backup.scheduledBackup.schedule | string | `"0 0 0 * * *"` | Schedule in cron format |
| backup.scheduledBackup.suspend | bool | `false` | Temporarily stop scheduled backups from running |
| cluster | object | `{"additionalLabels":{},"affinity":{"enablePodAntiAffinity":true,"topologyKey":"kubernetes.io/hostname"},"annotations":{},"certificates":{},"enablePDB":true,"enableSuperuserAccess":false,"image":{"repository":"ghcr.io/cloudnative-pg/postgresql","tag":"18.4-standard-trixie"},"imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"initdb":{"database":"app","owner":"app","postInitApplicationSQL":[],"postInitTemplateSQL":[]},"instances":3,"logLevel":"info","monitoring":{"customQueries":[],"customQueriesSecret":[],"disableDefaultQueries":false,"enabled":true,"podMonitor":{"enabled":true,"metricRelabelings":[],"relabelings":[]},"prometheusRule":{"enabled":true,"excludeRules":["CNPGClusterLastFailedArchiveTimeWarning"]}},"postgresGID":-1,"postgresUID":-1,"postgresql":{"parameters":{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"512MB"},"pg_hba":[],"shared_preload_libraries":[],"synchronous":{}},"primaryUpdateMethod":"switchover","primaryUpdateStrategy":"unsupervised","priorityClassName":"","resources":{"limits":{"hugepages-2Mi":"256Mi"},"requests":{"cpu":"50m","memory":"512Mi"}},"services":{},"storage":{"size":"10Gi","storageClass":"local-path"},"superuserSecret":"","walStorage":{"enabled":true,"size":"2Gi","storageClass":"local-path"}}` | Cluster settings |
| cluster.affinity | object | `{"enablePodAntiAffinity":true,"topologyKey":"kubernetes.io/hostname"}` | Affinity/Anti-affinity rules for Pods. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-AffinityConfiguration |
| cluster.certificates | object | `{}` | The configuration for the CA and related certificates. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-CertificatesConfiguration |
| cluster.enablePDB | bool | `true` | Allow to disable PDB, mainly useful for upgrade of single-instance clusters or development purposes See: https://cloudnative-pg.io/documentation/current/kubernetes_upgrade/#pod-disruption-budgets |
| cluster.enableSuperuserAccess | bool | `false` | When this option is enabled, the operator will use the SuperuserSecret to update the postgres user password. If the secret is not present, the operator will automatically create one. When this option is disabled, the operator will ignore the SuperuserSecret content, delete it when automatically created, and then blank the password of the postgres user by setting it to NULL. |
| cluster.image | object | `{"repository":"ghcr.io/cloudnative-pg/postgresql","tag":"18.4-standard-trixie"}` | Default image |
| cluster.imagePullPolicy | string | `"IfNotPresent"` | Image pull policy. One of Always, Never or IfNotPresent. If not defined, it defaults to IfNotPresent. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images |
| cluster.imagePullSecrets | list | `[]` | The list of pull secrets to be used to pull the images. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-LocalObjectReference |
| cluster.initdb | object | `{"database":"app","owner":"app","postInitApplicationSQL":[],"postInitTemplateSQL":[]}` | Bootstrap is the configuration of the bootstrap process when initdb is used. See: https://cloudnative-pg.io/documentation/current/bootstrap/ See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-bootstrapinitdb |
| cluster.logLevel | string | `"info"` | The instances' log level, one of the following values: error, warning, info (default), debug, trace |
| cluster.monitoring | object | `{"customQueries":[],"customQueriesSecret":[],"disableDefaultQueries":false,"enabled":true,"podMonitor":{"enabled":true,"metricRelabelings":[],"relabelings":[]},"prometheusRule":{"enabled":true,"excludeRules":["CNPGClusterLastFailedArchiveTimeWarning"]}}` | Enable default monitoring and alert rules |
| cluster.monitoring.customQueries | list | `[]` | Custom Prometheus metrics Will be stored in the ConfigMap |
| cluster.monitoring.customQueriesSecret | list | `[]` | The list of secrets containing the custom queries |
| cluster.monitoring.disableDefaultQueries | bool | `false` | Whether the default queries should be injected. Set it to true if you don't want to inject default queries into the cluster. |
| cluster.monitoring.enabled | bool | `true` | Whether to enable monitoring |
| cluster.monitoring.podMonitor.enabled | bool | `true` | Whether to enable the PodMonitor |
| cluster.monitoring.podMonitor.metricRelabelings | list | `[]` | The list of metric relabelings for the PodMonitor. Applied to samples before ingestion. |
| cluster.monitoring.podMonitor.relabelings | list | `[]` | The list of relabelings for the PodMonitor. Applied to samples before scraping. |
| cluster.monitoring.prometheusRule | object | `{"enabled":true,"excludeRules":["CNPGClusterLastFailedArchiveTimeWarning"]}` | Prometheus rule |
| cluster.monitoring.prometheusRule.enabled | bool | `true` | Whether to enable the PrometheusRule automated alerts |
| cluster.monitoring.prometheusRule.excludeRules | list | `["CNPGClusterLastFailedArchiveTimeWarning"]` | Exclude specified rules |
| cluster.postgresUID | int | `-1` | The UID and GID of the postgres user inside the image, defaults to 26 |
| cluster.postgresql | object | `{"parameters":{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"512MB"},"pg_hba":[],"shared_preload_libraries":[],"synchronous":{}}` | Parameters to be set for the database itself See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-PostgresConfiguration |
| cluster.postgresql.parameters | object | `{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"512MB"}` | PostgreSQL configuration options (postgresql.conf) |
| cluster.postgresql.pg_hba | list | `[]` | List of pg_hba.conf rules |
| cluster.postgresql.shared_preload_libraries | list | `[]` | Lists of shared preload libraries to add to the default ones |
| cluster.postgresql.synchronous | object | `{}` | Quorum-based Synchronous Replication |
| cluster.primaryUpdateMethod | string | `"switchover"` | Method to follow to upgrade the primary server during a rolling update procedure, after all replicas have been successfully updated. It can be switchover (default) or restart. |
| cluster.primaryUpdateStrategy | string | `"unsupervised"` | Strategy to follow to upgrade the primary server during a rolling update procedure, after all replicas have been successfully updated: it can be automated (unsupervised - default) or manual (supervised) |
| cluster.resources | object | `{"limits":{"hugepages-2Mi":"256Mi"},"requests":{"cpu":"50m","memory":"512Mi"}}` | Resources requirements of every generated Pod. Please refer to https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ for more information. We strongly advise you use the same setting for limits and requests so that your cluster pods are given a Guaranteed QoS. See: https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/ |
| cluster.services | object | `{}` | Customization of service definitions. Please refer to https://cloudnative-pg.io/documentation/current/service_management/ |
| cluster.storage | object | `{"size":"10Gi","storageClass":"local-path"}` | Default storage size |
| databases | list | `[]` | Database management configuration. Define a list of databases, schemas, and extensions to be managed by the operator. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-Database Example: databases:   - name: app     ensure: present     owner: app     schemas:       - name: myschema         owner: app     extensions:       - name: pg_search         version: "0.15.21" |
| externalSecretStoreName | string | `"openbao"` | Name of the ClusterSecretStore to use for ExternalSecret resources |
| kubernetesClusterName | string | `"cl01tl"` | Kubernetes cluster name |
| mode | string | `"standalone"` | Cluster mode of operation. Available modes: * `standalone` - Default mode. Creates new or updates an existing CNPG cluster. * `recovery` - Same as standalone but creates a cluster from a backup, object store or via pg_basebackup |
| nameOverride | string | `""` | Override the name of the cluster |
| namespaceOverride | string | `""` | Override the namespace of the chart |
| poolers | list | `[]` | List of PgBouncer poolers to deploy alongside the cluster. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-Pooler Example: poolers:   - name: rw     type: rw     poolMode: transaction     instances: 3     parameters:       max_client_conn: "1000"       default_pool_size: "25"     monitoring:       enabled: true       podMonitor:         enabled: true   - name: ro     type: ro     poolMode: transaction     instances: 3     parameters:       max_client_conn: "1000"       default_pool_size: "25" |
| recovery | object | `{"backup":{"backupName":"","database":"app","owner":"","pitrTarget":{"time":""}},"import":{"databases":[],"pgDumpExtraOptions":[],"pgRestoreExtraOptions":[],"postImportApplicationSQL":[],"roles":[],"schemaOnly":false,"source":{"database":"app","host":"","passwordSecret":{"key":"password","name":""},"port":5432,"sslCertSecret":{"key":"","name":""},"sslKeySecret":{"key":"","name":""},"sslMode":"verify-full","sslRootCertSecret":{"key":"","name":""},"username":"app"},"type":"microservice"},"method":"backup","objectStore":{"clusterName":"","data":{"compression":"snappy","encryption":"","jobs":1},"database":"app","destinationBucket":"postgres-backups","destinationPathOverride":"","enabled":false,"endpointCA":{"createExternalSecret":false,"externalSecretCredentialPath":"","externalSecretProperty":"ca.crt","key":"","name":""},"endpointCredentials":{"createExternalSecret":true,"externalSecretCredentialPath":"/garage/home-infra/postgres-backups","includeRegion":true,"name":""},"endpointURL":"http://garage-main.garage:3900","index":1,"owner":"","pitrTarget":{"time":""},"wal":{"compression":"snappy","encryption":"","maxParallel":1}}}` | Recovery settings when booting cluster from external cluster |
| recovery.backup.backupName | string | `""` | Name of the backup to recover from. |
| recovery.backup.database | string | `"app"` | Name of the database used by the application. Default: `app`. |
| recovery.backup.owner | string | `""` | Name of the owner of the database in the instance to be used by applications. Defaults to the value of the `database` key. |
| recovery.backup.pitrTarget | object | `{"time":""}` | Point in time recovery target. Specify one of the following: |
| recovery.backup.pitrTarget.time | string | `""` | Time in RFC3339 format |
| recovery.import.databases | list | `[]` | Databases to import |
| recovery.import.pgDumpExtraOptions | list | `[]` | List of custom options to pass to the `pg_dump` command. IMPORTANT: Use these options with caution and at your own risk, as the operator does not validate their content. Be aware that certain options may conflict with the operator's intended functionality or design. |
| recovery.import.pgRestoreExtraOptions | list | `[]` | List of custom options to pass to the `pg_restore` command. IMPORTANT: Use these options with caution and at your own risk, as the operator does not validate their content. Be aware that certain options may conflict with the operator's intended functionality or design. |
| recovery.import.postImportApplicationSQL | list | `[]` | List of SQL queries to be executed as a superuser in the application database right after is imported. To be used with extreme care. Only available in microservice type. |
| recovery.import.roles | list | `[]` | Roles to import |
| recovery.import.schemaOnly | bool | `false` | When set to true, only the pre-data and post-data sections of pg_restore are invoked, avoiding data import. |
| recovery.import.source | object | `{"database":"app","host":"","passwordSecret":{"key":"password","name":""},"port":5432,"sslCertSecret":{"key":"","name":""},"sslKeySecret":{"key":"","name":""},"sslMode":"verify-full","sslRootCertSecret":{"key":"","name":""},"username":"app"}` | Configuration for the source database |
| recovery.import.source.passwordSecret | object | `{"key":"password","name":""}` | Name and key of the existing secret containing the password |
| recovery.import.type | string | `"microservice"` | One of `microservice` or `monolith.` See: https://cloudnative-pg.io/documentation/current/database_import/#how-it-works |
| recovery.method | string | `"backup"` | Available recovery methods: * `backup` - Recovers a CNPG cluster from a CNPG backup (PITR supported) Needs to be on the same cluster in the same namespace. * `objectStore` - Recovers a CNPG cluster from a barman object store (PITR supported). * `import` - Import one or more databases from an existing Postgres cluster. |
| recovery.objectStore.clusterName | string | `""` | Override the name of the backup cluster, defaults to "cluster.name" |
| recovery.objectStore.data.compression | string | `"snappy"` | Data compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| recovery.objectStore.data.encryption | string | `""` | Whether to instruct the storage provider to encrypt data files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| recovery.objectStore.data.jobs | int | `1` | Number of data files to be archived or restored in parallel. |
| recovery.objectStore.database | string | `"app"` | Name of the database used by the application. Default: `app`. |
| recovery.objectStore.destinationBucket | string | `"postgres-backups"` | Destination bucket |
| recovery.objectStore.destinationPathOverride | string | `""` | Overrides the provider specific default path. Defaults to: S3: s3://<bucket><path> Azure: https://<storageAccount>.<serviceName>.core.windows.net/<containerName><path> Google: gs://<bucket><path> |
| recovery.objectStore.endpointCA | object | `{"createExternalSecret":false,"externalSecretCredentialPath":"","externalSecretProperty":"ca.crt","key":"","name":""}` | Specifies a CA bundle to validate a privately signed certificate. |
| recovery.objectStore.endpointCA.createExternalSecret | bool | `false` | Generates an ExternalSecret if external secrets are enabled. |
| recovery.objectStore.endpointCA.externalSecretCredentialPath | string | `""` | Path to the secret in the external secret store if external secrets are enabled. |
| recovery.objectStore.endpointCA.externalSecretProperty | string | `"ca.crt"` | Property within the external secret that contains the CA certificate. |
| recovery.objectStore.endpointCA.name | string | `""` | Name and key of existing secret containing the certificate. |
| recovery.objectStore.endpointCredentials | object | `{"createExternalSecret":true,"externalSecretCredentialPath":"/garage/home-infra/postgres-backups","includeRegion":true,"name":""}` | Configure S3 credentials |
| recovery.objectStore.endpointCredentials.createExternalSecret | bool | `true` | Generates an ExternalSecret if external secrets are enabled. |
| recovery.objectStore.endpointCredentials.externalSecretCredentialPath | string | `"/garage/home-infra/postgres-backups"` | Path in the external secret store that contains the keys ACCESS_KEY_ID and ACCESS_SECRET_KEY |
| recovery.objectStore.endpointCredentials.includeRegion | bool | `true` | If the S3 endpoint require the ACCESS_REGION variable set in credentials |
| recovery.objectStore.endpointCredentials.name | string | `""` | Override secret name that contains S3 credentials |
| recovery.objectStore.endpointURL | string | `"http://garage-main.garage:3900"` | Overrides the provider specific default endpoint. Defaults to: S3: https://s3.<region>.amazonaws.com" Leave empty if using the default S3 endpoint |
| recovery.objectStore.index | int | `1` | Generate external cluster name, uses: {{ .Release.Name }}-postgresql-<major version>-backup-index-{{ index }} |
| recovery.objectStore.owner | string | `""` | Name of the owner of the database in the instance to be used by applications. Defaults to the value of the `database` key. |
| recovery.objectStore.pitrTarget | object | `{"time":""}` | Point in time recovery target. Specify one of the following: |
| recovery.objectStore.pitrTarget.time | string | `""` | Time in RFC3339 format |
| recovery.objectStore.wal | object | `{"compression":"snappy","encryption":"","maxParallel":1}` | Storage |
| recovery.objectStore.wal.compression | string | `"snappy"` | WAL compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| recovery.objectStore.wal.encryption | string | `""` | Whether to instruct the storage provider to encrypt WAL files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| recovery.objectStore.wal.maxParallel | int | `1` | Number of WAL files to be archived or restored in parallel. |
| roles | list | `[]` | Role management configuration. Define a list of roles to be managed by the operator via DatabaseRole CRDs. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-DatabaseRole Example: roles:   - name: my_role     ensure: present     login: true     connectionLimit: 10     inRoles:       - another_role |
| type | string | `"postgresql"` | Type of the CNPG database. Available types: * `postgresql` |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
