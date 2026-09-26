{{/*
Generate the bucket name
*/}}
{{- define "s3Bucket.name" -}}
  {{- if .Values.bucketName }}
    {{- .Values.bucketName | trunc 63 | trimSuffix "-" -}}
  {{- else }}
    {{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate the external secret name
*/}}
{{- define "s3Bucket.secretName" -}}
  {{- printf "%s-secret" (include "s3Bucket.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate the backup external secret name
*/}}
{{- define "s3Bucket.backupSecretName" -}}
  {{- printf "%s-backup" (include "s3Bucket.secretName" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate the cron job name
*/}}
{{- define "s3Bucket.cronJobName" -}}
  {{- printf "%s-backup" (include "s3Bucket.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Determine S3 endpoint based on target tier
*/}}
{{- define "s3Bucket.endpoint" -}}
  {{- if eq .Values.target "cluster-b" }}
    {{- "http://garage-cluster-b.garage-operator:3900" -}}
  {{- else }}
    {{- "http://synology.alexlebens.dev:3900" -}}
  {{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "s3Bucket.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "s3Bucket.labels" -}}
helm.sh/chart: {{ include "s3Bucket.chart" . }}
{{ include "s3Bucket.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "s3Bucket.selectorLabels" -}}
app.kubernetes.io/name: {{ include "s3Bucket.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
