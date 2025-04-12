
output "airflow_dags_bucket" {
  value = google_storage_bucket.airflow_dags.name
}

output "airflow_logs_bucket" {
  value = google_storage_bucket.airflow_logs.name
}
