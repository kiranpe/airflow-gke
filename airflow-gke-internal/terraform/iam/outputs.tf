
output "airflow_gke_sa_email" {
  value = google_service_account.airflow_gke.email
}
