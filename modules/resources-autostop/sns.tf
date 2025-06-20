resource "aws_sns_topic" "ec2-autostop-reminder" {
  name = "ec2-autostop-reminder"
  display_name = "AutoStopReminder"
}

resource "aws_sns_topic_subscription" "sms_alert" {
  topic_arn = aws_sns_topic.ec2-autostop-reminder.arn
  protocol  = "sms"
  endpoint  = var.sns_reminder_phone_number
}