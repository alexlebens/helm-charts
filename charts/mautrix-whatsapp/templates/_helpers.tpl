{{/*
Helper for secret name
*/}}
{{- define "mautrix-whatsapp.secretName" -}}
{{- if .Values.mautrixWhatsapp.existingSecret }}
{{- printf "%s" .Values.mautrixWhatsapp.existingSecret -}}
{{- else }}
{{- printf "mautrix-whatsapp-config-secret" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
