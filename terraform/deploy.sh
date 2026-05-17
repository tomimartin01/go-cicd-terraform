#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Starting Terraform..."
export AWS_PROFILE=dev-profile
export AWS_DEFAULT_REGION=eu-west-1

# The S3 bucket for the backend must exist beforehand (created manually once in the AWS console).
terraform init
terraform apply

echo ""
echo "=============================="
echo "✅ Deployment completed successfully."
echo ""
ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)
ECR_URL=$(terraform output -raw ecr_repository_url)
echo "ECS Cluster: $ECS_CLUSTER"
echo "ECR Repository: $ECR_URL"
