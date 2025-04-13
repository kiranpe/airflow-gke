
resource "google_dns_managed_zone" "internal_airflow" {
  name       = "internal-airflow-zone"
  dns_name   = "internal.example.com."
  visibility = "private"
  project    = var.project_id

  private_visibility_config {
    networks {
      network_url = var.vpc_self_link
    }
  }
}

resource "google_dns_record_set" "airflow_ui" {
  name         = "airflow.internal.example.com."
  type         = "A"
  ttl          = 300
  rrdatas      = [var.airflow_ilb_ip]
  managed_zone = google_dns_managed_zone.internal_airflow.name
}
