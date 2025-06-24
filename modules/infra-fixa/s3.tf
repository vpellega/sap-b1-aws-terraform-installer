resource "aws_s3_bucket" "sapb1_installer" {
  bucket = "sapb1-installer"
  tags = {
    Name = "${var.project_name}-${var.environment}-cf"
  }
}