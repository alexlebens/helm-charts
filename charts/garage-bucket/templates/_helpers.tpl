{{/*
Generate the bucket name
*/}}
{{- define "garageBucket.name" -}}
  {{- if .Values.bucketName }}
    {{- .Values.bucketName | trunc 63 | trimSuffix "-" -}}
  {{- else }}
    {{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate the bucket key name
*/}}
{{- define "garageKey.name" -}}
    {{- printf "%s-key" (include "garageBucket.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate the external secret name
*/}}
{{- define "garageSecret.name" -}}
    {{- printf "%s-secret" (include "garageBucket.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate the external secret backup A name
*/}}
{{- define "garageSecretBackup.name" -}}
    {{- printf "%s-backup" (include "garageSecret.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate the cron job name
*/}}
{{- define "garageCronJob.name" -}}
    {{- printf "%s-backup" (include "garageBucket.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "garageBucket.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "garageBucket.labels" -}}
helm.sh/chart: {{ include "garageBucket.chart" $ }}
{{ include "garageBucket.selectorLabels" $ }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "garageBucket.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}
