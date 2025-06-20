variable "bucket_name" {
  description = "Nome do bucket S3 com os instaladores SAP"
  type        = string
}

##############################################
# Projeto e Ambiente
##############################################
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "SAP-B1"
}

variable "environment" {
  description = "Ambiente (dev, prod, etc)"
  type        = string
}