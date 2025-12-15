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

{{- define "volsync.localRepoName" -}}
  {{- if .Values.local.restic.repository }}
    {{- .Values.local.restic.repository | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-secret-local" (include "volsync.name" .) -}}
  {{- end }}
{{- end }}

{{- define "volsync.remoteRepoName" -}}
  {{- if .Values.remote.restic.repository }}
    {{- .Values.remote.restic.repository | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-secret-remote" (include "volsync.name" .) -}}
  {{- end }}
{{- end }}

{{- define "volsync.externalRepoName" -}}
  {{- if .Values.external.restic.repository }}
    {{- .Values.external.restic.repository | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-secret-external" (include "volsync.name" .) -}}
  {{- end }}
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
app.kubernetes.io/version: {{ .Chart.Version | quote }}
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
