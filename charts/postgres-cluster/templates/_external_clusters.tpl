{{- define "cluster.externalClusters" -}}
externalClusters:
{{- if eq .Values.mode "standalone" }}
{{- else if eq .Values.mode "recovery" }}
  {{- if eq .Values.recovery.method "pgBaseBackup" }}
  - name: pgBaseBackupSource
     {{- include "cluster.externalSourceCluster" .Values.recovery.pgBaseBackup.source | nindent 4 }}
  {{- else if eq .Values.recovery.method "import" }}
  - name: importSource
     {{- include "cluster.externalSourceCluster" .Values.recovery.import.source | nindent 4 }}
  {{- else if eq .Values.recovery.method "objectStore" }}
  - name: {{ include "cluster.recoveryServerName" . }}
    plugin:
      name: barman-cloud.cloudnative-pg.io
      enabled: true
      isWALArchiver: false
      barmanObjectStore:
        barmanObjectName: "{{ include "cluster.name" . }}-{{ .Values.recovery.objectStore.name }}"
        serverName: {{ include "cluster.recoveryServerName" . }}
  {{- end }}
{{- else }}
  {{ fail "Invalid cluster mode!" }}
{{- end }}
{{ end }}
