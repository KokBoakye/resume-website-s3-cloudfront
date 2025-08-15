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

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.resume_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
         
        Action = [
          "s3:PutObject"
         
        ]
        Resource = "${aws_s3_bucket.resume_website.arn}/*"
      }
    ]
  })
}