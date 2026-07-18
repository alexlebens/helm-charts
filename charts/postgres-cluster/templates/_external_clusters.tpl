{{- define "cluster.externalClusters" -}}
{{- if eq .Values.mode "standalone" -}}
{{- else if eq .Values.mode "recovery" -}}
externalClusters:
  {{- if eq .Values.recovery.method "import" }}
  {{- include "cluster.externalSourceCluster" . | nindent 2 }}
  {{- else if eq .Values.recovery.method "objectStore" }}
  - name: {{ include "cluster.recoveryServerName" . }}
    plugin:
      name: barman-cloud.cloudnative-pg.io
      enabled: true
      isWALArchiver: false
      parameters:
        barmanObjectName: {{ include "cluster.recoveryName" . }}
        serverName: {{ include "cluster.recoveryServerName" . }}
  {{- end }}
{{- else -}}
  {{ fail "Invalid cluster mode!" }}
{{- end -}}
{{- end -}}

{{- define "cluster.externalSourceCluster" -}}
{{- with .Values.recovery.import.source }}
- name: importSource
  connectionParameters:
    host: {{ .host | quote }}
    port: {{ .port | quote }}
    user: {{ .username | quote }}
    {{- with .database }}
    dbname: {{ . | quote }}
    {{- end }}
    sslmode: {{ .sslMode | quote }}
  {{- if .passwordSecret.name }}
  password:
    name: {{ .passwordSecret.name }}
    key: {{ .passwordSecret.key }}
  {{- end }}
  {{- if .sslKeySecret.name }}
  sslKey:
    name: {{ .sslKeySecret.name }}
    key: {{ .sslKeySecret.key }}
  {{- end }}
  {{- if .sslCertSecret.name }}
  sslCert:
    name: {{ .sslCertSecret.name }}
    key: {{ .sslCertSecret.key }}
  {{- end }}
  {{- if .sslRootCertSecret.name }}
  sslRootCert:
    name: {{ .sslRootCertSecret.name }}
    key: {{ .sslRootCertSecret.key }}
  {{- end }}
{{- end }}
{{- end -}}
