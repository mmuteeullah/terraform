resource "google_container_cluster" "main" {
  name     = "${var.project_id}-cluster-${var.environment}"
  project  = var.project_id
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_name
  subnetwork = var.subnet_name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_cidr
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = false

  resource_labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_container_node_pool" "main" {
  name     = "${var.project_id}-nodepool-${var.environment}"
  project  = var.project_id
  location = var.region
  cluster  = google_container_cluster.main.name

  initial_node_count = var.node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      environment = var.environment
    }

    tags = ["gke-node", "${var.project_id}-cluster-${var.environment}"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
