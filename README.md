# Astraeus Control Plane

Cloud-native asynchronous processing platform with production-grade delivery, operations, and infrastructure controls.

## System design

- API service (`FastAPI`) accepts processing requests and exposes status endpoints.
- Worker service (`RQ`) consumes queued jobs and performs background execution.
- `PostgreSQL` stores durable job state and results.
- `Redis` backs queue delivery and worker coordination.
- AWS runtime uses ECS Fargate, ALB, RDS, ElastiCache, ECR, CloudWatch, SNS, and Budgets.

## Engineering standards

- Infrastructure as Code via Terraform.
- CI gates for tests, syntax checks, and Terraform validation.
- Private networking for compute and data services.
- Secrets managed through AWS Secrets Manager.
- CloudWatch alarms and budget notifications for reliability and cost governance.

## Repository map

```text
.
├── .github/workflows        # CI/CD workflows
├── docs                     # deployment and operations references
├── infra/terraform          # AWS infrastructure definitions
├── services/api             # HTTP service
├── services/worker          # async execution service
├── docker-compose.yml       # local runtime stack
└── Makefile                 # common operator commands
```

## Local execution

1. Prepare environment:

```bash
cp .env.example .env
```

2. Build and run:

```bash
make up
```

3. Validate health:

```bash
curl http://localhost:8080/health
```

4. Submit and inspect a job:

```bash
curl -X POST http://localhost:8080/jobs \
  -H "content-type: application/json" \
  -d '{"payload": {"text": "asynchronous cloud workload"}}'
```

```bash
curl http://localhost:8080/jobs/<job-id>
```

## Infrastructure and deployment

- Terraform entrypoint: `infra/terraform`
- Deployment workflow: `.github/workflows/deploy.yml`
- Step-by-step guide: `docs/deployment.md`
- Incident and recovery procedures: `docs/runbook.md`

## Public release checklist

- Keep `.env` local only; do not commit environment files.
- Configure these GitHub repository secrets before running deployment workflow:
  - `AWS_ROLE_ARN`
  - `AWS_REGION`
  - `ECR_API_REPOSITORY`
  - `ECR_WORKER_REPOSITORY`
  - `ALERT_EMAIL`
- `deploy.yml` is guarded and will skip deploy jobs until required secrets are present.
- Automatic apply on `main` requires repository variable `TF_AUTO_APPLY=true`; otherwise only planning runs.
