{{/*
Expand the name of the chart.
*/}}
{{- define "cluster.name" -}}
  {{- if .Values.nameOverride }}
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
    {{- printf "%s-backup-%s" (include "cluster.name" .) (toString .Values.recovery.objectStore.index) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate recovery destination path
*/}}
{{- define "cluster.recoveryDestinationPath" -}}
  {{- if .Values.recovery.objectStore.destinationPathOverride -}}
    {{- .Values.recovery.objectStore.destinationPathOverride -}}
  {{- else -}}
    {{- printf "s3://%s/%s/%s/%s-cluster" (.Values.recovery.objectStore.destinationBucket) (.Values.kubernetesClusterName) (include "cluster.namespace" .) (include "cluster.name" .) | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate recovery credentials name
*/}}
{{- define "cluster.recoverySecretName" -}}
  {{- if and (.Values.recovery.objectStore.endpointCredentials) (not .Values.recovery.objectStore.externalSecret.enabled) }}
    {{- .Values.recovery.objectStore.endpointCredentials | trunc 63 | trimSuffix "-" }}
  {{- else -}}
    {{- printf "%s-recovery-secret" (include "cluster.name" .) -}}
  {{- end }}
{{- end }}

{{/*
Generate backup destination path
*/}}
{{- define "cluster.backupDestinationPath" -}}
  {{- if .instance.destinationPathOverride -}}
    {{- .instance.destinationPathOverride -}}
  {{- else if .instance.destinationBucket -}}
    {{- printf "s3://%s/%s/%s/%s-cluster" .instance.destinationBucket .global.Values.kubernetesClusterName (include "cluster.namespace" .global) (include "cluster.name" .global) | trimSuffix "-" -}}
  {{-  else -}}
    {{ fail "Invalid destination path!" }}
  {{- end -}}
{{- end }}

{{/*
Generate backup destination path
*/}}
{{- define "cluster.backupSecretName" -}}
  {{- if .instance.endpointCredentialsOverride -}}
    {{- .instance.endpointCredentialsOverride -}}
  {{- else if .instance.name -}}
    {{- printf "%s-backup-%s-secret" (include "cluster.name" .global) .instance.name | trunc 63 | trimSuffix "-" -}}
  {{-  else -}}
    {{ fail "Invalid backup secret name!" }}
  {{- end -}}
{{- end }}
