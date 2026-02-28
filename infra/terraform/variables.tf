variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "astraeus-control-plane"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.30.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones"
  type        = number
  default     = 2
}

variable "api_container_port" {
  description = "API container port"
  type        = number
  default     = 8080
}

variable "api_desired_count" {
  description = "Desired API task count"
  type        = number
  default     = 2
}

variable "worker_desired_count" {
  description = "Desired worker task count"
  type        = number
  default     = 1
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "cloud"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "cloud"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t4g.micro"
}

variable "api_image_tag" {
  description = "Tag for API image"
  type        = string
  default     = "latest"
}

variable "worker_image_tag" {
  description = "Tag for worker image"
  type        = string
  default     = "latest"
}

variable "alert_email" {
  description = "Email for alarms and budget alerts"
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly cost budget"
  type        = string
  default     = "30"
}
