terraform {
    backend "s3" {
    bucket         = "resume-website-terraform-state-16-08-2024"
    key            = "/resume-website-backend/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    
    }
}

