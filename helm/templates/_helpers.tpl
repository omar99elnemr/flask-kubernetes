{{/*
Custom labels template (place: iti, name: omar-elnemr)
*/}}
{{- define "flask-app.customLabels" -}}
place: {{ .Values.labels.place }}
name: {{ .Values.labels.name }}
{{- end }}

{{/*
Deployment name: <release-name>-deployment
*/}}
{{- define "flask-app.deploymentName" -}}
{{- printf "%s-deployment" .Release.Name }}
{{- end }}

{{/*
Service name: <release-name>-service
*/}}
{{- define "flask-app.serviceName" -}}
{{- printf "%s-service" .Release.Name }}
{{- end }}
