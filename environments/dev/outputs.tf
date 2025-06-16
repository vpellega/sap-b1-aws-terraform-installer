# Outputs principais
output "ip_publico_sap_b1" {
  description = "Endereço IP público da instância SAP B1"
  value       = module.sap_infrastructure.public_ip
}

output "connection_info" {
  description = "Informações para conexão RDP"
  value       = module.sap_infrastructure.connection_info
}

output "debug_instance_info" {
  description = "Informações de debug da instância"
  value = module.sap_infrastructure.public_ip != null ? {
    instance_id     = module.sap_infrastructure.instance_id
    public_ip       = module.sap_infrastructure.public_ip
    private_ip      = module.sap_infrastructure.private_ip
    security_group  = module.sap_infrastructure.security_group_id
  } : null
}

output "subnet_details" {
  description = "Detalhes da subnet utilizada"
  value       = module.sap_infrastructure.subnet_details
}