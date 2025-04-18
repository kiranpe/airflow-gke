
resource "google_service_account" "airflow_gke" {
  account_id   = "airflow-gke-sa"
  display_name = "Airflow GKE SA"
  project      = var.project_id
}

resource "google_project_iam_member" "gcs_access" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.airflow_gke.email}"
}

resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.airflow_gke.email}"
}
