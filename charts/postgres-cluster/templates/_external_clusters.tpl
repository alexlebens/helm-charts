{{- define "cluster.externalClusters" -}}
{{- if eq .Values.mode "standalone" }}
{{- else if eq .Values.mode "recovery" }}
externalClusters:
  {{- if eq .Values.recovery.method "import" }}
  - name: importSource
     {{- include "cluster.externalSourceCluster" .Values.recovery.import.source | nindent 4 }}
  {{- else if eq .Values.recovery.method "objectStore" }}
  - name: {{ include "cluster.recoveryServerName" . }}
    plugin:
      name: barman-cloud.cloudnative-pg.io
      enabled: true
      isWALArchiver: false
      parameters:
        barmanObjectName: "{{ include "cluster.name" . }}-recovery"
        serverName: {{ include "cluster.recoveryServerName" . }}
  {{- end }}
{{- else }}
  {{ fail "Invalid cluster mode!" }}
{{- end }}
{{ end }}
