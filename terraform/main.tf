resource "s3_bucket" "resume_website" {
  bucket = "kwabena-resume-website-15-08-2024"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Kwabena's Resume Website"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.resume_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<YourOIDCRoleName>"
        }
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.resume_website.arn}/*"
      }
    ]
  })
}