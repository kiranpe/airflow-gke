# Airflow on GKE (Internal) - Production-Ready Deployment

This project deploys a secure, internal-only Apache Airflow environment on Google Kubernetes Engine (GKE), using GCS for DAG/log storage and Cloud SQL for metadata, similar to Cloud Composer.

## Features

- **Executor**: KubernetesExecutor (Composer-like task isolation and scaling)
- **GKE**: Private cluster with Workload Identity
- **Cloud SQL**: PostgreSQL with private IP
- **GCS**: For DAGs and logs, mounted via GCSFuse
- **Internal Access**: Web UI exposed via internal load balancer only
- **IAM & Security**: Least privilege access for GCS and Cloud SQL via Workload Identity
- **Cloud DNS**: Internal hostname resolution for Airflow UI
- **Modular Terraform**: Reusable infrastructure components
- **Helm**: Manages Airflow deployment on GKE
- **Scripted Deployment**: `deploy.sh` automates provisioning and Helm setup

---

## Directory Structure

```
airflow-gke-internal/
├── deploy.sh
├── helm/
│   └── airflow-values.yaml
├── terraform/
│   ├── main.tf
│   ├── gke/
│   ├── sql/
│   ├── vpc/
│   ├── gcs/
│   ├── dns/
│   ├── firewall/
│   └── iam/
```

---

## Requirements

- GCP Project
- Terraform CLI
- Helm CLI
- gcloud CLI (authenticated)
- GKE API, IAM, Cloud SQL, DNS, and Compute API enabled

---

## Setup Instructions

### 1. Configure Variables

Edit `terraform/terraform.tfvars` or pass variables via CLI:
- `project_id`
- `region`
- `zone`
- `db_password`
- `airflow_ilb_ip` (internal static IP to reserve for Airflow UI)

### 2. Deploy Infrastructure

```bash
cd airflow-gke-internal
./deploy.sh
```

This will:
- Deploy GKE, VPC, Cloud SQL, GCS, and supporting resources
- Deploy Airflow via Helm with KubernetesExecutor
- Mount DAGs and logs from GCS
- Expose Airflow web UI internally at `airflow.internal.example.com`

---

## Notes

- DAGs are expected in the GCS bucket `${project_id}-airflow-dags`
- Airflow web UI runs internally and is **not exposed to the public internet**
- You can access the UI over VPN, Cloud Interconnect, or from another GCP project with VPC peering

---

## Monitoring & Extensions (Optional)

You can extend this setup to include:
- Prometheus + Grafana for metrics
- Google Cloud Monitoring integration
- OAuth2/IAP for browser-based secure access
- CI/CD pipeline to sync DAGs to GCS

---

## License

MIT
