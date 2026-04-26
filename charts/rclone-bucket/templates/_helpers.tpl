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
{{- define "secretRclone.envAccessKey" -}}
ACCESS_KEY_ID
{{- end }}
{{- define "secretRclone.envSecretKey" -}}
ACCESS_SECRET_KEY
{{- end }}
{{- define "secretRclone.envRegion" -}}
ACCESS_REGION
{{- end }}
{{- define "secretRclone.envSrcEndpoint" -}}
SRC_ENDPOINT
{{- end }}
{{- define "secretRclone.envDestEndpoint" -}}
DEST_ENDPOINT
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "secretRclone.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "secretRclone.labels" -}}
helm.sh/chart: {{ include "secretRclone.chart" $ }}
{{ include "secretRclone.selectorLabels" $ }}
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
{{- define "secretRclone.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}
