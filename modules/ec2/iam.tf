resource "aws_iam_role" "role" {
  count = length(var.policy_list) > 0 ? 1 : 0
  name = "${var.tool_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.tool_name}-role-policy"
  }
}

resource "aws_iam_role_policy" "role_policy" {
  count = length(var.policy_list) > 0 ? 1 : 0

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_list
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  role = aws_iam_role.role[0].name
}


resource "aws_iam_instance_profile" "instance_" {
  count = length(var.policy_list) > 0 ? 1 : 0

  name = "${var.tool_name}-role"
  role = aws_iam_role.role[0].name
}
