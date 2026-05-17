output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

// Output for ECS Service name and configuration
output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

// Collect the ENI that belongs to the ECS service security group.
// For this MVP (single task), this should resolve the task public IP after the service is up.
data "aws_network_interface" "ecs_task_primary" {
  filter {
    name   = "group-id"
    values = [aws_security_group.ecs_service.id]
  }

  filter {
    name   = "status"
    values = ["in-use"]
  }

  depends_on = [aws_ecs_service.app]
}

output "ecs_task_public_ip" {
  description = "Public IP of the ECS task (Terraform-native lookup)"
  value       = try(data.aws_network_interface.ecs_task_primary.association[0].public_ip, "")
}

output "ecs_task_public_url" {
  description = "HTTP URL for the ECS task"
  value       = try("http://${data.aws_network_interface.ecs_task_primary.association[0].public_ip}", "")
}

// Helper command to get the current public IP of the running ECS task.
// This avoids Terraform apply failures when the ENI is not ready yet.
output "ecs_task_public_ip_lookup_command" {
  description = "AWS CLI command to get ECS task public IP"
  value       = "TASK_ARN=$(aws ecs list-tasks --cluster ${aws_ecs_cluster.main.name} --service-name ${aws_ecs_service.app.name} --region ${var.aws_region} --profile ${var.profile_name} --query 'taskArns[0]' --output text) && ENI_ID=$(aws ecs describe-tasks --cluster ${aws_ecs_cluster.main.name} --tasks $TASK_ARN --region ${var.aws_region} --profile ${var.profile_name} --query \"tasks[0].attachments[0].details[?name=='networkInterfaceId'].value | [0]\" --output text) && aws ec2 describe-network-interfaces --network-interface-ids $ENI_ID --region ${var.aws_region} --profile ${var.profile_name} --query 'NetworkInterfaces[0].Association.PublicIp' --output text"
}