#!/bin/bash

set -e

echo "Initializing Terraform..."
cd terraform
terraform init

echo "Planning infrastructure..."
terraform plan -out=tfplan

echo "Applying infrastructure..."
terraform apply tfplan

echo "Waiting for GKE cluster to be ready..."
gcloud container clusters get-credentials airflow-cluster --region $(terraform output -raw region)

echo "Installing Helm chart for Airflow..."
cd ../helm
helm repo add apache-airflow https://airflow.apache.org
helm repo update

helm upgrade --install airflow apache-airflow/airflow \
  --namespace airflow \
  --create-namespace \
  -f dev-values.yaml

echo "Deployment complete!"
