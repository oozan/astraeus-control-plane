# Infrastructure

Infrastructure definitions are implemented in Terraform under `infra/terraform`.

Scope includes:

- network topology (VPC, public/private subnets, routing, NAT)
- compute plane (ECS Fargate, ALB, autoscaling)
- data services (RDS PostgreSQL, ElastiCache Redis)
- security and secret delivery (IAM, Secrets Manager, security groups)
- observability and cost governance (CloudWatch alarms, SNS, AWS Budget)
