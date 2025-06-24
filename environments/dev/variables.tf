##############################################
# EC2 - SAP Server
##############################################
variable "criar_instancia_ec2" {
  description = "Controla se a instância EC2 do SAP B1 será criada"
  type        = bool
  default     = true
}

variable "allowed_ip_cidr" {
  description = "IP público permitido para acessar a instância (ex: 200.200.200.200/32)"
  type        = string
}

##############################################
# EC2- Autostop
##############################################
variable "sns_reminder_phone_number" {
  description = "Número de telefone para envio de SMS antes do desligamento"
  type        = string
}

variable "sns_reminder_message" {
  description = "Mensagem enviada via SMS no lembrete"
  type        = string
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

##############################################
# RDS - SQL Server
##############################################
variable "sql_engine" {
  description = "Engine do SQL Server (ex: sqlserver-ex, sqlserver-se)"
  type        = string
  default     = "sqlserver-ex"
}

variable "sql_engine_version" {
  description = "Versão do SQL Server"
  type        = string
  default     = "15.00.4430.1.v1"
}

variable "sql_username" {
  description = "Usuário administrador do SQL Server"
  type        = string
  default     = "sapadmin"
}

variable "sql_password" {
  description = "Senha do usuário administrador do SQL Server"
  type        = string
  sensitive   = true
}

##############################################
# Projeto e Ambiente
##############################################
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default = "sap-b1"
}

variable "environment" {
  description = "Ambiente (dev, prod, etc)"
  type        = string
  default = "dev"
}