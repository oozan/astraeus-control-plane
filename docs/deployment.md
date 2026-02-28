# Deployment Guide

## 0) Configure GitHub repository secrets

Set the following repository secrets before using `.github/workflows/deploy.yml`:

- `AWS_ROLE_ARN`
- `AWS_REGION`
- `ECR_API_REPOSITORY`
- `ECR_WORKER_REPOSITORY`
- `ALERT_EMAIL`

Optional for automatic apply on push to `main`:

- Repository variable `TF_AUTO_APPLY=true`

## 1) Create Terraform variables

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
```

Set at least:

- `alert_email`
- `aws_region`

## 2) Provision infrastructure

```bash
terraform init
terraform apply
```

Confirm the SNS subscription email from AWS.

## 3) Build and push container images

Use output ECR URLs from Terraform:

```bash
terraform output api_ecr_repository_url
terraform output worker_ecr_repository_url
```

Build and push:

```bash
docker build -f ../../services/api/Dockerfile -t <api-ecr-url>:latest ../..
docker push <api-ecr-url>:latest

docker build -f ../../services/worker/Dockerfile -t <worker-ecr-url>:latest ../..
docker push <worker-ecr-url>:latest
```

## 4) Redeploy ECS services

```bash
aws ecs update-service --cluster <cluster-name> --service <api-service-name> --force-new-deployment
aws ecs update-service --cluster <cluster-name> --service <worker-service-name> --force-new-deployment
```

## 5) Validate

- Use ALB DNS output: `terraform output alb_dns_name`
- Check `/health` endpoint
- Create a job via `/jobs` and verify completion via `/jobs/{id}`
