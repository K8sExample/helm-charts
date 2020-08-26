{{- define "container" -}}
- name: {{.Values.name | default (include "stateless.name" .) }}
  {{- if .Values.command }}
  command:
    {{- toYaml .Values.command | nindent 12 -}}
  {{- end }}
  {{- if .Values.env }}
  env:
    {{- range $key, $value :=  .Values.env }}
    - name: {{ $key }}
      value: {{ $value | quote }}
    {{- end }}
  {{- end }}
  {{- if .Values.args }}
  args:
  {{- toYaml .Values.args | nindent 12 -}}
  {{- end }}

  image: "{{ .Values.image.repository | default "docker.io" }}/{{ .Values.image.folder | default (include "stateless.name" .) }}/{{ .Values.image.name | default (include "stateless.name" .) }}:{{ .Values.image.tag }}"
  imagePullPolicy: IfNotPresent
  ports:
    - name: http
      containerPort: {{ .Values.port | default 8080 }}
      protocol: TCP

  livenessProbe:
    {{- if .Values.healthchecksCommand }}
    exec:
      command: {{- toYaml .Values.healthchecksCommand | nindent 14 -}}
    {{- else }}
    httpGet:
      path: {{ .Values.healthchecksPath | default "/healthcheck"}}
      port: http
    {{- end }}
    initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds | default 20 }}
    periodSeconds: {{ .Values.livenessProbe.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds | default 2 }}
    failureThreshold: {{ .Values.livenessProbe.failureThreshold | default 5 }}
  readinessProbe:
    {{- if .Values.healthchecksCommand }}
    exec:
      command: {{- toYaml .Values.healthchecksCommand | nindent 14 -}}
    {{- else }}
    httpGet:
      path: {{ .Values.healthchecksPath | default "/healthcheck"}}
      port: http
    {{- end }}
    initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds | default 1 }}
    periodSeconds: {{ .Values.readinessProbe.periodSeconds | default 5 }}
    timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds | default 2 }}
    successThreshold: {{ .Values.readinessProbe.successThreshold | default 1 }}
    failureThreshold: {{ .Values.readinessProbe.failureThreshold | default 1 }}

  resources:
    limits:
      cpu: {{ .Values.limits.cpu | default "500m" }}
      memory: {{ .Values.limits.memory | default "1Gi" }}
    requests:
      cpu: {{ .Values.requests.cpu | default "500m" }}
      memory: {{ .Values.requests.memory | default "1Gi" }}

  lifecycle:
    # This "sleep" preStop hook delays the Pod shutdown until after it's endpoint is removed (so there isn't any income traffic)
    preStop:
      exec:
        command:
          - /bin/sleep
          - "{{ .Values.preStopSleep | default 5 }}"
{{- end }}
