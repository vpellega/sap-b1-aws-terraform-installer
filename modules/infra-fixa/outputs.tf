output "cloudfront_domain_name" {
  description = "URL pública do CloudFront"
  value       = aws_cloudfront_distribution.sapb1_distribution.domain_name
}