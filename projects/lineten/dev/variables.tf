variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "master_authorized_cidr" {
  description = "CIDR block authorized to access the GKE master"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token for DNS management"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

variable "domain" {
  description = "Domain name for the application"
  type        = string
  default     = "recall.b0lt.foo"
}

variable "gke_url_map_name" {
  description = "Name of the GKE Ingress-managed URL map"
  type        = string
}
