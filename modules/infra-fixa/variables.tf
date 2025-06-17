variable "bucket_name" {
  description = "Nome do bucket S3 com os instaladores SAP"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod, etc)"
  type        = string
}