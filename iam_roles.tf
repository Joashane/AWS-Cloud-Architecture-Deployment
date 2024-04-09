# IAM Role for EC2 instances with read-only access to S3
resource "aws_iam_role" "s3_read_only" {
  name = "s3_read_only_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for read-only access to S3
resource "aws_iam_policy" "s3_read_only_policy" {
  name        = "s3_read_only_policy"
  description = "Policy for read-only access to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "s3_read_only_attach" {
  role       = aws_iam_role.s3_read_only.name
  policy_arn = aws_iam_policy.s3_read_only_policy.arn
}

# IAM Instance Profile for EC2 instances
resource "aws_iam_instance_profile" "s3_read_only_profile" {
  name = "s3_read_only_profile"
  role = aws_iam_role.s3_read_only.name
}
