{{/*
Generate the root name
*/}}
{{- define "rclone.name" -}}
  {{- if .Values.nameOverride }}
    {{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-rclone" .Values.rclone.source.bucketName | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate the secret name
*/}}
{{- define "rclone.sourceSecretName" -}}
  {{- if .Values.secret.externalSecret.enabled }}
    {{- if .Values.secret.externalSecret.source.nameOverride }}
      {{- .Values.secret.externalSecret.source.nameOverride | trunc 63 | trimSuffix "-" }}
    {{- else }}
      {{- printf "%s-rclone-source-config" .Values.rclone.source.bucketName -}}
    {{- end }}
  {{- else if .Values.secret.existingSecretSource.name }}
    {{- printf "%s" .Values.secret.existingSecretSource.name -}}
  {{- else }}
    {{ fail "No Secret Name Found!" }}
  {{- end }}
{{- end }}

{{- define "rclone.destinationSecretName" -}}
  {{- if .Values.secret.externalSecret.enabled }}
    {{- if .Values.secret.externalSecret.destination.nameOverride }}
      {{- .Values.secret.externalSecret.destination.nameOverride | trunc 63 | trimSuffix "-" }}
    {{- else }}
      {{- printf "%s-rclone-destination-config" .Values.rclone.destination.bucketName -}}
    {{- end }}
  {{- else if .Values.secret.existingSecretDestination.name }}
    {{- printf "%s" .Values.secret.existingSecretDestination.name -}}
  {{- else }}
    {{ fail "No Secret Name Found!" }}
  {{- end }}
{{- end }}

{{/*
Common env names
*/}}
{{- define "secret.envAccessKey" -}}
ACCESS_KEY_ID
{{- end }}
{{- define "secret.envSecretKey" -}}
ACCESS_SECRET_KEY
{{- end }}
{{- define "secret.envRegion" -}}
ACCESS_REGION
{{- end }}
{{- define "secret.envSrcEndpoint" -}}
SRC_ENDPOINT
{{- end }}
{{- define "secret.envDestEndpoint" -}}
DEST_ENDPOINT
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
