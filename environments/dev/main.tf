module "infra-efemera" {
  source              = "../../modules/infra-efemera"

  criar_instancia_ec2 = var.criar_instancia_ec2
  allowed_ip_cidr     = var.allowed_ip_cidr
  instance_tag_key    = module.resources-autostop.instance_tag_key
  instance_tag_value  = module.resources-autostop.instance_tag_value
  
  sql_engine          = var.sql_engine
  sql_engine_version  = var.sql_engine_version
  sql_username        = var.sql_username
  sql_password        = var.sql_password
  
  environment         = var.environment
}

module "infra-fixa" {
  source                                      = "../../modules/infra-fixa"
  
  caller_identity_arn                         = data.aws_iam_session_context.current.issuer_arn
  
  environment                                 = var.environment
}

module "resources-autostop" {
  source = "../../modules/resources-autostop"

  schedule_expression_autostop_instances        = var.schedule_expression_autostop_instances
  schedule_expression_autostop_rds              = var.schedule_expression_autostop_rds
  schedule_expression_reminder                  = var.schedule_expression_reminder
  sns_reminder_phone_number                     = var.sns_reminder_phone_number
  sns_reminder_message                          = var.sns_reminder_message
}