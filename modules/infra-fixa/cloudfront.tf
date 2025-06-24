resource "aws_cloudfront_origin_access_control" "oac_s3" {
  name                              = "sapb1-oac"
  description                       = "OAC para CloudFront acessar o bucket sapb1-installer"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "sapb1_distribution" {
  enabled             = true
  default_root_object = ""

  origin {
    domain_name = "${aws_s3_bucket.sapb1_installer.id}.s3.amazonaws.com"
    origin_id   = "S3-${aws_s3_bucket.sapb1_installer.id}"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac_s3.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.sapb1_installer.id}"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # logging_config {
  #   bucket          = "${var.bucket_name}.s3.amazonaws.com"
  #   prefix          = "logs/cloudfront/"
  #   include_cookies = false
  # }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-cf"
  }
}