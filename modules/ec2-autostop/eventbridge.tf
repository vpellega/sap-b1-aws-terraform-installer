# ---------------------------------------
# Evento de AutoStop da instância EC2
# ---------------------------------------
resource "aws_cloudwatch_event_rule" "autostop_instances" {
  name                = "ec2-autostop-schedule"
  schedule_expression = var.schedule_expression_autostop_instances
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.autostop_instances.name
  target_id = "ec2-autostop-lambda"
  arn       = aws_lambda_function.ec2_autostop.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_autostop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.autostop_instances.arn
}

#
# -------------------------------------
# Evento de Alerta pré-desligamento
# -------------------------------------
#
resource "aws_cloudwatch_event_rule" "reminder" {
  name                = "ec2-autostop-reminder"
  schedule_expression = var.schedule_expression_reminder
}

# A mensagem será sobrescrita manualmente no console se necessário
resource "aws_cloudwatch_event_target" "reminder_target" {
  rule      = aws_cloudwatch_event_rule.reminder.name
  target_id = "ec2-autostop-reminder-sns"
  arn       = aws_sns_topic.ec2-autostop-reminder.arn
  
  input = jsonencode({
    default = var.sns_reminder_message
  })
}