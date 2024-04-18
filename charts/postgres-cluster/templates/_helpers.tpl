{{/*
Expand the name of the chart.
*/}}
{{- define "cluster.name" -}}
  {{- if .Values.nameOverride }}
    {{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "postgresql-%s-%s" .Values.cluster.image.majorVersion .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cluster.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cluster.labels" -}}
helm.sh/chart: {{ include "cluster.chart" . }}
{{ include "cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: cloudnative-pg
{{- end }}

{{/*
Generate name for object store credentials
*/}}
{{- define "cluster.recoveryCredentials" -}}
  {{- if .Values.recovery.endpointCredentials -}}
    {{- .Values.recovery.endpointCredentials -}}
  {{- else -}}
    {{- printf "%s-backup-secret" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{- define "cluster.backupCredentials" -}}
  {{- if .Values.backup.endpointCredentials -}}
    {{- .Values.backup.endpointCredentials -}}
  {{- else -}}
    {{- printf "%s-backup-secret" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate backup server name
*/}}
{{- define "cluster.backupName" -}}
  {{- if .Values.backup.backupName -}}
    {{- .Values.backup.backupName -}}
  {{- else -}}
    {{ include "cluster.name" . }}
  {{- end }}
{{- end }}


{{/*
Generate recovery server name
*/}}
{{- define "cluster.recoveryName" -}}
  {{- if .Values.recovery.recoveryName -}}
    {{- .Values.recovery.recoveryName -}}
  {{- else -}}
    {{ include "cluster.name" . }}
  {{- end }}
{{- end }}
