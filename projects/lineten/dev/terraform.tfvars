project_id  = "lineten"
region      = "us-east1"
environment = "dev"

# GKE master authorized network - restrict to specific IPs in production
# Using 0.0.0.0/0 for demo accessibility; replace with your IP/32 for production
master_authorized_cidr = "0.0.0.0/0"

# Cloudflare configuration
# cloudflare_api_token - set via TF_VAR_cloudflare_api_token env var
cloudflare_zone_id = "e1c7f9d001d45ec0562fc7b925d1a29d"
domain             = "recall.b0lt.foo"
carworth_domain    = "carworth.b0lt.foo"

# GKE Ingress URL map (managed by GKE, referenced here for HTTPS proxy)
gke_url_map_name         = "k8s2-um-j3k2uz7k-recall-app-recall-app-ga3kdhqt"
carworth_gke_url_map_name = "k8s2-um-j3k2uz7k-carworth-carworth-aa7n81rc"
