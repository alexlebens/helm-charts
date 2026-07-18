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
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
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
Generate recovery name
*/}}
{{- define "cluster.recoveryName" -}}
  {{- printf "%s-recovery" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate recovery server name
*/}}
{{- define "cluster.recoveryServerName" -}}
  {{- printf "%s-backup-%s" (include "cluster.name" .) (toString .Values.recovery.objectStore.index) | trunc 63 | trimSuffix "-" -}}
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
  {{- if .Values.recovery.objectStore.endpointCredentials.name -}}
    {{- .Values.recovery.objectStore.endpointCredentials.name -}}
  {{- else -}}
    {{- printf "%s-recovery-secret" (include "cluster.name" .) -}}
  {{- end }}
{{- end }}

{{/*
Generate recovery CA secret name
*/}}
{{- define "cluster.recoveryCaSecretName" -}}
  {{- if .Values.recovery.objectStore.endpointCA.name -}}
    {{- .Values.recovery.objectStore.endpointCA.name -}}
  {{- else -}}
    {{- printf "%s-recovery-ca" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end }}

{{/*
Generate backup name
*/}}
{{- define "cluster.backupName" -}}
  {{- printf "%s-backup" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate backup server name
*/}}
{{- define "cluster.backupServerName" -}}
  {{- if .Values.backup.backupServerName -}}
    {{- .Values.backup.backupServerName -}}
  {{- else -}}
    {{- printf "%s" (include "cluster.backupName" .) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate backup destination path
*/}}
{{- define "cluster.backupDestinationPath" -}}
  {{- if .Values.backup.objectStore.destinationPathOverride -}}
    {{- .Values.backup.objectStore.destinationPathOverride -}}
  {{- else if .Values.backup.objectStore.destinationBucket -}}
    {{- printf "s3://%s/%s/%s/%s-cluster" .Values.backup.objectStore.destinationBucket .Values.kubernetesClusterName (include "cluster.namespace" .) (include "cluster.name" .) | trimSuffix "-" -}}
  {{-  else -}}
    {{ fail "Invalid destination path!" }}
  {{- end -}}
{{- end }}

{{/*
Generate backup secret name
*/}}
{{- define "cluster.backupSecretName" -}}
  {{- if .Values.backup.objectStore.endpointCredentials.name -}}
    {{- .Values.backup.objectStore.endpointCredentials.name -}}
  {{- else -}}
    {{- printf "%s-backup-secret" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end }}

{{/*
Generate backup CA secret name
*/}}
{{- define "cluster.backupCaSecretName" -}}
  {{- if .Values.backup.objectStore.endpointCA.name -}}
    {{- .Values.backup.objectStore.endpointCA.name -}}
  {{- else -}}
    {{- printf "%s-ca" (include "cluster.backupName" .) | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end }}
