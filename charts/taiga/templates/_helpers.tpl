{{/*
Expand the name of the chart.
*/}}
{{- define "taiga.name" -}}
  {{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "taiga.fullname" -}}
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
{{- define "taiga.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "taiga.labels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}
helm.sh/chart: {{ template "taiga.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common labels for specific components
*/}}
{{- define "taiga.back.labels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-back
helm.sh/chart: {{ template "taiga.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "taiga.async.labels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-async
helm.sh/chart: {{ template "taiga.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "taiga.front.labels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-front
helm.sh/chart: {{ template "taiga.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "taiga.events.labels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-events
helm.sh/chart: {{ template "taiga.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "taiga.protected.labels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-protected
helm.sh/chart: {{ template "taiga.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "taiga.matchLabels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "taiga.back.matchLabels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-back
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "taiga.async.matchLabels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-async
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "taiga.front.matchLabels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-front
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "taiga.events.matchLabels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-events
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "taiga.protected.matchLabels" -}}
app.kubernetes.io/name: {{ template "taiga.name" . }}-protected
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "taiga.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create -}}
    {{ default (include "taiga.fullname" .) .Values.serviceAccount.name }}
  {{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the static persistent volume
*/}}
{{- define "taiga.staticVolumeName" -}}
  {{- if .Values.persistence.static.existingClaim -}}
    {{ .Values.persistence.static.existingClaim }}
  {{- else -}}
    {{ printf "%s-static" (include "taiga.fullname" .) | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of the media persistent volume
*/}}
{{- define "taiga.mediaVolumeName" -}}
  {{- if .Values.persistence.media.existingClaim -}}
    {{ .Values.persistence.media.existingClaim }}
  {{- else -}}
    {{ printf "%s-media" (include "taiga.fullname" .) | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}
