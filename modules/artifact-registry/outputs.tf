output "repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.main.repository_id}"
}

output "repository_id" {
  value = google_artifact_registry_repository.main.repository_id
}

output "cicd_sa_email" {
  value = google_service_account.cicd.email
}

output "cicd_sa_key" {
  value     = google_service_account_key.cicd.private_key
  sensitive = true
}
