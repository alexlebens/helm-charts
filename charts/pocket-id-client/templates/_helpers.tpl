{{/*
Generate the resource name
*/}}
{{- define "pocketIdClient.name" -}}
  {{- if .Values.name -}}
    {{- .Values.name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label
*/}}
{{- define "pocketIdClient.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pocketIdClient.labels" -}}
helm.sh/chart: {{ include "pocketIdClient.chart" $ }}
{{ include "pocketIdClient.selectorLabels" $ }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "pocketIdClient.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end -}}

{{/*
Generate a deterministic UUID from release name + namespace.
Produces an uppercase UUID in format XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
by taking the sha256 of "<releaseName>/<namespace>" and formatting it.
*/}}
{{- define "pocketIdClient.generateUUID" -}}
  {{- $hash := printf "%s/%s" .Release.Name .Release.Namespace | sha256sum -}}
  {{- $uuid := printf "%s-%s-%s-%s-%s" (substr 0 8 $hash) (substr 8 12 $hash) (substr 12 16 $hash) (substr 16 20 $hash) (substr 20 32 $hash) -}}
  {{- upper $uuid -}}
{{- end -}}

{{/*
Resolve the client ID: explicit value or generated UUID
*/}}
{{- define "pocketIdClient.clientID" -}}
  {{- if .Values.client.clientID -}}
    {{- .Values.client.clientID -}}
  {{- else -}}
    {{- include "pocketIdClient.generateUUID" . -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the Kubernetes secret name based on mode.
Priority: explicit secretName > mode default from common-helpers
*/}}
{{- define "pocketIdClient.secretName" -}}
  {{- if .Values.externalSecret.secretName -}}
    {{- .Values.externalSecret.secretName -}}
  {{- else if eq .Values.mode "oauth" -}}
    {{- include "custom.defaultOauthProxySecret" . -}}
  {{- else -}}
    {{- include "custom.defaultOidcSecret" . -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the clientSecretRef name on the CRD.
Priority: explicit clientSecretRefName > secretName (same as ExternalSecret target)
*/}}
{{- define "pocketIdClient.clientSecretRefName" -}}
  {{- if .Values.client.clientSecretRefName -}}
    {{- .Values.client.clientSecretRefName -}}
  {{- else -}}
    {{- include "pocketIdClient.secretName" . -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the clientSecretRef key on the CRD based on mode.
Priority: explicit clientSecretRefKey > mode default
*/}}
{{- define "pocketIdClient.clientSecretRefKey" -}}
  {{- if .Values.client.clientSecretRefKey -}}
    {{- .Values.client.clientSecretRefKey -}}
  {{- else if eq .Values.mode "oauth" -}}
    OAUTH2_PROXY_CLIENT_SECRET
  {{- else -}}
    clientSecret
  {{- end -}}
{{- end -}}

{{/*
Resolve the application identifier (used for default URL, secret path, and logo).
Priority: .Values.name > .Release.Namespace (if not "default") > .Release.Name
*/}}
{{- define "pocketIdClient.appIdentifier" -}}
  {{- if .Values.name -}}
    {{- .Values.name -}}
  {{- else if and .Release.Namespace (ne .Release.Namespace "default") -}}
    {{- .Release.Namespace -}}
  {{- else -}}
    {{- .Release.Name -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the display name for Pocket ID
Priority: explicit client.displayName > release name in title case
*/}}
{{- define "pocketIdClient.displayName" -}}
  {{- if .Values.client.displayName -}}
    {{- .Values.client.displayName -}}
  {{- else -}}
    {{- include "pocketIdClient.name" . | replace "-" " " | title -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the launch URL.
Priority: explicit client.launchUrl > https://<appIdentifier><custom.domain>
*/}}
{{- define "pocketIdClient.launchUrl" -}}
  {{- if .Values.client.launchUrl -}}
    {{- .Values.client.launchUrl -}}
  {{- else -}}
    {{- printf "https://%s%s" (include "pocketIdClient.appIdentifier" .) (include "custom.domain" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the callback URLs.
In oauth mode: defaults to [<launchUrl>/oauth2/callback] if callbackUrls is empty.
In oidc mode: returns .Values.client.callbackUrls (fails if empty).
*/}}
{{- define "pocketIdClient.callbackUrls" -}}
  {{- if .Values.client.callbackUrls -}}
    {{- toYaml .Values.client.callbackUrls -}}
  {{- else if eq .Values.mode "oauth" -}}
    {{- printf "- %s/oauth2/callback" (include "pocketIdClient.launchUrl" .) -}}
  {{- else -}}
    {{- fail "client.callbackUrls must be specified when mode is oidc" -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the light mode logo URL.
Priority: explicit logo.logoUrl > selfhstLogoName webp > fallback <appIdentifier>.webp
*/}}
{{- define "pocketIdClient.logoUrl" -}}
  {{- if .Values.client.logo.logoUrl -}}
    {{- .Values.client.logo.logoUrl -}}
  {{- else if .Values.client.logo.selfhstLogoName -}}
    {{- printf "%s%s.webp" (include "custom.iconUrl" .) .Values.client.logo.selfhstLogoName -}}
  {{- else -}}
    {{- printf "%s%s.webp" (include "custom.iconUrl" .) (include "pocketIdClient.appIdentifier" .) -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the dark mode logo URL (optional).
Priority: explicit logo.darkLogoUrl > (if selfhstDarkLogo: true) <iconName>-light.webp
*/}}
{{- define "pocketIdClient.darkLogoUrl" -}}
  {{- if .Values.client.logo.darkLogoUrl -}}
    {{- .Values.client.logo.darkLogoUrl -}}
  {{- else if .Values.client.logo.selfhstDarkLogo -}}
    {{- $iconName := .Values.client.logo.selfhstLogoName | default (include "pocketIdClient.appIdentifier" .) -}}
    {{- printf "%s%s-light.webp" (include "custom.iconUrl" .) $iconName -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the OpenBao secret path.
Priority: explicit secretPath > secretPathPrefix/<appIdentifier>
*/}}
{{- define "pocketIdClient.secretPath" -}}
  {{- if .Values.externalSecret.secretPath -}}
    {{- .Values.externalSecret.secretPath -}}
  {{- else if .Values.externalSecret.secretPathPrefix -}}
    {{- printf "%s/%s" .Values.externalSecret.secretPathPrefix (include "pocketIdClient.appIdentifier" .) -}}
  {{- else -}}
    {{- fail "Either externalSecret.secretPath or externalSecret.secretPathPrefix must be set when externalSecret is enabled" -}}
  {{- end -}}
{{- end -}}

{{/*
Resolve the ExternalSecret clientId key name (oidc mode)
*/}}
{{- define "pocketIdClient.clientIdKey" -}}
  {{- if .Values.externalSecret.clientIdKey -}}
    {{- .Values.externalSecret.clientIdKey -}}
  {{- else -}}
    clientId
  {{- end -}}
{{- end -}}

{{/*
Resolve the ExternalSecret clientSecret key name (oidc mode)
*/}}
{{- define "pocketIdClient.clientSecretKey" -}}
  {{- if .Values.externalSecret.clientSecretKey -}}
    {{- .Values.externalSecret.clientSecretKey -}}
  {{- else -}}
    clientSecret
  {{- end -}}
{{- end -}}

{{/*
Resolve the seed Job service account name
*/}}
{{- define "pocketIdClient.seedServiceAccountName" -}}
  {{- if .Values.seedJob.serviceAccount.name -}}
    {{- .Values.seedJob.serviceAccount.name -}}
  {{- else -}}
    pocket-id-seed
  {{- end -}}
{{- end -}}
