#!/bin/bash
set -e

echo "Installing Prometheus Stack Settings..."

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=3d \
  --set prometheus.prometheusSpec.scrapeInterval=30s \
  --set prometheus.prometheusSpec.evaluationInterval=30s \
  --set alertmanager.enabled=false \
  --wait --timeout=10m

echo "Prometheus Stack installation completed successfully!"

echo "Exposing Prometheus and Grafana services..."

# Expose Prometheus
kubectl patch service kube-prometheus-stack-prometheus -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'

# Expose Grafana
kubectl patch service kube-prometheus-stack-grafana -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'

echo "Services exposed as LoadBalancers!"