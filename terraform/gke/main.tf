resource "google_container_cluster" "gke_airflow_cluster" {
  provider = google-beta
  name     = "airflow-cluster-${var.env}"
  location = var.zone
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range
    services_secondary_range_name = var.services_range
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.2.0.0/24"
      display_name = "authorized"
    }
  }

  datapath_provider = "ADVANCED_DATAPATH"

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

resource "google_container_node_pool" "gke_airflow_node_pool" {
  name     = "airflow-node-pool"
  cluster  = google_container_cluster.gke_airflow_cluster.name
  location = var.zone
  project  = var.project_id

  node_count = 3

  node_config {
    machine_type    = "e2-standard-2"
    disk_size_gb    = 50
    disk_type       = "pd-standard"
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = var.gke_node_sa
    tags            = ["airflow-nodes"]
  }

  max_pods_per_node = 25

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  network_config {
    enable_private_nodes = true
  }
}
