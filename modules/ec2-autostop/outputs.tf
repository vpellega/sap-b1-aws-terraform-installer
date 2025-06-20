output "sns_reminder_phone_number" {
  value       = var.sns_reminder_phone_number
  description = "Número de telefone configurado para envio de SMS via SNS"
}

output "sns_reminder_topic_arn" {
  value       = aws_sns_topic.ec2-autostop-reminder.arn
}

output "instance_tag_key" {
  value       = var.instance_tag_key
}

output "instance_tag_value" {
  value       = var.instance_tag_value
}