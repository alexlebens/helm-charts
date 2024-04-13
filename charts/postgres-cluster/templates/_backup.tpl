{{- define "cluster.backup" -}}
{{- if .Values.backup.enabled }}
backup:
  retentionPolicy: {{ .Values.backup.retentionPolicy }}
  barmanObjectStore:
    destinationPath: "s3://{{ .Values.backup.endpointBucket }}/{{ .Values.kubernetesClusterName }}/postgresql/{{ .Release.Name }}"
    endpointURL: {{ .Values.backup.endpointURL }}
    {{- if .Values.backup.endpointCA }}
    endpointCA:
      name: {{ .Values.backup.endpointCA }}
      key: ca-bundle.crt
    {{- end }}
    serverName: "postgresql-{{ .Release.Name }}-cluster-backup-index-{{ .Values.backup.backupIndex }}"
    s3Credentials:
      accessKeyId:
        name: {{ include "cluster.backup.credentials" . }}
        key: ACCESS_KEY_ID
      secretAccessKey:
        name: {{ include "cluster.backup.credentials" . }}
        key: ACCESS_SECRET_KEY
    wal:
      compression: {{ .Values.backup.wal.compression }}
      encryption: {{ .Values.backup.wal.encryption }}
      maxParallel: {{ .Values.backup.wal.maxParallel }}
    data:
      compression: {{ .Values.backup.data.compression }}
      encryption: {{ .Values.backup.data.encryption }}
      jobs: {{ .Values.backup.data.jobs }}
{{- end }}
{{- end }}
