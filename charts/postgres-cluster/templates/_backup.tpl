{{- define "cluster.backup" -}}
{{- if .Values.backup.enabled }}
backup:
  retentionPolicy: {{ .Values.backup.retentionPolicy }}
  barmanObjectStore:
    destinationPath: {{ .Values.backup.destinationPath }}
    endpointURL: {{ .Values.backup.endpointURL }}
    {{- if .Values.backup.endpointCA }}
    endpointCA:
      name: {{ .Values.backup.endpointCA }}
      key: ca-bundle.crt
    {{- end }}
    serverName: "{{ include "cluster.name" . }}-backup-{{ .Values.backup.backupIndex }}"
    s3Credentials:
      accessKeyId:
        name: {{ include "cluster.backupCredentials" . }}
        key: ACCESS_KEY_ID
      secretAccessKey:
        name: {{ include "cluster.backupCredentials" . }}
        key: ACCESS_SECRET_KEY
    wal:
      {{- if .Values.backup.wal.compression }}
      compression: {{ .Values.backup.wal.compression }}
      {{- end }}
      {{- if .Values.backup.wal.encryption }}
      encryption: {{ .Values.backup.wal.encryption }}
      {{- end }}
      {{- if .Values.backup.wal.maxParallel }}
      maxParallel: {{ .Values.backup.wal.maxParallel }}
      {{- end }}
    data:
      {{- if .Values.backup.data.compression }}
      compression: {{ .Values.backup.data.compression }}
      {{- end }}
      {{- if .Values.backup.data.encryption }}
      encryption: {{ .Values.backup.data.encryption }}
      {{- end }}
      {{- if .Values.backup.data.maxParallel }}
      maxParallel: {{ .Values.backup.data.maxParallel }}
      {{- end }}
{{- end }}
{{- end }}
