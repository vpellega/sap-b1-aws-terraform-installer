output "s3_bucket_name" {
  description = "Nome do bucket S3 para o estado do Terraform."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB para o travamento do estado."
  value       = aws_dynamodb_table.terraform_state_lock.name
}
