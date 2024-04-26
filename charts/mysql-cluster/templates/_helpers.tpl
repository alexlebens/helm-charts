{{/*
Expand the name of the chart.
*/}}
{{- define "cluster.name" -}}
  {{- if .Values.global.nameOverride }}
    {{- .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-mysql-%s" .Release.Name ((semver .Values.cluster.image.version).Major | toString) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cluster.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Check for invalid versions
*/}}
{{- $minimalVersion := "8.0.27" }}
{{- $forbiddenVersions := list "8.0.29" }}
{{- $serverVersion := .Values.serverVersion | default .Chart.AppVersion }}
{{- if lt $serverVersion $minimalVersion }}
  {{- $err := printf "It is not possible to use MySQL version %s . Please, use %s or above" $serverVersion $minimalVersion }}
  {{- fail $err }}
{{- end }}
{{- if has $serverVersion $forbiddenVersions }}
  {{- $err := printf "It is not possible to use MySQL version %s . Please, use %s or above except %v" $serverVersion $minimalVersion $forbiddenVersions }}
  {{- fail $err }}
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
Create the name of the service account to use.
*/}}
{{- define "mysql.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled -}}
    {{ default (include "cluster.name" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
