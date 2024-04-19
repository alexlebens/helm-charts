{{/*
Expand the name of the chart.
*/}}
{{- define "kyoo.name" -}}
  {{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kyoo.fullname" -}}
  {{- if .Values.global.fullnameOverride -}}
    {{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- $name := default .Chart.Name .Values.global.nameOverride -}}
    {{- if contains $name .Release.Name -}}
      {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label
*/}}
{{- define "kyoo.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kyoo.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common labels for specific components
*/}}
{{- define "kyoo.autosync.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-autosync
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "kyoo.back.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-back
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "kyoo.front.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-front
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "kyoo.matcher.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-matcher
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "kyoo.migrations.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-migrations
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "kyoo.scanner.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-scanner
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "kyoo.transcoder.labels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-transcoder
helm.sh/chart: {{ template "kyoo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "kyoo.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.autosync.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-autosync
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.back.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-back
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.front.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-front
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.matcher.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-matcher
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.migrations.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-migrations
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.scanner.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-scanner
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "kyoo.transcoder.matchLabels" -}}
app.kubernetes.io/name: {{ template "kyoo.name" . }}-transcoder
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kyoo.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create -}}
    {{ default (include "kyoo.fullname" .) .Values.serviceAccount.name }}
  {{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the back persistent volume
*/}}
{{- define "kyoo.backVolumeName" -}}
  {{- if .Values.persistence.back.existingClaim -}}
    {{ .Values.persistence.back.existingClaim }}
  {{- else -}}
    {{ printf "%s-back" (include "kyoo.fullname" .) | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the metadata persistent volume
*/}}
{{- define "kyoo.metadataVolumeName" -}}
  {{- if .Values.persistence.metadata.existingClaim -}}
    {{ .Values.persistence.metadata.existingClaim }}
  {{- else -}}
    {{ printf "%s-metadata" (include "kyoo.fullname" .) | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}
