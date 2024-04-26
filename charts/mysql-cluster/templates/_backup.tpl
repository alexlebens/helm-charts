{{- define "cluster.backup" -}}

{{- if and .Values.backup.enabled .Values.backup.profiles }}
backupProfiles:
{{- $isDumpInstance := false }}
{{- $isSnapshot := false }}
{{- range $_, $profile := .Values.backup.profiles }}
  - name: {{ $profile.name | quote }}
      {{- if hasKey $profile "podAnnotations" }}
    podAnnotations:
      {{ toYaml $profile.podAnnotations | nindent 6 }}
      {{- end }}
      {{- if hasKey $profile "podLabels" }}
    podLabels:
      {{ toYaml $profile.podLabels | nindent 6 }}
      {{- end }}

    {{- $isDumpInstance = hasKey $profile "dumpInstance" }}
    {{- $isSnapshot = hasKey $profile "snapshot" }}
    {{- if or $isDumpInstance $isSnapshot }}

      {{- $backupProfile := ternary $profile.dumpInstance $profile.snapshot $isDumpInstance }}
      {{- if $isDumpInstance }}
    dumpInstance:
      {{- else if $isSnapshot }}
    snapshot:
      {{- else }}
      {{- fail "Unsupported or unspecified backup type, must be either snapshot or dumpInstance" }}
      {{ end }}

      {{- if not (hasKey $backupProfile "storage") }}
      {{- fail "backup profile $profile.name has no storage section" }}
      {{- else if hasKey $backupProfile.storage "s3" }}
      storage:
        s3:
            {{- if $backupProfile.storage.s3.prefix }}
          prefix: {{ $backupProfile.storage.s3.prefix }}
            {{- end }}
          bucketName: {{ required "bucketName is required" $backupProfile.storage.s3.bucketName }}
          config: {{ required "config is required" $backupProfile.storage.s3.config }}
            {{- if $backupProfile.storage.s3.profile }}
          profile: {{ $backupProfile.storage.s3.profile }}
            {{- end }}
            {{- if $backupProfile.storage.s3.endpoint }}
          endpoint: {{ $backupProfile.storage.s3.endpoint }}
            {{- end }}
      {{- else if hasKey $backupProfile.storage "persistentVolumeClaim" }}
      storage:
        persistentVolumeClaim: {{ toYaml $backupProfile.storage.persistentVolumeClaim | nindent 12}}
      {{- else -}}
      {{- fail "Backup profile $profile.name has empty storage section - neither s3 nor persistentVolumeClaim defined" }}
      {{- end -}}

    {{- end }}
{{- end }}
{{- end }}

{{- if .Values.backupSchedules }}
backupSchedules:
{{- range $_, $schedule := .Values.backup.schedules }}
  - name: {{ $schedule.name | quote }}
    enabled: {{ $schedule.enabled }}
    schedule: {{ quote $schedule.schedule }}
      {{- if ($schedule).timeZone }}
    timeZone: {{ quote $schedule.timeZone }}
      {{- end }}
    deleteBackupData: {{ $schedule.deleteBackupData }}
    backupProfileName: {{ $schedule.backupProfileName }}
{{- end }}
{{- end }}

{{- end }}