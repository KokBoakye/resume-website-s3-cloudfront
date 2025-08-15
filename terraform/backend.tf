terraform {
    backend "s3" {
    bucket         = "resume-website-terraform-state-15-08-2024"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "kwabena-resume-website-terraform-lock"
    }
}