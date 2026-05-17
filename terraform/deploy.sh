#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Starting Terraform..."

# Use profile-based auth by default.
export AWS_PROFILE="${AWS_PROFILE:-dev-profile}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-eu-west-1}"

# Prevent stale static credentials from overriding AWS_PROFILE.
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_SECURITY_TOKEN

echo "Using AWS profile: $AWS_PROFILE"
echo "Using AWS region:  $AWS_DEFAULT_REGION"

if ! aws sts get-caller-identity >/dev/null 2>&1; then
	echo "❌ AWS authentication failed for profile '$AWS_PROFILE'."
	echo "Run: aws configure sso --profile $AWS_PROFILE"
	echo "Then: aws sso login --profile $AWS_PROFILE"
	exit 1
fi

# The S3 bucket for the backend must exist beforehand (created manually once in the AWS console).
terraform init -reconfigure
terraform apply

echo ""
echo "=============================="
echo "✅ Deployment completed successfully."
echo ""
ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)
ECR_URL=$(terraform output -raw ecr_repository_url)
echo "ECS Cluster: $ECS_CLUSTER"
echo "ECR Repository: $ECR_URL"
