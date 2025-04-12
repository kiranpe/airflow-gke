data "google_client_config" "default" {}

data "google_compute_network" "vpc" {
  name = "producer-vpc"
}