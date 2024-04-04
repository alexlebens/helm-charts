{{/*
Helper for secret name
*/}}
{{- define "mautrix-discord.secretName" -}}
{{- if .Values.mautrixDiscord.existingSecret }}
{{- printf "%s" .Values.mautrixDiscord.existingSecret -}}
{{- else }}
{{- printf "mautrix-discord-config-secret" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Helper for registration secret name
*/}}
{{- define "mautrix-discord.registrationSecretName" -}}
{{- if .Values.mautrixDiscord.existingRegistrationSecret }}
{{- printf "%s" .Values.mautrixDiscord.existingRegistrationSecret -}}
{{- else }}
{{- printf "mautrix-discord-registration-secret" }}
{{- end }}
{{- end }}

{{/*
Generate registration.yaml if not from existing secret
*/}}
{{- define "mautrix-discord.registration-yaml" -}}
id: {{ .Values.mautrixDiscord.config.appservice.id | quote }}
as_token: {{ .Values.mautrixDiscord.config.appservice.as_token | quote }}
hs_token: {{ .Values.mautrixDiscord.config.appservice.hs_token | quote }}
namespaces:
  users:
    - regex: {{ printf "^@discordbot:%s$" (replace "." "\\." .Values.mautrixDiscord.config.homeserver.domain) }}
      exclusive: true
    - regex: {{ printf "^@%s:%s$" (replace "{{.}}" ".*" (tpl .Values.mautrixDiscord.config.bridge.username_template .)) (replace "." "\\." .Values.mautrixDiscord.config.homeserver.domain) }}
      exclusive: true
url: {{ .Values.mautrixDiscord.config.appservice.address | quote }}
sender_localpart: {{ .Values.mautrixDiscord.registration.sender_localpart | quote }}
rate_limited: {{ .Values.mautrixDiscord.registration.rate_limited }}
de.sorunome.msc2409.push_ephemeral: true
push_ephemeral: true
{{- end -}}
