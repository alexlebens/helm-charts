{{- define "cluster.init" -}}

{{- if eq .Values.mode "clone" }}
{{- with .Values.clone }}
initDB:
  clone:
    donorUrl: {{ required "clone donorUrl is required" .donorUrl }}
    rootUser: {{ .rootUser | default "root" }}
    secretKeyRef:
      name: {{ required "clone credentials is required" .exisitingCredentialsSecret }}
{{- end }}
{{- end }}

{{- if eq .Values.mode "recovery" }}
{{- with .Values.recovery }}
initDB:
  dump:
      {{- if .name }}
    name: {{ .name | quote }}
      {{- end }}
      {{- if .path }}
    path: {{ .path | quote }}
      {{- end }}
      {{- if .options }}
    options: {{ toYaml .options | nindent 8 }}
      {{- end }}
    storage:
      {{- if eq .type "s3" }}
      s3:
        prefix: {{ required "s3 prefix is required" .s3.prefix }}
        bucketName: {{ required "s3 bucketName is required" .s3.bucketName }}
        config: {{ required "s3 config is required" .s3.config }}
          {{- if .s3.profile }}
        profile: {{ .s3.profile }}
          {{- end }}
          {{- if .s3.endpoint }}
        endpoint: {{ .s3.endpoint }}
          {{- end }}
      {{- end }}
      {{- if eq .type "pvc" }}
      persistentVolumeClaim:
        {{ toYaml .persistentVolumeClaim | nindent 10}}
      {{- end }}
{{- end }}
{{- end }}

{{- end }}
