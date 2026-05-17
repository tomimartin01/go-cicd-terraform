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

// Enable or disable GitHub Actions variables management from Terraform.
variable "manage_github_actions_vars" {
  description = "Whether Terraform should manage GitHub Actions repository variables"
  type        = bool
  default     = false
}

// GitHub organization or user owner of the repository.
variable "github_owner" {
  description = "GitHub owner for the repository"
  type        = string
  default     = "tomimartin01"
}

// GitHub repository name where Actions variables will be created.
variable "github_repository" {
  description = "GitHub repository name"
  type        = string
  default     = "go-cicd-terraform"
}

// IAM role ARN used by GitHub OIDC in the workflow.
// Uses the pre-existing student lab role (cannot be created in student accounts).
variable "github_actions_role_to_assume" {
  description = "IAM role ARN for GitHub Actions OIDC"
  type        = string
  default     = "arn:aws:iam::456989431911:role/studentEcsTaskExecutionRole"
}

// AWS account ID exposed to GitHub Actions repository variables.
variable "aws_account_id" {
  description = "AWS account ID for GitHub Actions workflow variables"
  type        = string
  default     = ""
}

// ECS service name used by the workflow deploy step.
variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
  default     = "go-cicd-terra-service"
}

// Container name used in task definition rendering.
variable "ecs_container_name" {
  description = "Container name in ECS task definition"
  type        = string
  default     = "go-cicd-terra-container"
}

// Repository-level GitHub Actions variables consumed by CI/CD workflow.
locals {
  github_actions_variables = {
    AWS_REGION         = var.aws_region
    AWS_ACCOUNT_ID     = var.aws_account_id
    IAM_ROLE_TO_ASSUME = var.github_actions_role_to_assume
    ECR_REPOSITORY     = var.ecr_repository_name
    ECS_CLUSTER        = var.ecs_cluster_name
    ECS_SERVICE        = var.ecs_service_name
    CONTAINER_NAME     = var.ecs_container_name
  }
}

