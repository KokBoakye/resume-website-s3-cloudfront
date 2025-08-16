output "s3_endpoint" {
  description = "The S3 endpoint for the resume website"
  value       = aws_s3_bucket.resume_website.website_endpoint
}

output "cloudfront_url" {
  description = "The CloudFront URL for the resume website"
  value       = aws_cloudfront_distribution.resume_website_distribution.domain_name
}
