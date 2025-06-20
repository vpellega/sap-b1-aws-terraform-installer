##############################################
# EC2 - SAP Server
##############################################
variable "key_pair_name" {
  description = "Nome da Key Pair AWS para acesso RDP à instância"
  type        = string
}

variable "criar_instancia_ec2" {
  description = "Controla se a instância EC2 do SAP B1 será criada"
  type        = bool
  default     = true
}

variable "allowed_ip_cidr" {
  description = "IP público permitido para acessar a instância (ex: 200.200.200.200/32)"
  type        = string
}

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
  default     = "15.00.4073.23.v1"
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
  description = "Nome do projeto para tags"
  type        = string
  default     = "sap-b1"
}

variable "environment" {
  description = "Nome do ambiente (dev, prod, etc)"
  type        = string
}


