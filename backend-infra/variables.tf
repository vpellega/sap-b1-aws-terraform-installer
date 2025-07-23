variable "s3_bucket_name" {
  description = "The globally unique name for the S3 bucket that will store the Terraform state."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name for the DynamoDB table used for state locking."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
