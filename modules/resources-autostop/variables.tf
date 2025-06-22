variable "instance_tag_key" {
  description = "Tag key usada para identificar instâncias que devem ser desligadas"
  type        = string
  default     = "AutoStop"
}

variable "instance_tag_value" {
  description = "Valor da tag que identifica instâncias a serem desligadas"
  type        = string
  default     = "true"
}

variable "schedule_expression_autostop_instances" {
  description = "Expressão cron para agendamento do desligamento (UTC)"
  type        = string
  default     = "cron(0 2 * * ? *)" # 23h BRT
}

variable "schedule_expression_reminder" {
  description = "Expressão cron para agendamento do desligamento (UTC)"
  type        = string
  default     = "cron(45 1 * * ? *)" # 22:45 BRT = 01:45 UTC
}

variable "sns_reminder_phone_number" {
  description = "Número de telefone (E.164) para envio de SMS de lembrete antes do desligamento da EC2"
  type        = string
}
