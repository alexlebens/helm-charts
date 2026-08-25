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
{{- define "custom.defaultOauthProxySecret" -}}
{{ .Release.Name }}-oauth-proxy
{{- end -}}

{{/*
Icon url
*/}}
{{- define "custom.iconUrl" -}}
{{ ((.Values.global).iconUrl) | default "https://cdn.jsdelivr.net/gh/selfhst/icons/webp/" }}
{{- end -}}
