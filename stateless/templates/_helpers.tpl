{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "stateless.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stateless.fullname" -}}
{{- default .Chart.Name .Values.nameOverride -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "stateless.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stateless.labels" -}}
helm.sh/chart: {{ include "stateless.chart" . }}
{{ include "stateless.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stateless.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stateless.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "stateless.serviceAccountName" -}}
{{- default (include "stateless.fullname" .) .Values.serviceAccount.name }}
{{- end }}
