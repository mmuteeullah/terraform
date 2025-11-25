# GCP Certificate Manager with DNS Authorization via Cloudflare

# Enable Certificate Manager API
resource "google_project_service" "certificatemanager" {
  project            = var.project_id
  service            = "certificatemanager.googleapis.com"
  disable_on_destroy = false
}

# DNS Authorization - creates the challenge record details
resource "google_certificate_manager_dns_authorization" "recall_app" {
  project     = var.project_id
  name        = "recall-app-dns-auth"
  domain      = var.domain
  description = "DNS authorization for ${var.domain}"

  depends_on = [google_project_service.certificatemanager]
}

# Cloudflare TXT record for DNS validation
resource "cloudflare_record" "cert_validation" {
  zone_id = var.cloudflare_zone_id
  name    = google_certificate_manager_dns_authorization.recall_app.dns_resource_record[0].name
  type    = google_certificate_manager_dns_authorization.recall_app.dns_resource_record[0].type
  content = google_certificate_manager_dns_authorization.recall_app.dns_resource_record[0].data
  ttl     = 300
  proxied = false
}

# GCP Managed Certificate
resource "google_certificate_manager_certificate" "recall_app" {
  project     = var.project_id
  name        = "recall-app-cert"
  description = "Managed certificate for ${var.domain}"

  managed {
    domains = [var.domain]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.recall_app.id
    ]
  }

  depends_on = [cloudflare_record.cert_validation]
}

# Certificate Map
resource "google_certificate_manager_certificate_map" "recall_app" {
  project     = var.project_id
  name        = "recall-app-cert-map"
  description = "Certificate map for ${var.domain}"

  depends_on = [google_project_service.certificatemanager]
}

# Certificate Map Entry
resource "google_certificate_manager_certificate_map_entry" "recall_app" {
  project      = var.project_id
  name         = "recall-app-cert-map-entry"
  map          = google_certificate_manager_certificate_map.recall_app.name
  certificates = [google_certificate_manager_certificate.recall_app.id]
  hostname     = var.domain
}

# HTTPS Target Proxy with Certificate Map
# Note: URL map is managed by GKE Ingress controller
resource "google_compute_target_https_proxy" "recall_app" {
  project          = var.project_id
  name             = "recall-app-https-proxy"
  url_map          = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/urlMaps/${var.gke_url_map_name}"
  certificate_map  = "https://certificatemanager.googleapis.com/v1/${google_certificate_manager_certificate_map.recall_app.id}"
}

# HTTPS Forwarding Rule (port 443)
resource "google_compute_global_forwarding_rule" "recall_app_https" {
  project    = var.project_id
  name       = "recall-app-https-forwarding-rule"
  target     = google_compute_target_https_proxy.recall_app.id
  port_range = "443"
  ip_address = google_compute_global_address.recall_app.address
}
