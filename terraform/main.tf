resource "aws_s3_bucket" "resume_website" {
  bucket = "kwabena-resume-website-15-08-2024"
  


  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Kwabena-Resume-Website"
  }
}

# resource "aws_s3_bucket_policy" "website_bucket_policy" {
#   bucket = aws_s3_bucket.resume_website.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = "*"
         
#         Action = [
#           "s3:PutObject"
         
#         ]
#         Resource = "${aws_s3_bucket.resume_website.arn}/*"
#       }
#     ]
#   })
# }

# resource "aws_s3_bucket_public_access_block" "resume_website" {
#   bucket = aws_s3_bucket.resume_website.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

resource "aws_cloudfront_origin_access_identity" "resume_website_oai" {
  comment = "OAI for Resume Website"
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.resume_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.resume_website_oai.iam_arn
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.resume_website.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "resume_website_distribution" {
  origin {
    domain_name = aws_s3_bucket.resume_website.bucket_regional_domain_name
    origin_id   = "resume_website_origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.resume_website_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "resume_website_origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}