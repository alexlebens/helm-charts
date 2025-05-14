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
app.kubernetes.io/name: {{ include "cluster.name" $ }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: cloudnative-pg
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
Whether we need to use TimescaleDB defaults
*/}}
{{- define "cluster.useTimescaleDBDefaults" -}}
{{ and (eq .Values.type "timescaledb") .Values.imageCatalog.create (empty .Values.cluster.imageCatalogRef.name) (empty .Values.imageCatalog.images) (empty .Values.cluster.imageName) }}
{{- end -}}

{{/*
Cluster Image Name
If a custom imageName is available, use it, otherwise use the defaults based on the .Values.type
*/}}
{{- define "cluster.imageName" -}}
    {{- if .Values.cluster.image.repository -}}
        {{- printf "%s:%s" .Values.cluster.image.repository .Values.cluster.image.tag -}}
    {{- else if eq .Values.type "postgresql" -}}
        {{- printf "ghcr.io/cloudnative-pg/postgresql:%s" .Values.version.postgresql -}}
    {{- else if eq .Values.type "postgis" -}}
        {{- printf "ghcr.io/cloudnative-pg/postgis:%s-%s" .Values.version.postgresql .Values.version.postgis -}}
    {{- else -}}
        {{ fail "Invalid cluster type!" }}
    {{- end }}
{{- end -}}

{{/*
Cluster Image
If imageCatalogRef defined, use it, otherwise calculate ordinary imageName.
*/}}
{{- define "cluster.image" }}
{{- if .Values.cluster.imageCatalogRef.name }}
imageCatalogRef:
  apiGroup: postgresql.cnpg.io
  {{- toYaml .Values.cluster.imageCatalogRef | nindent 2 }}
  major: {{ include "cluster.postgresqlMajor" . }}
{{- else if and .Values.imageCatalog.create (not (empty .Values.imageCatalog.images )) }}
imageCatalogRef:
  apiGroup: postgresql.cnpg.io
  kind: ImageCatalog
  name: {{ include "cluster.name" . }}
  major: {{ include "cluster.postgresqlMajor" . }}
{{- else if eq (include "cluster.useTimescaleDBDefaults" .) "true" -}}
imageCatalogRef:
  apiGroup: postgresql.cnpg.io
  kind: ImageCatalog
  name: {{ include "cluster.name" . }}-timescaledb-ha
  major: {{ include "cluster.postgresqlMajor" . }}
{{- else }}
imageName: {{ include "cluster.imageName" . }}
{{- end }}
{{- end }}

{{/*
Generate name for object store credentials
*/}}
{{- define "cluster.recoveryCredentials" -}}
  {{- if .Values.recovery.endpointCredentials -}}
    {{- .Values.recovery.endpointCredentials -}}
  {{- else -}}
    {{- printf "%s-backup-secret" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{- define "cluster.backupCredentials" -}}
  {{- if .Values.backup.endpointCredentials -}}
    {{- .Values.backup.endpointCredentials -}}
  {{- else -}}
    {{- printf "%s-backup-secret" (include "cluster.name" .) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}

{{/*
Postgres UID
*/}}
{{- define "cluster.postgresUID" -}}
  {{- if ge (int .Values.cluster.postgresUID) 0 -}}
    {{- .Values.cluster.postgresUID }}
  {{- else if and (eq (include "cluster.useTimescaleDBDefaults" .) "true") (eq .Values.type "timescaledb") -}}
    {{- 1000 -}}
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
  {{- else if and (eq (include "cluster.useTimescaleDBDefaults" .) "true") (eq .Values.type "timescaledb") -}}
    {{- 1000 -}}
  {{- else -}}
    {{- 26 -}}
  {{- end -}}
{{- end -}}

{{/*
Generate backup server name
*/}}
{{- define "cluster.backupName" -}}
  {{- if .Values.backup.backupName -}}
    {{- .Values.backup.backupName -}}
  {{- else -}}
    {{ include "cluster.name" . }}
  {{- end }}
{{- end }}

{{/*
Generate recovery server name
*/}}
{{- define "cluster.recoveryServerName" -}}
  {{- if .Values.recovery.recoveryServerName -}}
    {{- .Values.recovery.recoveryServerName -}}
  {{- else -}}
    {{- printf "%s-backup-%s" (include "cluster.name" .) (toString .Values.recovery.recoveryIndex) | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end }}
