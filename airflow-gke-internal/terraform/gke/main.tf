
resource "google_container_cluster" "airflow" {
  name     = "airflow-cluster-${var.env}"
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range
    services_secondary_range_name = var.services_range
  }

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false
    cidr_blocks {
      cidr_block   = var.authorized_cidr_blocks
      display_name = "authorized-network"
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  addons_config {
    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.airflow.name
  location   = var.region
  project    = var.project_id

  node_config {
    machine_type = "e2-standard-4"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    tags         = ["airflow-nodes"]
    service_account = var.gke_node_sa
    preemptible     = var.use_preemptible_nodes
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  initial_node_count = var.node_pool_size
  node_count         = var.node_pool_size
}
