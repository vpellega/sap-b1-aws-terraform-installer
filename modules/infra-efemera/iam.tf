# IAM Role para a instância EC2
resource "aws_iam_role" "ec2_s3_access_role" {
  name_prefix = "${var.project_name}-${var.environment}-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-role"
  }
}

# Policy customizada para a instância
resource "aws_iam_policy" "s3_access_policy" {
  name        = "sapb1-ec2-s3-readonly-policy"
  description = "Permite leitura e escrita no bucket sapb1-installer pela EC2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::sapb1-installer",
          "arn:aws:s3:::sapb1-installer/*"
        ]
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-policy"
  }
}

# Anexar a política à role
resource "aws_iam_role_policy_attachment" "attach_policy_to_role" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "sapb1-ec2-instance-profile"
  role = aws_iam_role.ec2_s3_access_role.name

  tags = {
    Name = "${var.project_name}-${var.environment}-profile"
  }
}