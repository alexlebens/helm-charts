{{- define "cluster.backup" -}}
{{- if .Values.backup.enabled }}
backup:
  retentionPolicy: {{ .Values.backup.retentionPolicy }}
  barmanObjectStore:
    destinationPath: {{ .Values.backup.destinationPath }}
    endpointURL: {{ .Values.backup.endpointURL }}
    {{- if .Values.backup.endpointCA }}
    endpointCA:
      name: {{ .Values.backup.endpointCA.name }}
      key: {{ .Values.backup.endpointCA.key }}
    {{- end }}
    serverName: "{{ include "cluster.backupName" . }}-backup-{{ .Values.backup.backupIndex }}"
    wal:
      compression: {{ .Values.backup.wal.compression }}
      {{- with .Values.backup.wal.encryption}}
      encryption: {{ . }}
      {{- end }}
      maxParallel: {{ .Values.backup.wal.maxParallel }}
    data:
      compression: {{ .Values.backup.data.compression }}
      {{- with .Values.backup.data.encryption }}
      encryption: {{ . }}
      {{- end }}
      jobs: {{ .Values.backup.data.jobs }}
    s3Credentials:
      accessKeyId:
        name: {{ include "cluster.backupCredentials" . }}
        key: ACCESS_KEY_ID
      secretAccessKey:
        name: {{ include "cluster.backupCredentials" . }}
        key: ACCESS_SECRET_KEY
{{- end }}
{{- end }}
