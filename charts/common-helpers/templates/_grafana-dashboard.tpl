{{/*
Valid Grafana folder UIDs matching grafana-operator GrafanaFolder resources
*/}}
{{- define "custom.grafanaDashboard.validFolders" -}}
overview,hardware,kubernetes,networking,storage,platform,applications,iot
{{- end }}

{{/*
Reserved top-level configuration keys under grafanaDashboard (non-dashboard entries)
*/}}
{{- define "custom.grafanaDashboard.reservedKeys" -}}
enabled,namespace,folder,folderUID,folderRef,resyncPeriod,instanceSelector,allowCrossNamespaceImport,suspend,labels,annotations
{{- end }}

{{/*
Returns "true" when a dashboard entry defines an explicit remote or inline model source
*/}}
{{- define "custom.grafanaDashboard.hasExternalSource" -}}
{{- if or .url .grafanaCom .configMapRef .oci .json .gzipJson .jsonnet -}}true{{- end -}}
{{- end }}

{{/*
Render a single GrafanaDashboard resource.
Expects a dict with keys: root, name, defaults, item, fileJson.
*/}}
{{- define "custom.grafanaDashboard.render" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $defaults := .defaults | default dict -}}
{{- $item := .item | default dict -}}
{{- $fileJson := .fileJson | default "" -}}
{{- $validFolders := splitList "," (include "custom.grafanaDashboard.validFolders" $root) -}}
{{- $enabled := true -}}
{{- if hasKey $defaults "enabled" }}
  {{- $enabled = $defaults.enabled -}}
{{- end }}
{{- if hasKey $item "enabled" }}
  {{- $enabled = $item.enabled -}}
{{- end }}
{{- if $enabled }}
{{- $namespace := $item.namespace | default $defaults.namespace | default "grafana-operator" -}}
{{- $resyncPeriod := $item.resyncPeriod | default $defaults.resyncPeriod | default "6h" -}}
{{- $instanceSelector := $item.instanceSelector | default $defaults.instanceSelector | default (dict "matchLabels" (dict "app" "grafana-main")) -}}
{{- $extraLabels := merge (deepCopy ($item.labels | default dict)) ($defaults.labels | default dict) -}}
{{- $annotations := merge (deepCopy ($item.annotations | default dict)) ($defaults.annotations | default dict) -}}
{{- $hasAllowCross := hasKey $item "allowCrossNamespaceImport" -}}
{{- $allowCross := false -}}
{{- if $hasAllowCross }}
  {{- $allowCross = $item.allowCrossNamespaceImport -}}
{{- else if hasKey $defaults "allowCrossNamespaceImport" }}
  {{- $hasAllowCross = true -}}
  {{- $allowCross = $defaults.allowCrossNamespaceImport -}}
{{- end -}}
{{- $hasSuspend := hasKey $item "suspend" -}}
{{- $suspend := false -}}
{{- if $hasSuspend }}
  {{- $suspend = $item.suspend -}}
{{- else if hasKey $defaults "suspend" }}
  {{- $hasSuspend = true -}}
  {{- $suspend = $defaults.suspend -}}
{{- end -}}
{{- $folderField := "folderUID" -}}
{{- $folderValue := "" -}}
{{- if $item.folderRef }}
  {{- $folderField = "folderRef" -}}
  {{- $folderValue = $item.folderRef -}}
{{- else if $item.folderUID }}
  {{- $folderValue = $item.folderUID -}}
{{- else if $item.folder }}
  {{- if not (has $item.folder $validFolders) }}
    {{- fail (printf "Invalid Grafana folder %q for dashboard %q; must be one of: %s" $item.folder $name (join ", " $validFolders)) -}}
  {{- end }}
  {{- $folderValue = printf "grafana-folder-%s" $item.folder -}}
{{- else if $defaults.folderRef }}
  {{- $folderField = "folderRef" -}}
  {{- $folderValue = $defaults.folderRef -}}
{{- else if $defaults.folderUID }}
  {{- $folderValue = $defaults.folderUID -}}
{{- else }}
  {{- $folder := $defaults.folder | default "applications" -}}
  {{- if not (has $folder $validFolders) }}
    {{- fail (printf "Invalid Grafana folder %q for dashboard %q; must be one of: %s" $folder $name (join ", " $validFolders)) -}}
  {{- end }}
  {{- $folderValue = printf "grafana-folder-%s" $folder -}}
{{- end }}
---
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDashboard
metadata:
  name: {{ $name }}
  namespace: {{ $namespace }}
  labels:
    app.kubernetes.io/name: {{ $name }}
    {{- include "custom.labels" $root | nindent 4 }}
    {{- with $extraLabels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  instanceSelector:
    {{- toYaml $instanceSelector | nindent 4 }}
  {{ $folderField }}: {{ $folderValue }}
  resyncPeriod: {{ $resyncPeriod }}
  {{- if $hasAllowCross }}
  allowCrossNamespaceImport: {{ $allowCross }}
  {{- end }}
  {{- if $hasSuspend }}
  suspend: {{ $suspend }}
  {{- end }}
  {{- with $item.uid }}
  uid: {{ . | quote }}
  {{- end }}
  {{- with $item.contentCacheDuration }}
  contentCacheDuration: {{ . | quote }}
  {{- end }}
  {{- with $item.datasources }}
  datasources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.plugins }}
  plugins:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.variables }}
  variables:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.envs }}
  envs:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.patch }}
  patch:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.publicSharing }}
  publicSharing:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $item.urlAuthorization }}
  urlAuthorization:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if $item.url }}
  url: {{ $item.url | quote }}
  {{- else if $item.grafanaCom }}
  grafanaCom:
    {{- toYaml $item.grafanaCom | nindent 4 }}
  {{- else if $item.configMapRef }}
  configMapRef:
    {{- toYaml $item.configMapRef | nindent 4 }}
  {{- else if $item.oci }}
  oci:
    {{- toYaml $item.oci | nindent 4 }}
  {{- else if $item.gzipJson }}
  gzipJson: {{ $item.gzipJson | quote }}
  {{- else if $item.jsonnet }}
  jsonnet: |-
{{ $item.jsonnet | trimSuffix "\n" | indent 4 }}
    {{- with $item.jsonnetLib }}
  jsonnetLib:
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- else if $item.json }}
  json: |-
{{ $item.json | trimSuffix "\n" | indent 4 }}
  {{- else if $fileJson }}
  json: |-
{{ $fileJson | trimSuffix "\n" | indent 4 }}
  {{- end }}
{{ end -}}
{{- end }}

{{/*
Render GrafanaDashboard resources for every dashboards/*.json file in a parent chart.
Invoke as: {{- include "custom.grafanaDashboards" . }}
*/}}
{{- define "custom.grafanaDashboards" -}}
{{- $root := . -}}
{{- $sub := index $root.Values "common-helpers" | default dict -}}
{{- $defaults := $sub.grafanaDashboard | default $root.Values.grafanaDashboard | default dict -}}
{{- range $path, $_ := $root.Files.Glob "dashboards/*.json" }}
  {{- $name := base $path | trimSuffix ".json" -}}
  {{- $rawItem := index $defaults $name -}}
  {{- $item := dict -}}
  {{- if and $rawItem (kindIs "map" $rawItem) }}
    {{- $item = $rawItem -}}
  {{- end }}
  {{- if not (include "custom.grafanaDashboard.hasExternalSource" $item) }}
    {{- $fileJson := $root.Files.Get $path -}}
    {{- include "custom.grafanaDashboard.render" (dict "root" $root "name" $name "defaults" $defaults "item" $item "fileJson" $fileJson) -}}
  {{- end }}
{{- end }}
{{- end }}
