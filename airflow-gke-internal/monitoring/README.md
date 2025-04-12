# Monitoring Stack for Airflow on GKE

You can integrate monitoring for your Airflow environment using:

### 1. Prometheus & Grafana
- Install [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- Add Prometheus annotations to Airflow Helm values if needed

### 2. Google Cloud Monitoring
- GKE can be configured to export logs and metrics to Cloud Monitoring
- Ensure Operations Suite is enabled via:
  ```
  resource "google_container_cluster" "airflow" {
    ...
    monitoring_service = "monitoring.googleapis.com/kubernetes"
    logging_service    = "logging.googleapis.com/kubernetes"
  }
  ```

### 3. Alerting
- Set up Cloud Monitoring alert policies for:
  - Task failures
  - Scheduler downtime
  - Webserver unavailability
