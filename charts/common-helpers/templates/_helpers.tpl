{{/*
Common labels
*/}}
{{- define "custom.labels" -}}
{{ include "custom.selectorLabels" $ }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "custom.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}

{{/*
Domain
*/}}
{{- define "custom.domain" -}}
{{ ((.Values.global).domain) | default ".alexlebens.dev" }}
{{- end -}}

{{/*
Default Hostname
*/}}
{{- define "custom.defaultHostname" -}}
{{ .Release.Name }}{{ include "custom.domain" . }}
{{- end -}}

{{/*
Secrets
*/}}
{{- define "custom.defaultOidcSecret" -}}
{{ .Release.Name }}-oidc-secret
{{- end -}}

{{/*
Icon url
*/}}
{{- define "custom.iconUrl" -}}
{{ ((.Values.global).iconUrl) | default "https://cdn.jsdelivr.net/gh/selfhst/icons/webp/" }}
{{- end -}}

{{/*
Dynamic NFS Storage Name Generator
Usage:
  1. Default single NFS:
     {{ include "custom.storageNfsName" . }}
     Output: <release name>-nfs-storage

  2. Multiple / Suffix NFS:
     {{ include "custom.storageNfsName" (list . "pictures-collection") }}
     Output: <release name>-pictures-collection-nfs-storage
*/}}
{{- define "custom.storageNfsName" -}}
{{- if kindIs "slice" . -}}
  {{- $root := index . 0 -}}
  {{- $suffix := index . 1 -}}
  {{- printf "%s-%s-nfs-storage" $root.Release.Name $suffix -}}
{{- else -}}
  {{- printf "%s-nfs-storage" .Release.Name -}}
{{- end -}}
{{- end -}}
