# Infrastructure Repository

Terraform configurations for multi-project infrastructure management.

## Structure

```
.
├── modules/                    # Reusable infrastructure modules
│   ├── vpc/                    # VPC networking
│   ├── gke/                    # GKE cluster
│   └── artifact-registry/      # Container registry
└── projects/                   # Project-specific configurations
    └── lineten/
        └── dev/                # Development environment
```

## Usage

```bash
cd projects/lineten/dev
terraform init
terraform plan
terraform apply
```

## Adding New Projects

1. Create directory: `projects/<project-name>/<environment>/`
2. Copy configuration from existing project
3. Update `terraform.tfvars` with project-specific values
4. Update `backend.tf` with unique state prefix

## Modules

| Module | Description |
|--------|-------------|
| vpc | VPC, subnets, Cloud NAT |
| gke | GKE Standard cluster with node pools |
| artifact-registry | Docker registry + CI/CD service account |
