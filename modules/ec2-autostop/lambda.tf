resource "aws_lambda_function" "ec2_autostop" {
  function_name = "ec2-autostop"
  runtime       = "nodejs22.x"
  handler       = "stop-ec2.handler"
  timeout       = 10
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/scripts/lambda/stop-ec2.js.zip"
  source_code_hash = filebase64sha256("${path.module}/scripts/stop-ec2.js.zip")
}