project_id  = "lineten"
region      = "us-east1"
environment = "dev"

# GKE master authorized network - restrict to specific IPs in production
# Using 0.0.0.0/0 for demo accessibility; replace with your IP/32 for production
master_authorized_cidr = "0.0.0.0/0"
