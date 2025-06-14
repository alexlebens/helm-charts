# postgres-cluster

![Version: 6.4.4](https://img.shields.io/badge/Version-6.4.4-informational?style=flat-square) ![AppVersion: v1.26.0](https://img.shields.io/badge/AppVersion-v1.26.0-informational?style=flat-square)

Cloudnative-pg Cluster

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| alexlebens |  |  |

## Source Code

* <https://github.com/cloudnative-pg/cloudnative-pg>
* <https://github.com/cloudnative-pg/charts/tree/main/charts/cluster>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup | object | `{"enabled":false,"method":"objectStore","objectStore":[],"scheduledBackups":[]}` | Backup settings |
| backup.enabled | bool | `false` | You need to configure backups manually, so backups are disabled by default. |
| backup.method | string | `"objectStore"` | Method to create backups, options currently are only objectStore |
| backup.objectStore | list | `[]` | Options for object store backups |
| backup.scheduledBackups | list | `[]` | List of scheduled backups |
| cluster | object | `{"additionalLabels":{},"affinity":{"enablePodAntiAffinity":true,"topologyKey":"kubernetes.io/hostname"},"annotations":{},"certificates":{},"enablePDB":true,"enableSuperuserAccess":false,"image":{"repository":"ghcr.io/cloudnative-pg/postgresql","tag":"17.5-1-bullseye"},"imagePullPolicy":"IfNotPresent","imagePullSecrets":[],"initdb":{},"instances":3,"logLevel":"info","monitoring":{"customQueries":[],"customQueriesSecret":[],"disableDefaultQueries":false,"enabled":false,"podMonitor":{"enabled":true,"metricRelabelings":[],"relabelings":[]},"prometheusRule":{"enabled":false,"excludeRules":[]}},"postgresGID":-1,"postgresUID":-1,"postgresql":{"ldap":{},"parameters":{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"128MB"},"pg_hba":[],"pg_ident":[],"shared_preload_libraries":[],"synchronous":{}},"primaryUpdateMethod":"switchover","primaryUpdateStrategy":"unsupervised","priorityClassName":"","resources":{"limits":{"hugepages-2Mi":"256Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"roles":[],"serviceAccountTemplate":{},"services":{},"storage":{"size":"10Gi","storageClass":""},"superuserSecret":"","walStorage":{"enabled":true,"size":"2Gi","storageClass":""}}` | Cluster settings |
| cluster.affinity | object | `{"enablePodAntiAffinity":true,"topologyKey":"kubernetes.io/hostname"}` | Affinity/Anti-affinity rules for Pods. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-AffinityConfiguration |
| cluster.certificates | object | `{}` | The configuration for the CA and related certificates. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-CertificatesConfiguration |
| cluster.enablePDB | bool | `true` | Allow to disable PDB, mainly useful for upgrade of single-instance clusters or development purposes See: https://cloudnative-pg.io/documentation/current/kubernetes_upgrade/#pod-disruption-budgets |
| cluster.enableSuperuserAccess | bool | `false` | When this option is enabled, the operator will use the SuperuserSecret to update the postgres user password. If the secret is not present, the operator will automatically create one. When this option is disabled, the operator will ignore the SuperuserSecret content, delete it when automatically created, and then blank the password of the postgres user by setting it to NULL. |
| cluster.image | object | `{"repository":"ghcr.io/cloudnative-pg/postgresql","tag":"17.5-1-bullseye"}` | Default image |
| cluster.imagePullPolicy | string | `"IfNotPresent"` | Image pull policy. One of Always, Never or IfNotPresent. If not defined, it defaults to IfNotPresent. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images |
| cluster.imagePullSecrets | list | `[]` | The list of pull secrets to be used to pull the images. See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-LocalObjectReference |
| cluster.initdb | object | `{}` | Bootstrap is the configuration of the bootstrap process when initdb is used. See: https://cloudnative-pg.io/documentation/current/bootstrap/ See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-bootstrapinitdb |
| cluster.logLevel | string | `"info"` | The instances' log level, one of the following values: error, warning, info (default), debug, trace |
| cluster.monitoring | object | `{"customQueries":[],"customQueriesSecret":[],"disableDefaultQueries":false,"enabled":false,"podMonitor":{"enabled":true,"metricRelabelings":[],"relabelings":[]},"prometheusRule":{"enabled":false,"excludeRules":[]}}` | Enable default monitoring and alert rules |
| cluster.monitoring.customQueries | list | `[]` | Custom Prometheus metrics Will be stored in the ConfigMap |
| cluster.monitoring.customQueriesSecret | list | `[]` | The list of secrets containing the custom queries |
| cluster.monitoring.disableDefaultQueries | bool | `false` | Whether the default queries should be injected. Set it to true if you don't want to inject default queries into the cluster. |
| cluster.monitoring.enabled | bool | `false` | Whether to enable monitoring |
| cluster.monitoring.podMonitor.enabled | bool | `true` | Whether to enable the PodMonitor |
| cluster.monitoring.podMonitor.metricRelabelings | list | `[]` | The list of metric relabelings for the PodMonitor. Applied to samples before ingestion. |
| cluster.monitoring.podMonitor.relabelings | list | `[]` | The list of relabelings for the PodMonitor. Applied to samples before scraping. |
| cluster.monitoring.prometheusRule.enabled | bool | `false` | Whether to enable the PrometheusRule automated alerts |
| cluster.monitoring.prometheusRule.excludeRules | list | `[]` | Exclude specified rules |
| cluster.postgresUID | int | `-1` | The UID and GID of the postgres user inside the image, defaults to 26 |
| cluster.postgresql | object | `{"ldap":{},"parameters":{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"128MB"},"pg_hba":[],"pg_ident":[],"shared_preload_libraries":[],"synchronous":{}}` | Parameters to be set for the database itself See: https://cloudnative-pg.io/documentation/current/cloudnative-pg.v1/#postgresql-cnpg-io-v1-PostgresConfiguration |
| cluster.postgresql.ldap | object | `{}` | PostgreSQL LDAP configuration (see https://cloudnative-pg.io/documentation/current/postgresql_conf/#ldap-configuration) |
| cluster.postgresql.parameters | object | `{"hot_standby_feedback":"on","max_slot_wal_keep_size":"2000MB","shared_buffers":"128MB"}` | PostgreSQL configuration options (postgresql.conf) |
| cluster.postgresql.pg_hba | list | `[]` | PostgreSQL Host Based Authentication rules (lines to be appended to the pg_hba.conf file) |
| cluster.postgresql.pg_ident | list | `[]` | PostgreSQL User Name Maps rules (lines to be appended to the pg_ident.conf file) |
| cluster.postgresql.shared_preload_libraries | list | `[]` | Lists of shared preload libraries to add to the default ones |
| cluster.postgresql.synchronous | object | `{}` | Quorum-based Synchronous Replication |
| cluster.primaryUpdateMethod | string | `"switchover"` | Method to follow to upgrade the primary server during a rolling update procedure, after all replicas have been successfully updated. It can be switchover (default) or restart. |
| cluster.primaryUpdateStrategy | string | `"unsupervised"` | Strategy to follow to upgrade the primary server during a rolling update procedure, after all replicas have been successfully updated: it can be automated (unsupervised - default) or manual (supervised) |
| cluster.resources | object | `{"limits":{"hugepages-2Mi":"256Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resources requirements of every generated Pod. Please refer to https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ for more information. We strongly advise you use the same setting for limits and requests so that your cluster pods are given a Guaranteed QoS. See: https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/ |
| cluster.roles | list | `[]` | This feature enables declarative management of existing roles, as well as the creation of new roles if they are not already present in the database. See: https://cloudnative-pg.io/documentation/current/declarative_role_management/ |
| cluster.serviceAccountTemplate | object | `{}` | Configure the metadata of the generated service account |
| cluster.services | object | `{}` | Customization of service definitions. Please refer to https://cloudnative-pg.io/documentation/current/service_management/ |
| cluster.storage | object | `{"size":"10Gi","storageClass":""}` | Default storage size |
| mode | string | `"standalone"` | Cluster mode of operation. Available modes: * `standalone` - Default mode. Creates new or updates an existing CNPG cluster. * `recovery` - Same as standalone but creates a cluster from a backup, object store or via pg_basebackup |
| nameOverride | string | `""` | Override the name of the cluster |
| namespaceOverride | string | `""` | Override the namespace of the chart |
| poolers | list | `[]` | List of PgBouncer poolers |
| recovery | object | `{"backup":{"backupName":"","database":"app","owner":"","pitrTarget":{"time":""}},"import":{"databases":[],"pgDumpExtraOptions":[],"pgRestoreExtraOptions":[],"postImportApplicationSQL":[],"roles":[],"schemaOnly":false,"source":{"database":"app","host":"","passwordSecret":{"create":false,"key":"password","name":"","value":""},"port":5432,"sslCertSecret":{"key":"","name":""},"sslKeySecret":{"key":"","name":""},"sslMode":"verify-full","sslRootCertSecret":{"key":"","name":""},"username":"app"},"type":"microservice"},"method":"backup","objectStore":{"clusterName":"","data":{"compression":"snappy","encryption":"","jobs":1},"database":"app","destinationPath":"","endpointCA":{"create":false,"key":"","name":""},"endpointCredentials":"","endpointURL":"https://nyc3.digitaloceanspaces.com","index":1,"name":"recovery","owner":"","pitrTarget":{"time":""},"wal":{"compression":"snappy","encryption":"","maxParallel":1}},"pgBaseBackup":{"database":"app","owner":"","secret":"","source":{"database":"app","host":"","passwordSecret":{"create":false,"key":"password","name":"","value":""},"port":5432,"sslCertSecret":{"key":"","name":""},"sslKeySecret":{"key":"","name":""},"sslMode":"verify-full","sslRootCertSecret":{"key":"","name":""},"username":""}}}` | Recovery settings when booting cluster from external cluster |
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
| recovery.import.source | object | `{"database":"app","host":"","passwordSecret":{"create":false,"key":"password","name":"","value":""},"port":5432,"sslCertSecret":{"key":"","name":""},"sslKeySecret":{"key":"","name":""},"sslMode":"verify-full","sslRootCertSecret":{"key":"","name":""},"username":"app"}` | Configuration for the source database |
| recovery.import.source.passwordSecret.create | bool | `false` | Whether to create a secret for the password |
| recovery.import.source.passwordSecret.key | string | `"password"` | The key in the secret containing the password |
| recovery.import.source.passwordSecret.name | string | `""` | Name of the secret containing the password |
| recovery.import.source.passwordSecret.value | string | `""` | The password value to use when creating the secret |
| recovery.import.type | string | `"microservice"` | One of `microservice` or `monolith.` See: https://cloudnative-pg.io/documentation/current/database_import/#how-it-works |
| recovery.method | string | `"backup"` | Available recovery methods: * `backup` - Recovers a CNPG cluster from a CNPG backup (PITR supported) Needs to be on the same cluster in the same namespace. * `objectStore` - Recovers a CNPG cluster from a barman object store (PITR supported). * `pgBaseBackup` - Recovers a CNPG cluster viaa streaming replication protocol. Useful if you want to        migrate databases to CloudNativePG, even from outside Kubernetes. * `import` - Import one or more databases from an existing Postgres cluster. |
| recovery.objectStore.clusterName | string | `""` | Override the name of the backup cluster, defaults to "cluster.name" |
| recovery.objectStore.data.compression | string | `"snappy"` | Data compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| recovery.objectStore.data.encryption | string | `""` | Whether to instruct the storage provider to encrypt data files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| recovery.objectStore.data.jobs | int | `1` | Number of data files to be archived or restored in parallel. |
| recovery.objectStore.database | string | `"app"` | Name of the database used by the application. Default: `app`. |
| recovery.objectStore.destinationPath | string | `""` | Overrides the provider specific default path. Defaults to: S3: s3://<bucket><path> Azure: https://<storageAccount>.<serviceName>.core.windows.net/<containerName><path> Google: gs://<bucket><path> |
| recovery.objectStore.endpointCA | object | `{"create":false,"key":"","name":""}` | Specifies a CA bundle to validate a privately signed certificate. |
| recovery.objectStore.endpointCA.create | bool | `false` | Creates a secret with the given value if true, otherwise uses an existing secret. |
| recovery.objectStore.endpointCredentials | string | `""` | Specifies secret that contains S3 credentials, should contain the keys ACCESS_KEY_ID and ACCESS_SECRET_KEY |
| recovery.objectStore.endpointURL | string | `"https://nyc3.digitaloceanspaces.com"` | Overrides the provider specific default endpoint. Defaults to: S3: https://s3.<region>.amazonaws.com" Leave empty if using the default S3 endpoint |
| recovery.objectStore.index | int | `1` | Generate external cluster name, uses: {{ .Release.Name }}-postgresql-<major version>-backup-index-{{ index }} |
| recovery.objectStore.name | string | `"recovery"` | Object store backup name |
| recovery.objectStore.owner | string | `""` | Name of the owner of the database in the instance to be used by applications. Defaults to the value of the `database` key. |
| recovery.objectStore.pitrTarget | object | `{"time":""}` | Point in time recovery target. Specify one of the following: |
| recovery.objectStore.pitrTarget.time | string | `""` | Time in RFC3339 format |
| recovery.objectStore.wal | object | `{"compression":"snappy","encryption":"","maxParallel":1}` | Storage |
| recovery.objectStore.wal.compression | string | `"snappy"` | WAL compression method. One of `` (for no compression), `gzip`, `bzip2` or `snappy`. |
| recovery.objectStore.wal.encryption | string | `""` | Whether to instruct the storage provider to encrypt WAL files. One of `` (use the storage container default), `AES256` or `aws:kms`. |
| recovery.objectStore.wal.maxParallel | int | `1` | Number of WAL files to be archived or restored in parallel. |
| recovery.pgBaseBackup.database | string | `"app"` | Name of the database used by the application. Default: `app`. |
| recovery.pgBaseBackup.owner | string | `""` | Name of the owner of the database in the instance to be used by applications. Defaults to the value of the `database` key. |
| recovery.pgBaseBackup.secret | string | `""` | Name of the secret containing the initial credentials for the owner of the user database. If empty a new secret will be created from scratch |
| recovery.pgBaseBackup.source | object | `{"database":"app","host":"","passwordSecret":{"create":false,"key":"password","name":"","value":""},"port":5432,"sslCertSecret":{"key":"","name":""},"sslKeySecret":{"key":"","name":""},"sslMode":"verify-full","sslRootCertSecret":{"key":"","name":""},"username":""}` | Configuration for the source database |
| recovery.pgBaseBackup.source.passwordSecret.create | bool | `false` | Whether to create a secret for the password |
| recovery.pgBaseBackup.source.passwordSecret.key | string | `"password"` | The key in the secret containing the password |
| recovery.pgBaseBackup.source.passwordSecret.name | string | `""` | Name of the secret containing the password |
| recovery.pgBaseBackup.source.passwordSecret.value | string | `""` | The password value to use when creating the secret |
| type | string | `"postgresql"` | Type of the CNPG database. Available types: * `postgresql` * `tensorchord` |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
