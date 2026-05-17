// ECS Service to run and maintain the task
// Launches tasks in Fargate, assigns them to public subnets and security group.

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.app]

  tags = {
    Name = "${var.project_name}-service"
  }
}
