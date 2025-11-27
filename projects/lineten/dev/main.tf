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

  project_id             = var.project_id
  region                 = var.region
  zone                   = "${var.region}-b"
  environment            = var.environment
  network_name           = module.vpc.network_name
  subnet_name            = module.vpc.subnet_name
  master_authorized_cidr = var.master_authorized_cidr

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

resource "google_compute_global_address" "carworth" {
  name    = "carworth-ip"
  project = var.project_id
}

# Workload Identity Federation for GitHub Actions
resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == 'mmuteeullah/recall-app' || assertion.repository == 'mmuteeullah/carworth'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_wif_recall_app" {
  service_account_id = module.artifact_registry.cicd_sa_id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/mmuteeullah/recall-app"
}

resource "google_service_account_iam_member" "github_wif_carworth" {
  service_account_id = module.artifact_registry.cicd_sa_id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/mmuteeullah/carworth"
}
