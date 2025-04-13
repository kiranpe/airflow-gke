resource "google_project_iam_member" "workload_identity_user" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${var.project_id}.svc.id.goog[airflow/airflow]"

  depends_on = [google_container_cluster.gke_airflow_cluster]
}