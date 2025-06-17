variable "key_pair_name" {
  description = "Nome da Key Pair AWS para acesso RDP à instância"
  type        = string
}

variable "criar_instancia_ec2" {
  description = "Controla se a instância EC2 do SAP B1 será criada"
  type        = bool
  default     = true
}

variable "sns_reminder_phone_number" {
  description = "Número de telefone para envio de SMS antes do desligamento"
  type        = string
}

variable "sns_reminder_message" {
  description = "Mensagem enviada via SMS no lembrete"
  type        = string
  default     = "Alerta: sua instância com AutoStop=true será desligada às 23h!"
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