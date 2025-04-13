
resource "google_storage_bucket" "airflow_dags" {
  name                        = "${var.project_id}-airflow-dags"
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "airflow_logs" {
  name                        = "${var.project_id}-airflow-logs"
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "dag_access" {
  bucket = google_storage_bucket.airflow_dags.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.gke_sa_email}"
}

resource "google_storage_bucket_iam_member" "log_access" {
  bucket = google_storage_bucket.airflow_logs.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.gke_sa_email}"
}
