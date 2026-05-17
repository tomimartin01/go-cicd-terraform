// Reference the pre-existing IAM role for ECS task execution in student lab accounts.
data "aws_iam_role" "lab_role" {
  name = "studentEcsTaskExecutionRole"
}