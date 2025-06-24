variable "caller_identity_arn" {
  type        = string
  description = "ARN do principal (usuário ou role assumida) autorizado a acessar o SNS"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "SAP-B1"
}

variable "environment" {
  description = "Ambiente (dev, prod, etc)"
  type        = string
}

