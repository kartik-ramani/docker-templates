provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "first_terraform" {
    bucket = var.bucket_name

    tags = {
        Name = "Terraform"
        Type = "Learning"
    }
}


// Public or Private
resource "aws_s3_bucket_acl" "name" {
  bucket = aws_s3_bucket.first_terraform.id
  acl = var.privacy_one
  
}
