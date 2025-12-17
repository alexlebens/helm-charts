{{/*
Generate the secret name
*/}}
{{- define "secret.name" -}}
  {{- if .Values.secret.externalSecret.enabled }}
    {{- if .Values.secret.externalSecret.nameOverride }}
      {{- .Values.secret.externalSecret.nameOverride | trunc 63 | trimSuffix "-" }}
    {{- else }}
      {{- printf "%s-cloudflared-secret" .Release.Name -}}
    {{- end }}
  {{- else if .Values.secret.existingSecret.name }}
    {{- printf "%s" .Values.secret.existingSecret.name -}}
  {{- else }}
    {{ fail "No Secret Name Found!" }}
  {{- end }}
{{- end }}

{{/*
Generate the name of the secret key
*/}}
{{- define "secret.key" -}}
  {{- if .Values.secret.externalSecret.enabled }}
    {{- printf "cf-tunnel-token" -}}
  {{- else if .Values.secret.existingSecret.key }}
    {{- printf "%s" .Values.secret.existingSecret.key -}}
  {{- else }}
    {{ fail "No Secret Key Found!" }}
  {{- end }}
{{- end }}

{{/*
Generate path in the secret store
*/}}
{{- define "secret.path" -}}
  {{- if and (.Values.secret.externalSecret.enabled) (.Values.secret.externalSecret.store.path) }}
    {{- printf "%s/%s" .Values.secret.externalSecret.store.path .Release.Name -}}
  {{- else }}
    {{ fail "No Secret Store Path Found!" }}
  {{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "secret.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "secret.labels" -}}
helm.sh/chart: {{ include "secret.chart" $ }}
{{ include "secret.selectorLabels" $ }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "secret.name" . }}
{{- with .Values.secret.externalSecret.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "secret.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}
