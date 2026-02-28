output "alb_dns_name" {
  value       = aws_lb.api.dns_name
  description = "Public ALB DNS endpoint"
}

output "api_ecr_repository_url" {
  value       = aws_ecr_repository.api.repository_url
  description = "ECR URL for API image"
}

output "worker_ecr_repository_url" {
  value       = aws_ecr_repository.worker.repository_url
  description = "ECR URL for worker image"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "ECS cluster name"
}

output "app_secret_arn" {
  value       = aws_secretsmanager_secret.app.arn
  description = "Secrets Manager ARN storing app config"
}
