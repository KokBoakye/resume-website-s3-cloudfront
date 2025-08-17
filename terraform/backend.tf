terraform {
    backend "s3" {
    bucket         = "resume-website-terraform-state-16-08-2024"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    
    }
}

# I was hoping to see the terraform state locking argument. Since the use of DynamoDB is deprecated, you would have used the `use_lockfile` argument to achieve that result.
# More so, please desist from putting the terraform.tfstate file in the root of the s3 bucket. It should be placed in a folder. 
