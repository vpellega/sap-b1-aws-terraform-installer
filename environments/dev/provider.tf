terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Ambiente  = "Desenvolvimento"
      Projeto   = "SAP-B1"
      CriadoPor = "Terraform"
    }
  }
}
