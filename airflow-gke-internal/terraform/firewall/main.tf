
resource "google_compute_firewall" "airflow_internal_web" {
  name    = "allow-airflow-web-internal"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["10.0.0.0/8"]
  target_tags   = ["airflow-nodes"]
}
