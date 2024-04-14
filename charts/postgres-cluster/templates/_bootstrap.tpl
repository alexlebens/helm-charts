{{- define "cluster.bootstrap" -}}
bootstrap:
{{- if eq .Values.mode "standalone" }}
  initdb:
    {{- with .Values.cluster.initdb }}
    {{- with (omit . "postInitApplicationSQL") }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}
    {{- end }}
    postInitApplicationSQL:
      {{- if eq .Values.type "postgis" }}
      - CREATE EXTENSION IF NOT EXISTS postgis;
      - CREATE EXTENSION IF NOT EXISTS postgis_topology;
      - CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
      - CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
      {{- else if eq .Values.type "timescaledb" }}
      - CREATE EXTENSION IF NOT EXISTS timescaledb;
      {{- end }}
      {{- with .Values.cluster.initdb }}
      {{- range .postInitApplicationSQL }}
      {{- printf "- %s" . | nindent 6 }}
      {{- end }}
      {{- end }}
{{- else if eq .Values.mode "replica" }}
  initdb:
    import:
      type: {{ .Values.replica.importType }}
      databases:
        {{- if and (len .Values.replica.importDatabases gt 1) (.Values.replica.importType eq "microservice") }}
          {{ fail "Too many databases in import type of microservice!" }}
        {{- else}}
        {{- with .Values.replica.importDatabases }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
        {{- end }}        
      {{- if .Values.replica.importType eq "monolith" }}
      roles:
        {{- with .Values.replica.importRoles }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- if and (.Values.replica.postImportApplicationSQL) (.Values.replica.importType eq "microservice") }}
      postImportApplicationSQL:
        {{- with .Values.replica.postImportApplicationSQL }}
        {{- . | toYaml | nindent 8 }}
        {{- end }}      
      {{- end }}
      source:
        externalCluster: "{{ include "cluster.name" . }}-cluster"
externalClusters:
  - name: "{{ include "cluster.name" . }}-cluster"
    {{- with .Values.replica.externalCluster }}
    {{- . | toYaml | nindent 4 }}
    {{- end }}    
{{- else if eq .Values.mode "recovery" }}
  recovery:
    {{- with .Values.recovery.pitrTarget.time }}
    recoveryTarget:
      targetTime: {{ . }}
    {{- end }}
    source: "{{ include "cluster.name" . }}-backup-{{ .Values.recovery.recoveryIndex }}"
externalClusters:
  - name: "{{ include "cluster.name" . }}-backup-{{ .Values.recovery.recoveryIndex }}"
    barmanObjectStore:
      serverName: "{{ include "cluster.name" . }}-backup-{{ .Values.recovery.recoveryIndex }}"
      destinationPath: "s3://{{ .Values.recovery.endpointBucket }}/{{ .Values.kubernetesClusterName }}/postgresql/{{ .Values.recovery.recoveryName }}"
      endpointURL: {{ .Values.recovery.endpointURL }}
      {{- with .Values.recovery.endpointCA }}
      endpointCA:
        name: {{ . }}
        key: ca-bundle.crt
      {{- end }}
      serverName: "{{ include "cluster.name" . }}-backup-{{ .Values.recovery.recoveryIndex }}"
      s3Credentials:
        accessKeyId:
          name: {{ include "cluster.recoveryCredentials" . }}
          key: ACCESS_KEY_ID
        secretAccessKey:
          name: {{ include "cluster.recoveryCredentials" . }}
          key: ACCESS_SECRET_KEY
      wal:
        compression: {{ .Values.recovery.wal.compression }}
        encryption: {{ .Values.recovery.wal.encryption }}
        maxParallel: {{ .Values.recovery.wal.maxParallel }}
      data:
        compression: {{ .Values.recovery.data.compression }}
        encryption: {{ .Values.recovery.data.encryption }}
        jobs: {{ .Values.recovery.data.jobs }}
{{- else }}
  {{ fail "Invalid cluster mode!" }}
{{- end }}
{{- end }}