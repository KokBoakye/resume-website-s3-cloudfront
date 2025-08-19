resource "aws_s3_bucket" "resume_website" {
  bucket = "kwabena-resume-website-16-08-2024"
  


  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Kwabena Resume Website"
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

resource "aws_wafv2_web_acl" "resume_website_waf" {
  name        = "resume-website-waf"
  description = "WAF for Resume Website"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                 = "resumeWebsiteWAF"
    sampled_requests_enabled    = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                 = "commonRuleSet"
      sampled_requests_enabled    = true
    }
  }
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
    acm_certificate_arn = aws_acm_certificate.resume_website_cert.arn
    ssl_support_method   = "sni-only"
  }

  web_acl_id = aws_wafv2_web_acl.resume_website_waf.arn
}

resource "aws_route53_zone" "resume_website" {
  name = "solaris.com"
}

resource "aws_route53_record" "resume_website_alias" {
  zone_id = aws_route53_zone.resume_website.zone_id
  name    = "www.solaris.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.resume_website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.resume_website_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "resume_website_cert" {
 
  domain_name       = "www.solaris.com"  # is solaris.com your own domain? This looks AI generated.
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "resume_website_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.resume_website_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
      zone_id = aws_route53_zone.resume_website.zone_id
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = each.value.zone_id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "resume_website_cert_validation" {
  certificate_arn         = aws_acm_certificate.resume_website_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.resume_website_cert_validation : record.fqdn]
}
