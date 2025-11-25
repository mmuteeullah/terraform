locals {
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "vpc" {
  source = "../../../modules/vpc"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  depends_on = [google_project_service.apis]
}

module "gke" {
  source = "../../../modules/gke"

  project_id   = var.project_id
  region       = var.region
  zone         = "${var.region}-b"
  environment  = var.environment
  network_name = module.vpc.network_name
  subnet_name  = module.vpc.subnet_name

  depends_on = [module.vpc]
}

module "artifact_registry" {
  source = "../../../modules/artifact-registry"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  depends_on = [google_project_service.apis]
}

resource "google_compute_global_address" "recall_app" {
  name    = "recall-app-ip"
  project = var.project_id
}
