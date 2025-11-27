output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value     = module.gke.cluster_endpoint
  sensitive = true
}

output "repository_url" {
  value = module.artifact_registry.repository_url
}

output "gke_connect_command" {
  value = "gcloud container clusters get-credentials ${module.gke.cluster_name} --zone ${var.region}-b --project ${var.project_id}"
}

output "recall_app_ip" {
  value = google_compute_global_address.recall_app.address
}

output "wif_provider" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "cicd_sa_email" {
  value = module.artifact_registry.cicd_sa_email
}

output "certificate_map_id" {
  description = "Certificate map ID to attach to load balancer"
  value       = google_certificate_manager_certificate_map.recall_app.id
}

output "certificate_status" {
  description = "Certificate provisioning status for recall-app"
  value       = google_certificate_manager_certificate.recall_app.managed[0].state
}

# Carworth outputs
output "carworth_ip" {
  description = "Static IP for carworth"
  value       = google_compute_global_address.carworth.address
}

output "carworth_certificate_map_id" {
  description = "Certificate map ID for carworth"
  value       = google_certificate_manager_certificate_map.carworth.id
}

output "carworth_certificate_status" {
  description = "Certificate provisioning status for carworth"
  value       = google_certificate_manager_certificate.carworth.managed[0].state
}
