resource "aws_sns_topic" "resource-autostop-reminder" {
  name         = "resource-autostop-reminder"
  display_name = "AutoStopReminder"
}

resource "aws_sns_topic_subscription" "sms_alert" {
  topic_arn = aws_sns_topic.resource-autostop-reminder.arn
  protocol  = "sms"
  endpoint  = var.sns_reminder_phone_number
}