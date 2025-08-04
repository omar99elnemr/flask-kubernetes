#!/bin/bash
set -e

echo "Installing Prometheus Stack with Cost-Optimized Settings..."

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=3d \
  --set prometheus.prometheusSpec.scrapeInterval=30s \
  --set prometheus.prometheusSpec.evaluationInterval=30s \
  --set prometheus.prometheusSpec.resources.requests.memory=300Mi \
  --set prometheus.prometheusSpec.resources.requests.cpu=100m \
  --set prometheus.prometheusSpec.resources.limits.memory=600Mi \
  --set prometheus.prometheusSpec.resources.limits.cpu=300m \
  --set grafana.resources.requests.memory=128Mi \
  --set grafana.resources.requests.cpu=50m \
  --set grafana.resources.limits.memory=256Mi \
  --set grafana.resources.limits.cpu=150m \
  --set alertmanager.enabled=false \
  --set nodeExporter.resources.requests.memory=50Mi \
  --set nodeExporter.resources.requests.cpu=25m \
  --set nodeExporter.resources.limits.memory=100Mi \
  --set nodeExporter.resources.limits.cpu=50m \
  --wait --timeout=10m

echo "Prometheus Stack installation completed successfully!"

echo "Exposing Prometheus and Grafana services..."

# Expose Prometheus
kubectl patch service kube-prometheus-stack-prometheus -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'

# Expose Grafana
kubectl patch service kube-prometheus-stack-grafana -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'

echo "Services exposed as LoadBalancers!"