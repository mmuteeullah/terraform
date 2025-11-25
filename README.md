# Recall-App Infrastructure

Terraform configuration for deploying the recall-app to GCP with GKE.

## Overview

This repository provisions:
- VPC with private subnets and Cloud NAT
- GKE Standard cluster with node pools
- Artifact Registry for container images
- Service accounts for CI/CD

## Prerequisites

- GCP project with billing enabled
- Terraform >= 1.5.0
- gcloud CLI configured

## Usage

```bash
# Create state bucket (first time only)
gsutil mb -p lineten -l us-east1 gs://lineten-terraform-state
gsutil versioning set on gs://lineten-terraform-state

# Deploy
terraform init
terraform plan
terraform apply
```

## Configuration

Edit `terraform.tfvars` to customize:

```hcl
project_id  = "lineten"
region      = "us-east1"
environment = "dev"
```

## Outputs

After apply, get cluster credentials:

```bash
$(terraform output -raw gke_connect_command)
```

## Cleanup

```bash
terraform destroy
```
