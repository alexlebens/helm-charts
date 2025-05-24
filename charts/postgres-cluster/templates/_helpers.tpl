{{/*
Expand the name of the chart.
*/}}
{{- define "cluster.name" -}}
  {{- if not (empty .Values.nameOverride ) }}
    {{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-postgresql-%s" .Release.Name ((semver .Values.cluster.image.tag).Major | toString) | trunc 63 | trimSuffix "-" -}}
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
helm.sh/chart: {{ include "cluster.chart" $ }}
{{ include "cluster.selectorLabels" $ }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.cluster.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cluster.name" $ }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "cluster.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Postgres UID
*/}}
{{- define "cluster.postgresUID" -}}
  {{- if ge (int .Values.cluster.postgresUID) 0 -}}
    {{- .Values.cluster.postgresUID }}
  {{- else -}}
    {{- 26 -}}
  {{- end -}}
{{- end -}}

{{/*
Postgres GID
*/}}
{{- define "cluster.postgresGID" -}}
  {{- if ge (int .Values.cluster.postgresGID) 0 -}}
    {{- .Values.cluster.postgresGID }}
  {{- else -}}
    {{- 26 -}}
  {{- end -}}
{{- end -}}

{{/*
Generate recovery server name
*/}}
{{- define "cluster.recoveryServerName" -}}
  {{- if .Values.recovery.recoveryServerName -}}
    {{- .Values.recovery.recoveryServerName -}}
  {{- else -}}
    {{- printf "%s-backup-%s" (include "cluster.name" .) (toString .Values.recovery.recoveryIndex) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate name for recovery object store credentials
*/}}
{{- define "cluster.recoveryCredentials" -}}
  {{- if .Values.recovery.endpointCredentials -}}
    {{- .Values.recovery.endpointCredentials -}}
  {{- else -}}
    {{- printf "%s-backup-secret" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}
