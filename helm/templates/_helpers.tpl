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

{{/*
Prometheus deployment name: <release-name>-prometheus-deployment
*/}}
{{- define "flask-app.prometheusDeploymentName" -}}
{{- printf "%s-prometheus-deployment" .Release.Name }}
{{- end }}

{{/*
Prometheus service name: <release-name>-prometheus-service
*/}}
{{- define "flask-app.prometheusServiceName" -}}
{{- printf "%s-prometheus-service" .Release.Name }}
{{- end }}

{{/*
Prometheus config name: <release-name>-prometheus-config
*/}}
{{- define "flask-app.prometheusConfigName" -}}
{{- printf "%s-prometheus-config" .Release.Name }}
{{- end }}

{{/*
Grafana deployment name: <release-name>-grafana-deployment
*/}}
{{- define "flask-app.grafanaDeploymentName" -}}
{{- printf "%s-grafana-deployment" .Release.Name }}
{{- end }}

{{/*
Grafana service name: <release-name>-grafana-service
*/}}
{{- define "flask-app.grafanaServiceName" -}}
{{- printf "%s-grafana-service" .Release.Name }}
{{- end }}

{{/*
Grafana datasource config name: <release-name>-grafana-datasource-config
*/}}
{{- define "flask-app.grafanaDatasourceConfigName" -}}
{{- printf "%s-grafana-datasource-config" .Release.Name }}
{{- end }}

{{/*
Grafana dashboard provider config name: <release-name>-grafana-dashboard-provider-config
*/}}
{{- define "flask-app.grafanaDashboardProviderConfigName" -}}
{{- printf "%s-grafana-dashboard-provider-config" .Release.Name }}
{{- end }}

{{/*
Grafana dashboard config name: <release-name>-grafana-dashboard-config
*/}}
{{- define "flask-app.grafanaDashboardConfigName" -}}
{{- printf "%s-grafana-dashboard-config" .Release.Name }}
{{- end }}
