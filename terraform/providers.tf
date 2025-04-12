provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = module.gke_prod.kubernetes_host
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_prod.kubernetes_ca)
}

provider "helm" {
  kubernetes {
    host                   = module.gke_prod.kubernetes_host
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke_prod.kubernetes_ca)
  }
}