variable "key_pair_name" {
  description = "Nome da Key Pair AWS para acesso RDP à instância"
  type        = string
}

variable "criar_instancia_ec2" {
  description = "Controla se a instância EC2 do SAP B1 será criada"
  type        = bool
  default     = true
}