{{/*
Expand the name of the chart.
*/}}
{{- define "cluster.name" -}}
  {{- if .Values.nameOverride }}
    {{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- printf "%s-postgres" .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Extract the PostgreSQL major version from the configured image tag.
*/}}
{{- define "cluster.majorVersion" -}}
  {{- (semver (regexReplaceAll "@sha256:.*$" .Values.cluster.image.tag "")).Major | toString -}}
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
  {{- if .Values.recovery.objectStore.serverNameOverride -}}
    {{- .Values.recovery.objectStore.serverNameOverride | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- $base := default (include "cluster.name" .) .Values.recovery.objectStore.clusterName -}}
    {{- printf "%s-pg%s-backup-%s" $base (include "cluster.majorVersion" .) (toString .Values.recovery.objectStore.index) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Generate recovery destination path
*/}}
{{- define "cluster.recoveryDestinationPath" -}}
  {{- if .Values.recovery.objectStore.destinationPathOverride -}}
    {{- .Values.recovery.objectStore.destinationPathOverride -}}
  {{- else -}}
    {{- $base := default (include "cluster.name" .) .Values.recovery.objectStore.clusterName -}}
    {{- printf "s3://%s/%s/%s/%s-cluster" (.Values.recovery.objectStore.destinationBucket) (.Values.kubernetesClusterName) (include "cluster.namespace" .) $base | trimSuffix "-" -}}
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
    {{- printf "%s-pg%s-backup-%s" (include "cluster.name" .) (include "cluster.majorVersion" .) (toString .Values.backup.objectStore.index) | trunc 63 | trimSuffix "-" -}}
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

{{/*
Generate default inherited annotations for CNPG pods (such as version-checker match-regex) merged with user overrides
*/}}
{{- define "cluster.inheritedAnnotations" -}}
  {{- $defaults := dict -}}
  {{- $tag := .Values.cluster.image.tag | default "" -}}
  {{- $cleanTag := regexReplaceAll "@sha256:.*$" $tag "" -}}
  {{- if regexMatch "^[0-9]+\\.[0-9]+-[a-z][a-z0-9-]*$" $cleanTag -}}
    {{- $suffix := regexReplaceAll "^[0-9]+\\.[0-9]+-" $cleanTag "" -}}
    {{- $_ := set $defaults "match-regex.version-checker.io/postgres" (printf "^[0-9]+\\.[0-9]+-%s$" $suffix) -}}
  {{- else if regexMatch "^[0-9]+-[0-9]+-[a-z][a-z0-9-]*$" $cleanTag -}}
    {{- $suffix := regexReplaceAll "^[0-9]+-[0-9]+-" $cleanTag "" -}}
    {{- $_ := set $defaults "match-regex.version-checker.io/postgres" (printf "^[0-9]+-[0-9]+-%s$" $suffix) -}}
  {{- else if regexMatch "^[0-9]+\\.[0-9]+-[0-9]+\\.[0-9]+\\.[0-9]+$" $cleanTag -}}
    {{- $_ := set $defaults "match-regex.version-checker.io/postgres" "^[0-9]+\\.[0-9]+-[0-9]+\\.[0-9]+\\.[0-9]+$" -}}
  {{- end -}}
  {{- $userAnnotations := dict -}}
  {{- if and .Values.cluster.inheritedMetadata .Values.cluster.inheritedMetadata.annotations -}}
    {{- $userAnnotations = deepCopy .Values.cluster.inheritedMetadata.annotations -}}
  {{- end -}}
  {{- $merged := mergeOverwrite $defaults $userAnnotations -}}
  {{- if $merged -}}
    {{- toYaml $merged -}}
  {{- end -}}
{{- end -}}
