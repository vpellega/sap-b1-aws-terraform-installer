variable "key_pair_name" {
  description = "Nome da Key Pair AWS para acesso RDP à instância"
  type        = string
}

variable "criar_instancia_ec2" {
  description = "Controla se a instância EC2 do SAP B1 será criada"
  type        = bool
  default     = true
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

variable "additional_tags" {
  description = "Tags adicionais para todos os recursos"
  type        = map(string)
  default     = {}
}