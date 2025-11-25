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

output "cicd_sa_key" {
  value     = module.artifact_registry.cicd_sa_key
  sensitive = true
}

output "gke_connect_command" {
  value = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${var.region} --project ${var.project_id}"
}
