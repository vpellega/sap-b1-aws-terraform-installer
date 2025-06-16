module "sap_infrastructure" {
  source = "../../modules/sap-infrastructure"

  key_pair_name       = var.key_pair_name
  criar_instancia_ec2 = var.criar_instancia_ec2
  environment         = "dev"
  project_name        = "SAP-B1"
}