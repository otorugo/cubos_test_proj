

resource "aws_iam_role" "app_instance_role" {
  name = "app_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_attachment" {
  role = aws_iam_role.app_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# Create an IAM instance profile
resource "aws_iam_instance_profile" "iam_role" {
  name = "user_apps_ec2"
  role = aws_iam_role.app_instance_role.name
}

