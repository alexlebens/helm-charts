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

{{/*
Repository secret name for a given tier (e.g. a, b, c, d)
Usage: include "volsync.repoName" (dict "root" $ "tier" "a")
*/}}
{{- define "volsync.repoName" -}}
  {{- $tierConfig := index .root.Values .tier | default dict -}}
  {{- if and $tierConfig.restic $tierConfig.restic.repository -}}
    {{- $tierConfig.restic.repository | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-secret-%s" (include "volsync.name" .root) .tier -}}
  {{- end -}}
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
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
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

{{/*
Calculate max sync lag threshold in seconds based on cron schedule.
Usage: include "volsync.syncLagThresholdSeconds" (dict "schedule" .schedule "override" .maxSyncLag)
*/}}
{{- define "volsync.syncLagThresholdSeconds" -}}
{{- if .override -}}
  {{- .override -}}
{{- else -}}
  {{- $parts := splitList " " (trim .schedule) -}}
  {{- if eq (len $parts) 5 -}}
    {{- $min := index $parts 0 -}}
    {{- $hour := index $parts 1 -}}
    {{- $dom := index $parts 2 -}}
    {{- $dow := index $parts 4 -}}
    {{- if ne $dow "*" -}}
      {{- /* Weekly: 7 days + 24h grace = 8 days = 691200s */ -}}
      {{- 691200 -}}
    {{- else if ne $dom "*" -}}
      {{- /* Monthly: 30 days + 48h grace = 32 days = 2764800s */ -}}
      {{- 2764800 -}}
    {{- else if contains "/" $hour -}}
      {{- $step := last (splitList "/" $hour) | atoi -}}
      {{- /* Every X hours + 50% grace: e.g. 4h -> 6h */ -}}
      {{- mul $step 5400 -}}
    {{- else if ne $hour "*" -}}
      {{- /* Daily: 24 hours + 12h grace = 36 hours = 129600s */ -}}
      {{- 129600 -}}
    {{- else if contains "/" $min -}}
      {{- $step := last (splitList "/" $min) | atoi -}}
      {{- /* Every X minutes + 100% grace: e.g. 15m -> 30m */ -}}
      {{- mul $step 120 -}}
    {{- else -}}
      {{- /* Hourly: 1 hour + 2h grace = 3 hours = 10800s */ -}}
      {{- 10800 -}}
    {{- end -}}
  {{- else -}}
    {{- /* Fallback to 36 hours (daily + 12h) */ -}}
    {{- 129600 -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Human-readable representation of lag threshold.
Usage: include "volsync.syncLagThresholdHuman" (dict "schedule" .schedule "override" .maxSyncLag)
*/}}
{{- define "volsync.syncLagThresholdHuman" -}}
{{- $secs := include "volsync.syncLagThresholdSeconds" . | trim | atoi -}}
{{- if ge $secs 172800 -}}
  {{- printf "%dd" (div $secs 86400) -}}
{{- else if ge $secs 3600 -}}
  {{- printf "%dh" (div $secs 3600) -}}
{{- else -}}
  {{- printf "%dm" (div $secs 60) -}}
{{- end -}}
{{- end -}}
