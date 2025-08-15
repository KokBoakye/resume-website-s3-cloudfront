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
