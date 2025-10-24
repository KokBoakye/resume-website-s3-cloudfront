# resource "aws_s3_bucket" "resume_website" {
#   bucket = "kwabena-resume-website-25-10-2025"

#   force_destroy = true


#   tags = {
#     Name = var.project_name
#   }
# }



# resource "aws_cloudfront_origin_access_control" "resume_website_oac" {
#   name                              = "resume-website-oac"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
#   description                       = "OAC for Resume Website"
# }

# data "aws_iam_policy_document" "origin_bucket_policy" {
#   statement {
#     sid    = "AllowCloudFrontServicePrincipalReadWrite"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:PutObject",
#     ]

#     resources = [
#       "${aws_s3_bucket.resume_website.arn}/*",
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.resume_website_distribution.arn]
#     }
#   }
# }


# resource "aws_s3_bucket_policy" "website_bucket_policy" {
#   bucket = aws_s3_bucket.resume_website.id

#   policy = data.aws_iam_policy_document.origin_bucket_policy.json
# }


# resource "aws_wafv2_web_acl" "resume_website_waf" {
#   name        = "resume-website-waf"
#   description = "WAF for Resume Website"
#   scope       = "CLOUDFRONT"

#   default_action {
#     allow {}
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "resumeWebsiteWAF"
#     sampled_requests_enabled   = true
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesCommonRuleSet"
#     priority = 1
#     override_action {
#       none {}
#     }
#     statement {
#       managed_rule_group_statement {
#         vendor_name = "AWS"
#         name        = "AWSManagedRulesCommonRuleSet"
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "commonRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }
# }


# resource "aws_cloudfront_distribution" "resume_website_distribution" {
#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   origin {
#     domain_name              = aws_s3_bucket.resume_website.bucket_regional_domain_name
#     origin_access_control_id = aws_cloudfront_origin_access_control.resume_website_oac.id
#     origin_id                = "resume_website_origin"


#   }

#   default_cache_behavior {
#     target_origin_id       = "resume_website_origin"
#     allowed_methods        = ["GET", "HEAD"]
#     cached_methods         = ["GET", "HEAD"]
#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl     = 0
#     default_ttl = 86400
#     max_ttl     = 31536000
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   web_acl_id = aws_wafv2_web_acl.resume_website_waf.arn

#   tags = {
#     Name = var.project_name
#   }
# }



# # resource "aws_route53_zone" "resume_website" {
# #   name = "solaris.com"
# # }

# # resource "aws_route53_record" "resume_website_alias" {
# #   zone_id = aws_route53_zone.resume_website.zone_id
# #   name    = "www.solaris.com"
# #   type    = "A"
# #   alias {
# #     name                   = aws_cloudfront_distribution.resume_website_distribution.domain_name
# #     zone_id                = aws_cloudfront_distribution.resume_website_distribution.hosted_zone_id
# #     evaluate_target_health = true
# #   }
# # }

# # resource "aws_acm_certificate" "resume_website_cert" {

# #   domain_name       = "www.solaris.com"  # <--- should be your own domain
# #   validation_method = "DNS"

# #   lifecycle {
# #     create_before_destroy = true
# #   }
# # }

# # resource "aws_route53_record" "resume_website_cert_validation" {
# #   for_each = {
# #     for dvo in aws_acm_certificate.resume_website_cert.domain_validation_options : dvo.domain_name => {
# #       name   = dvo.resource_record_name
# #       type   = dvo.resource_record_type
# #       record = dvo.resource_record_value
# #       zone_id = aws_route53_zone.resume_website.zone_id
# #     }
# #   }

# #   name    = each.value.name
# #   type    = each.value.type
# #   zone_id = each.value.zone_id
# #   records = [each.value.record]
# #   ttl     = 60
# # }

# # resource "aws_acm_certificate_validation" "resume_website_cert_validation" {
# #   certificate_arn         = aws_acm_certificate.resume_website_cert.arn
# #   validation_record_fqdns = [for record in aws_route53_record.resume_website_cert_validation : record.fqdn]
# # }
