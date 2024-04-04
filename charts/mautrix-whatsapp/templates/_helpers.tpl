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

{{/*
Helper for registration secret name
*/}}
{{- define "mautrix-whatsapp.registrationSecretName" -}}
{{- if .Values.mautrixWhatsapp.existingRegistrationSecret }}
{{- printf "%s" .Values.mautrixWhatsapp.existingRegistrationSecret -}}
{{- else }}
{{- printf "mautrix-whatsapp-registration-secret" }}
{{- end }}
{{- end }}

{{/*
Generate registration.yaml if not from existing secret
*/}}
{{- define "mautrix-whatsapp.registration-yaml" -}}
id: {{ .Values.mautrixWhatsapp.config.appservice.id | quote }}
as_token: {{ .Values.mautrixWhatsapp.config.appservice.as_token | quote }}
hs_token: {{ .Values.mautrixWhatsapp.config.appservice.hs_token | quote }}
namespaces:
  users:
    - regex: {{ printf "^@whatsappbot:%s$" (replace "." "\\." .Values.mautrixWhatsapp.config.homeserver.domain) }}
      exclusive: true
    - regex: {{ printf "^@%s:%s$" (replace "{{.}}" ".*" (tpl .Values.mautrixWhatsapp.config.bridge.username_template .)) (replace "." "\\." .Values.mautrixWhatsapp.config.homeserver.domain) }}
      exclusive: true
url: {{ .Values.mautrixWhatsapp.config.appservice.address | quote }}
sender_localpart: {{ .Values.mautrixWhatsapp.registration.sender_localpart | quote }}
rate_limited: {{ .Values.mautrixWhatsapp.registration.rate_limited }}
de.sorunome.msc2409.push_ephemeral: true
push_ephemeral: true
{{- end -}}
