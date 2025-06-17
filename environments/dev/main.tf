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

module "ec2-autostop" {
  source = "../../modules/ec2-autostop"

  schedule_expression_autostop_instances        = var.schedule_expression_autostop_instances
  schedule_expression_reminder                  = var.schedule_expression_reminder
  sns_reminder_phone_number                     = var.sns_reminder_phone_number
  sns_reminder_message                          = var.sns_reminder_message
}