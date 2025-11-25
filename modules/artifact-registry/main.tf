resource "google_artifact_registry_repository" "main" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.project_id}-${var.environment}"
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-recent"
    action = "KEEP"
    most_recent_versions {
      keep_count = 5
    }
  }
}

# CI/CD service account for pushing images and deploying
resource "google_service_account" "cicd" {
  account_id   = "${var.project_id}-cicd-${var.environment}"
  project      = var.project_id
  display_name = "CI/CD Service Account"
}

resource "google_artifact_registry_repository_iam_member" "cicd_writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.main.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.cicd.email}"
}

resource "google_project_iam_member" "cicd_gke" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.cicd.email}"
}

resource "google_service_account_key" "cicd" {
  service_account_id = google_service_account.cicd.name
}
