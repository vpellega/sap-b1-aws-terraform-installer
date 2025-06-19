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

variable "environment" {
  description = "Nome do ambiente (dev, prod, etc)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nome do projeto para tags"
  type        = string
  default     = "SAP-B1"
}

