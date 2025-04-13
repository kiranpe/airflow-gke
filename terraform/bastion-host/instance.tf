resource "google_compute_instance" "bastion_vm" {
  name         = "bastion-host"
  project      = "mlops-448320"
  zone         = "us-east1-d"
  machine_type = "e2-micro"

  tags = ["allow-bastion-ssh"]

  labels = {
    goog-ec-src = "vm_add-gcloud"
  }

  metadata = {
    block-project-ssh-keys = "true"
  }

  boot_disk {
    auto_delete = true
    device_name = "bastion-vm"

    initialize_params {
      image  = "projects/debian-cloud/global/images/debian-12-bookworm-v20250212"
      size   = 10
      type   = "pd-balanced"
    }
  }

  network_interface {
    subnetwork   = "airflow-bastion-host-subnet"
    stack_type   = "IPV4_ONLY"
    access_config {
      // no-address: omit this block if no public IP
    }
  }

  service_account {
    email  = "mlops-sa@mlops-448320.iam.gserviceaccount.com"  # or put actual email here
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }
}