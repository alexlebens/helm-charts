{{/*
Helper for secret name
*/}}
{{- define "hookshot.secretName" -}}
{{- if .Values.hookshot.existingSecret }}
{{- printf "%s" .Values.hookshot.existingSecret -}}
{{- else }}
{{- printf "matrix-hookshot-config-secret" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Helper for registration secret name
*/}}
{{- define "hookshot.registrationSecretName" -}}
{{- if .Values.hookshot.existingRegistrationSecret }}
{{- printf "%s" .Values.hookshot.existingRegistrationSecret -}}
{{- else }}
{{- printf "matrix-hookshot-registration-secret" }}
{{- end }}
{{- end }}

{{/*
Helper for passkey secret name
*/}}
{{- define "hookshot.passkeySecretName" -}}
{{- if .Values.hookshot.existingPasskeySecret }}
{{- printf "%s" .Values.hookshot.existingPasskeySecret -}}
{{- else }}
{{- printf "matrix-hookshot-passkey-secret" }}
{{- end }}
{{- end }}

{{/*
Helper for passkey file name
*/}}
{{- define "hookshot.passFile" -}}
{{- if .Values.hookshot.config.passFile }}
{{- printf "%s" .Values.hookshot.config.passFile -}}
{{- else }}
{{- printf "passkey.pem" }}
{{- end }}
{{- end }}
