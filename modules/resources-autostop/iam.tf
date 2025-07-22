###############################################
# IAM: Permissões e Roles para Lambda (autostop)
###############################################
resource "aws_iam_role" "stop_resources_lambda_role" {
  name = "stop-resources-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "stop_resources_lambda_policy" {
  name = "stop-resources-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "rds:DescribeDBInstances",
          "rds:ListTagsForResource",
          "rds:StopDBInstance"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_stop_resources_policy" {
  role       = aws_iam_role.stop_resources_lambda_role.name
  policy_arn = aws_iam_policy.stop_resources_lambda_policy.arn
}

###############################################
# IAM: Permissões e Role para Lambda reminder
###############################################
resource "aws_iam_role" "reminder_lambda_role" {
  name = "reminder-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "reminder_lambda_policy" {
  name = "reminder-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "rds:DescribeDBInstances",
          "sns:Publish"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_reminder_lambda_policy" {
  role       = aws_iam_role.reminder_lambda_role.name
  policy_arn = aws_iam_policy.reminder_lambda_policy.arn
}

###############################################
# IAM: Policy do SNS (permite EventBridge publicar)
###############################################
resource "aws_sns_topic_policy" "resource_autostop_reminder_policy" {
  arn = aws_sns_topic.resource-autostop-reminder.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowEventBridgeToPublish",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.resource-autostop-reminder.arn,
        Condition = {
          ArnEquals = {
            "AWS:SourceArn" = aws_cloudwatch_event_rule.reminder.arn
          }
        }
      }
    ]
  })
}