// ECS Task Definition 
// Uses the ECR image, exposes port 80, no advanced variables or volumes.

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256" // 0.25 vCPU
  memory                   = "512" // 512 MiB RAM
  execution_role_arn       = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-container"
      image     = aws_ecr_repository.app.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
