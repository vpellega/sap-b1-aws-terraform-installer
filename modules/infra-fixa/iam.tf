resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.sapb1_installer.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.sapb1_installer.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.sapb1_distribution.arn
          }
        }
      },
      {
        Sid    = "AllowCloudFrontLogging"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.sapb1_installer.arn}/logs/cloudfront/*"
      },
      {
        Sid    = "AllowAccessForIssuer"
        Effect = "Allow",
        Principal = {
          AWS = var.caller_identity_arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutBucketPolicy"
        ],
        Resource = [
          "${aws_s3_bucket.sapb1_installer.arn}",
          "${aws_s3_bucket.sapb1_installer.arn}/*"
        ]
      }
    ]
  })
}