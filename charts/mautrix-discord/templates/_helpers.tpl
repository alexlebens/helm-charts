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
