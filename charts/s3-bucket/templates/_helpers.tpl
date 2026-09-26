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
Normalize target identifier
*/}}
{{- define "s3Bucket.normalizeTarget" -}}
  {{- $t := . | default "b" -}}
  {{- if or (eq $t "a") (eq $t "a_ps02sn") (eq $t "synology-a") -}}
    {{- "a_ps02sn" -}}
  {{- else if or (eq $t "b") (eq $t "b_cl01tl") (eq $t "cluster_b") (eq $t "cluster-b") -}}
    {{- "b_cl01tl" -}}
  {{- else if or (eq $t "c") (eq $t "c_ps10rp") -}}
    {{- "c_ps10rp" -}}
  {{- else if or (eq $t "d") (eq $t "d_cs01bb") (eq $t "backblaze") -}}
    {{- "d_cs01bb" -}}
  {{- else -}}
    {{- $t -}}
  {{- end -}}
{{- end }}

{{/*
Determine S3 endpoint based on primary target tier
*/}}
{{- define "s3Bucket.endpoint" -}}
  {{- $t := include "s3Bucket.normalizeTarget" .Values.target -}}
  {{- if eq $t "a_ps02sn" -}}
    {{- "http://synology.alexlebens.dev:3900" -}}
  {{- else if eq $t "b_cl01tl" -}}
    {{- "http://garage-cluster-b.garage-operator:3900" -}}
  {{- else if eq $t "c_ps10rp" -}}
    {{- "http://ps10rp.alexlebens.dev:3900" -}}
  {{- else if eq $t "d_cs01bb" -}}
    {{- "https://s3.us-east-005.backblazeb2.com" -}}
  {{- else -}}
    {{- "http://garage-cluster-b.garage-operator:3900" -}}
  {{- end -}}
{{- end }}

{{/*
Determine backup destination endpoint
*/}}
{{- define "s3Bucket.backupEndpoint" -}}
  {{- $backupKey := index . 0 -}}
  {{- $backupConfig := index . 1 -}}
  {{- if and $backupConfig.destination $backupConfig.destination.endpoint -}}
    {{- $backupConfig.destination.endpoint -}}
  {{- else -}}
    {{- $t := include "s3Bucket.normalizeTarget" $backupKey -}}
    {{- if eq $t "a_ps02sn" -}}
      {{- "http://synology.alexlebens.dev:3900" -}}
    {{- else if eq $t "b_cl01tl" -}}
      {{- "http://garage-cluster-b.garage-operator:3900" -}}
    {{- else if eq $t "c_ps10rp" -}}
      {{- "http://ps10rp.alexlebens.dev:3900" -}}
    {{- else if eq $t "d_cs01bb" -}}
      {{- "https://s3.us-east-005.backblazeb2.com" -}}
    {{- else -}}
      {{- "http://garage-cluster-b.garage-operator:3900" -}}
    {{- end -}}
  {{- end -}}
{{- end }}

{{/*
Determine backup external secret path prefix
*/}}
{{- define "s3Bucket.backupSecretPathPrefix" -}}
  {{- $backupKey := index . 0 -}}
  {{- $backupConfig := index . 1 -}}
  {{- if and $backupConfig.externalSecret $backupConfig.externalSecret.secretPathPrefix -}}
    {{- $backupConfig.externalSecret.secretPathPrefix -}}
  {{- else -}}
    {{- $t := include "s3Bucket.normalizeTarget" $backupKey -}}
    {{- if eq $t "d_cs01bb" -}}
      {{- "/backblaze/home-infra" -}}
    {{- else -}}
      {{- "/garage/home-infra" -}}
    {{- end -}}
  {{- end -}}
{{- end }}

{{/*
Sanitize string for RFC 1123 DNS subdomain (replace underscores with hyphens)
*/}}
{{- define "s3Bucket.sanitize" -}}
  {{- . | replace "_" "-" | lower | trunc 63 | trimSuffix "-" -}}
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
