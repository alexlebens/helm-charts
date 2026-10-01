{{/*
Expand the names
*/}}
{{- define "volsync.name" -}}
  {{- if .Values.nameOverride }}
    {{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-backup" .Values.pvcTarget -}}
  {{- end }}
{{- end }}

{{/*
Repository secret name for a given tier (e.g. a, b, c, d)
Usage: include "volsync.repoName" (dict "root" $ "tier" "a")
*/}}
{{- define "volsync.repoName" -}}
  {{- $tierConfig := index .root.Values .tier | default dict -}}
  {{- if and $tierConfig.restic $tierConfig.restic.repository -}}
    {{- $tierConfig.restic.repository | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-secret-%s" (include "volsync.name" .root) .tier -}}
  {{- end -}}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "volsync.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "volsync.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "volsync.labels" -}}
helm.sh/chart: {{ include "volsync.chart" $ }}
{{ include "volsync.selectorLabels" $ }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "volsync.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}
