
{{- define "quantum-wallet-api.fullname" -}}
{{- include "quantum-wallet-api.name" . -}}
{{- end -}}

{{- define "quantum-wallet-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "quantum-wallet-api.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "quantum-wallet-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: Helm
{{- end -}}

{{- define "quantum-wallet-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quantum-wallet-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
