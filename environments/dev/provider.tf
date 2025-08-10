terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Ambiente  = var.environment
      Projeto   = var.project_name
      CriadoPor = "Terraform"
    }
  }
}
