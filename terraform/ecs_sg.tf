// Security Group for ECS tasks
// Allows inbound HTTP (port 80) from anywhere and all outbound traffic.

resource "aws_security_group" "ecs_service" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow HTTP traffic to ECS tasks"
  vpc_id      = aws_vpc.main.id

  // Inbound rule: allow HTTP from anywhere
  ingress {
    description      = "Allow HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  // Outbound rule: allow all traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}
