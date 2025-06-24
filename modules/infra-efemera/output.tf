output "instance_id" {
  description = "ID da instância EC2 SAP B1"
  value       = var.criar_instancia_ec2 ? aws_instance.sap_b1_server[0].id : null
}

output "public_ip" {
  description = "IP público da instância SAP B1"
  value       = var.criar_instancia_ec2 ? aws_instance.sap_b1_server[0].public_ip : null
}

output "private_ip" {
  description = "IP privado da instância SAP B1"
  value       = var.criar_instancia_ec2 ? aws_instance.sap_b1_server[0].private_ip : null
}

output "iam_role_arn" {
  description = "ARN da IAM Role criada"
  value       = aws_iam_role.ec2_s3_access_role.arn
}

output "subnet_details" {
  description = "Detalhes da subnet utilizada"
  value = {
    subnet_id         = data.aws_subnet.selected_public.id
    availability_zone = data.aws_subnet.selected_public.availability_zone
    vpc_id            = data.aws_vpc.default.id
  }
}