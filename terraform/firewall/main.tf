
resource "google_compute_firewall" "allow_internal_airflow" {
  name    = "allow-internal-airflow"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "8080"]
  }

  source_ranges = [
    "10.10.0.0/20", # Pod IP range
    "10.10.30.0/24" # Service IP range
  ]

  target_tags = ["airflow-nodes"]
  direction   = "INGRESS"
  priority    = 1000
  description = "Allow internal traffic to Airflow services"
}

resource "google_compute_firewall" "allow_airflow_egress" {
  name    = "allow-airflow-egress"
  network = var.network

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
  target_tags        = ["airflow-nodes"]
  priority           = 1000
  description        = "Allow egress to public internet for Airflow nodes"
}
