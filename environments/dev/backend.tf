terraform {
  backend "s3" {
    bucket         = "sap-b1-installer-tfstate-vcp"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
