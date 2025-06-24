# Outputs principais
output "ip_publico_sap_b1" {
  description = "Endereço IP público da instância SAP B1"
  value       = module.infra-efemera.public_ip
}

output "debug_instance_info" {
  description = "Informações de debug da instância"
  value = module.infra-efemera.public_ip != null ? {
    instance_id     = module.infra-efemera.instance_id
    public_ip       = module.infra-efemera.public_ip
    private_ip      = module.infra-efemera.private_ip
  } : null
}

output "subnet_details" {
  description = "Detalhes da subnet utilizada"
  value       = module.infra-efemera.subnet_details
}

output "caller_identity_arn" {
  description = "ARN do principal (usuário ou role assumida) autorizado a acessar o SNS"
  value       = data.aws_iam_session_context.current.issuer_arn
}