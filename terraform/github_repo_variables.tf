// Creates GitHub Actions repository variables used by the CI/CD workflow.
// Each key in local.github_actions_variables becomes a variable in GitHub Settings → Actions → Variables.
// Disabled by default (manage_github_actions_vars=false) so AWS-only applies are not affected.
//
// After apply with manage_github_actions_vars=true, the following variables are set in the repo:
//   AWS_REGION         = var.aws_region          (e.g. "eu-west-1")
//   AWS_ACCOUNT_ID     = var.aws_account_id       (e.g. "456989431911")
//   IAM_ROLE_TO_ASSUME = var.github_actions_role_to_assume
//   ECR_REPOSITORY     = var.ecr_repository_name  (e.g. "go-cicd-terra")
//   ECS_CLUSTER        = var.ecs_cluster_name      (e.g. "go-cicd-terra-cluster")
//   ECS_SERVICE        = var.ecs_service_name      (e.g. "go-cicd-terra-service")
//   CONTAINER_NAME     = var.ecs_container_name    (e.g. "go-cicd-terra-container")

resource "github_actions_variable" "workflow_vars" {
  for_each = var.manage_github_actions_vars ? local.github_actions_variables : {}

  repository    = var.github_repository
  variable_name = each.key
  value         = each.value
}
