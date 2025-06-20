resource "aws_lambda_function" "ec2_autostop" {
  function_name = "ec2-autostop"
  runtime       = "nodejs22.x"
  handler       = "stop-ec2.handler"
  timeout       = 10
  role          = aws_iam_role.stop_resources_lambda_role.arn

  filename         = "${path.module}/scripts/stop-ec2.js.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/stop-ec2.js.zip")
}

resource "aws_lambda_function" "rds_autostop" {
  function_name = "rds-autostop"
  runtime       = "nodejs22.x"
  handler       = "stop-rds.handler"
  timeout       = 10
  role          = aws_iam_role.stop_resources_lambda_role.arn

  filename         = "${path.module}/scripts/stop-rds.js.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/stop-rds.js.zip")
}