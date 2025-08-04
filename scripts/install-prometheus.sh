#!/bin/bash
set -e

echo "Installing Prometheus Stack Settings..."

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=3d \
  --set prometheus.prometheusSpec.scrapeInterval=30s \
  --set prometheus.prometheusSpec.evaluationInterval=30s \
  --set alertmanager.enabled=false \
  --wait

echo "Prometheus Stack installation completed successfully!"

echo "Exposing Prometheus and Grafana services..."

# Expose Prometheus
kubectl patch service kube-prometheus-stack-prometheus -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'

# Expose Grafana on port 3000
kubectl patch service kube-prometheus-stack-grafana -n monitoring -p '{"spec":{"type":"LoadBalancer","ports":[{"name":"service","port":3000,"protocol":"TCP","targetPort":3000}]}}'

echo "Services exposed as LoadBalancers!"