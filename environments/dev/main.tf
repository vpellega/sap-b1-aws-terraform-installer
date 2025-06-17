module "infra-efemera" {
  source              = "../../modules/infra-efemera"

  key_pair_name       = var.key_pair_name
  criar_instancia_ec2 = var.criar_instancia_ec2
  environment         = "dev"
  project_name        = "SAP-B1"
}

module "infra-fixa" {
  source              = "../../modules/infra-fixa"
  
  bucket_name         = "sapb1-installer"
  environment         = "dev"
  project_name        = "SAP-B1"
}