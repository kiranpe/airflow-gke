
# module "vpc" {
#   source       = "./vpc"
#   project_id   = var.project_id
#   region       = var.region
#   network_name = "airflow-vpc"
#   subnets = [
#     {
#       name          = "airflow-subnet"
#       ip_cidr_range = "10.10.0.0/16"
#       region        = var.region
#     }
#   ]
#   enable_nat_gateway = true
# }

# module "nat" {
#   source  = "./vpc/nat"
#   region  = var.region
#   network = module.vpc.vpc_network_id
# }

module "iam" {
  source     = "./iam"
  project_id = var.project_id
}

module "gke_dev" {
  source                         = "./gke"
  project_id                     = var.project_id
  region                         = var.region
  network                        = data.google_compute_network.vpc.id
  subnetwork                     = "gke-node-subnet"
  pods_range                     = "10.10.0.0/20"
  services_range                 = "10.10.30.0/24"
  gke_node_sa                    = module.iam.airflow_gke_sa_email
  use_preemptible_nodes          = true
  node_pool_size                 = 2
  authorized_cidr_blocks         = "10.2.0.0/24"
  enable_gcsfuse_csi_driver      = true
  env                            = "dev"
}

module "cloudsql" {
  source      = "./sql"
  project_id  = var.project_id
  region      = var.region
  vpc_id      = data.google_compute_network.vpc.id
  db_password = ""
}

module "gcs" {
  source       = "./gcs"
  project_id   = var.project_id
  region       = var.region
  gke_sa_email = module.iam.airflow_gke_sa_email
}

module "firewall" {
  source  = "./firewall"
  network = data.google_compute_network.vpc.id
}

# module "dns" {
#   source         = "./dns"
#   project_id     = var.project_id
#   vpc_self_link  = module.vpc.vpc_network_id
#   airflow_ilb_ip = var.airflow_ilb_ip
# }

# module "monitoring" {
#   source = "./monitoring"
# }

# module "gke_qa" {
#   source                         = "./gke"
#   project_id                     = var.project_id
#   region                         = var.region
#   network                        = module.vpc.vpc_network_id
#   subnetwork                     = "airflow-subnet"
#   pods_range                     = "airflow-pods-qa"
#   services_range                 = "airflow-services-qa"
#   gke_node_sa                    = module.iam.airflow_gke_sa_email
#   use_preemptible_nodes          = true
#   node_pool_size                 = 2
#   authorized_cidr_blocks         = ["YOUR_VPN_IP/32"]
#   enable_gcsfuse_csi_driver      = true
#   env                            = "qa"
# }

# module "gke_stage" {
#   source                         = "./gke"
#   project_id                     = var.project_id
#   region                         = var.region
#   network                        = module.vpc.vpc_network_id
#   subnetwork                     = "airflow-subnet"
#   pods_range                     = "airflow-pods-stage"
#   services_range                 = "airflow-services-stage"
#   gke_node_sa                    = module.iam.airflow_gke_sa_email
#   use_preemptible_nodes          = false
#   node_pool_size                 = 3
#   authorized_cidr_blocks         = ["YOUR_VPN_IP/32"]
#   enable_gcsfuse_csi_driver      = true
#   env                            = "stage"
# }

# module "gke_prod" {
#   source                         = "./gke"
#   project_id                     = var.project_id
#   region                         = var.region
#   network                        = module.vpc.vpc_network_id
#   subnetwork                     = "airflow-subnet"
#   pods_range                     = "airflow-pods-prod"
#   services_range                 = "airflow-services-prod"
#   gke_node_sa                    = module.iam.airflow_gke_sa_email
#   use_preemptible_nodes          = false
#   node_pool_size                 = 4
#   authorized_cidr_blocks         = ["YOUR_VPN_IP/32"]
#   enable_gcsfuse_csi_driver      = true
#   env                            = "prod"
# }
