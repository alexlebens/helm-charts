{{- define "cluster.bootstrap" -}}

{{- if eq .Values.mode "standalone" }}
bootstrap:
  initdb:
    {{- with .Values.cluster.initdb }}
        {{- with (omit . "postInitApplicationSQL" "owner" "import") }}
            {{- . | toYaml | nindent 4 }}
        {{- end }}
    {{- end }}
    {{- if .Values.cluster.initdb.owner }}
    owner: {{ tpl .Values.cluster.initdb.owner . }}
    {{- end }}
    {{- if (.Values.cluster.initdb.postInitApplicationSQL) }}
    postInitApplicationSQL:
      {{- with .Values.cluster.initdb }}
        {{- range .postInitApplicationSQL }}
          {{- printf "- %s" . | nindent 6 }}
        {{- end -}}
      {{- end }}
    {{- end }}

{{- else if eq .Values.mode "recovery" -}}
bootstrap:

{{- if eq .Values.recovery.method "pgBaseBackup" }}
  pg_basebackup:
    source: pgBaseBackupSource
    {{ with .Values.recovery.pgBaseBackup.database }}
    database: {{ . }}
    {{- end }}
    {{ with .Values.recovery.pgBaseBackup.owner }}
    owner: {{ . }}
    {{- end }}
    {{ with .Values.recovery.pgBaseBackup.secret }}
    secret:
      {{- toYaml . | nindent 6 }}
    {{- end }}
externalClusters:
  {{- include "cluster.externalSourceCluster" (list "pgBaseBackupSource" .Values.recovery.pgBaseBackup.source) | nindent 2 }}

{{- else if eq .Values.recovery.method "import" }}
  initdb:
    {{- with .Values.cluster.initdb }}
      {{- with (omit . "owner" "import" "postInitApplicationSQL") }}
        {{- . | toYaml | nindent 4 }}
      {{- end }}
    {{- end }}
    {{- if .Values.cluster.initdb.owner }}
    owner: {{ tpl .Values.cluster.initdb.owner . }}
    {{- end }}
    import:
      source:
        externalCluster: importSource
      type: {{ .Values.recovery.import.type }}
      databases:
        {{- if and (gt (len .Values.recovery.import.databases) 1) (eq .Values.recovery.import.type "microservice") }}
          {{ fail "Too many databases in import type of microservice!" }}
        {{- else}}
        {{- with .Values.recovery.import.databases }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
        {{- end }}
      {{- if eq .Values.recovery.import.type "monolith" }}
      roles:
        {{- with .Values.replica.importRoles }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- if and (.Values.recovery.import.postImportApplicationSQL) (eq .Values.recovery.import.type "microservice") }}
      postImportApplicationSQL:
        {{- with .Values.recovery.import.postImportApplicationSQL }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
      {{- end }}
      schemaOnly: {{ .Values.recovery.import.schemaOnly }}
      {{ with .Values.recovery.import.pgDumpExtraOptions }}
      pgDumpExtraOptions:
        {{- . | toYaml | nindent 8 }}
      {{- end }}
      {{ with .Values.recovery.import.pgRestoreExtraOptions }}
      pgRestoreExtraOptions:
        {{- . | toYaml | nindent 8 }}
      {{- end }}
externalClusters:
  {{- include "cluster.externalSourceCluster" (list "importSource" .Values.recovery.import.source) | nindent 2 }}

{{- else if eq .Values.recovery.method "backup" }}
  recovery:
    {{- with .Values.recovery.backup.pitrTarget.time }}
    recoveryTarget:
      targetTime: {{ . }}
    {{- end }}
    {{ with .Values.recovery.backup.database }}
    database: {{ . }}
    {{- end }}
    {{ with .Values.recovery.backup.owner }}
    owner: {{ . }}
    {{- end }}
    backup:
      name: {{ .Values.recovery.backup.backupName }}

{{- else if eq .Values.recovery.method "objectStore" }}
  recovery:
    {{- with .Values.recovery.objectStore.pitrTarget.time }}
    recoveryTarget:
      targetTime: {{ . }}
    {{- end }}
    {{ with .Values.recovery.objectStore.database }}
    database: {{ . }}
    {{- end }}
    {{ with .Values.recovery.objectStore.owner }}
    owner: {{ . }}
    {{- end }}
    source: {{ include "cluster.recoveryServerName" . }}

externalClusters:
  - name: {{ include "cluster.recoveryServerName" . }}
    plugin:
      name: barman-cloud.cloudnative-pg.io
      enabled: true
      isWALArchiver: false
      parameters:
        barmanObjectName: "{{ include "cluster.name" . }}-{{ .Values.recovery.objectStore.name }}"
        serverName: {{ include "cluster.recoveryServerName" . }}

{{-  else }}
  {{ fail "Invalid recovery mode!" }}
{{- end }}

{{-  else }}
  {{ fail "Invalid cluster mode!" }}
{{- end }}

{{- end }}
