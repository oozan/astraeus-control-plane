# Terraform Stack

## Entrypoints

- Primary variables: `variables.tf`
- Provider and version constraints: `providers.tf`, `versions.tf`
- Runtime resources:
  - `networking.tf`
  - `security.tf`
  - `data.tf`
  - `secrets.tf`
  - `compute.tf`
  - `monitoring.tf`
  - `ecr.tf`

## Operator workflow

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Required input

- `alert_email` must be set for SNS and budget notifications.

## Outputs

- ALB DNS endpoint
- ECR repository URLs
- ECS cluster name
- application secret ARN
