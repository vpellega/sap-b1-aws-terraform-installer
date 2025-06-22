# -------------------------------------------
# Evento de AutoStop da instância EC2 e RDS
# -------------------------------------------
resource "aws_cloudwatch_event_rule" "autostop_instances" {
  name                = "autostop-schedule"
  schedule_expression = var.schedule_expression_autostop_instances
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.autostop_instances.name
  target_id = "ec2-autostop-lambda"
  arn       = aws_lambda_function.ec2_autostop.arn
}

resource "aws_cloudwatch_event_target" "rds_lambda_target" {
  rule      = aws_cloudwatch_event_rule.autostop_instances.name
  target_id = "rds-autostop-lambda"
  arn       = aws_lambda_function.rds_autostop.arn
}

resource "aws_lambda_permission" "allow_eventbridge_ec2" {
  statement_id  = "AllowExecutionFromEventBridgeEC2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_autostop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.autostop_instances.arn
}

resource "aws_lambda_permission" "allow_eventbridge_rds" {
  statement_id  = "AllowExecutionFromEventBridgeRDS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_autostop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.autostop_instances.arn
}

#
# -------------------------------------
# Evento de Alerta pré-desligamento
# -------------------------------------
#
resource "aws_cloudwatch_event_rule" "reminder" {
  name                = "resource-autostop-reminder"
  schedule_expression = var.schedule_expression_reminder
}

resource "aws_cloudwatch_event_target" "reminder_lambda_target" {
  rule      = aws_cloudwatch_event_rule.reminder.name
  target_id = "reminder-lambda"
  arn       = aws_lambda_function.reminder.arn
}

resource "aws_lambda_permission" "allow_eventbridge_reminder" {
  statement_id  = "AllowExecutionFromEventBridgeReminder"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reminder.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.reminder.arn
}