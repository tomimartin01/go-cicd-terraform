// Target AWS region for provider and deployed resources.
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

// Base name used in infrastructure resources.
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "go-cicd-terra"
}

// Local AWS profile used for Terraform CLI executions.
variable "profile_name" {
  description = "AWS Profile Name"
  type        = string
  default     = "dev-profile"
}

// Name of ECR repository where images are published.
variable "ecr_repository_name" {
  description = "ECR repository name for the application image"
  type        = string
  default     = "go-cicd-terra"
}

// Number of recent images to keep before expiring old ones.
variable "ecr_image_retention_count" {
  description = "How many recent images to keep in ECR"
  type        = number
  default     = 20
}

// Name of ECS cluster for running services and tasks.
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "go-cicd-terra-cluster"
}

