{{- define "cluster.externalClusters" -}}
{{- if eq .Values.mode "standalone" -}}
{{- else if eq .Values.mode "recovery" -}}
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
        barmanObjectName: {{ include "cluster.recoveryName" . }}
        serverName: {{ include "cluster.recoveryServerName" . }}
  {{- end }}
{{- else -}}
  {{ fail "Invalid cluster mode!" }}
{{- end -}}
{{- end -}}

{{- define "cluster.externalSourceCluster" -}}
{{- $name := first . -}}
{{- $config := last . -}}
- name: {{ first . }}
  connectionParameters:
    host: {{ $config.host | quote }}
    port: {{ $config.port | quote }}
    user: {{ $config.username | quote }}
    {{- with $config.database }}
    dbname: {{ . | quote }}
    {{- end }}
    sslmode: {{ $config.sslMode | quote }}
  {{- if $config.passwordSecret.name }}
  password:
    name: {{ $config.passwordSecret.name }}
    key: {{ $config.passwordSecret.key }}
  {{- end }}
  {{- if $config.sslKeySecret.name }}
  sslKey:
    name: {{ $config.sslKeySecret.name }}
    key: {{ $config.sslKeySecret.key }}
  {{- end }}
  {{- if $config.sslCertSecret.name }}
  sslCert:
    name: {{ $config.sslCertSecret.name }}
    key: {{ $config.sslCertSecret.key }}
  {{- end }}
  {{- if $config.sslRootCertSecret.name }}
  sslRootCert:
    name: {{ $config.sslRootCertSecret.name }}
    key: {{ $config.sslRootCertSecret.key }}
  {{- end }}
{{- end -}}
