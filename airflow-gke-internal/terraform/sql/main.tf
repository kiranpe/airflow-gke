
resource "google_sql_database_instance" "airflow" {
  name             = "airflow-sql"
  database_version = "POSTGRES_14"
  region           = var.region
  project          = var.project_id

  settings {
    tier = "db-custom-1-3840"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "airflow" {
  name     = "airflow"
  instance = google_sql_database_instance.airflow.name
  password = var.db_password
  project  = var.project_id
}

resource "google_sql_database" "airflow" {
  name     = "airflow"
  instance = google_sql_database_instance.airflow.name
  project  = var.project_id
}
