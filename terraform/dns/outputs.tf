
output "dns_zone_name" {
  value = google_dns_managed_zone.internal_airflow.name
}
