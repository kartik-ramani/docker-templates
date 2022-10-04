provider "aws" {
  region = var.region
}


resource "aws_s3_bucket" "name" {
  bucket = var.bucket_name
  policy = templatefile("s3-policy.json" , { bucket = "www.${var.bucket_name}" })
  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules  = <<EOF
      [{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "index.html"
    }
    }]
    EOF
  }

  #     cors_rule {
  #     allowed_headers = ["*"]
  #     allowed_methods = ["PUT", "POST"]
  #     allowed_origins = ["https://s3-website-test.hashicorp.com"]
  #     expose_headers  = ["ETag"]
  #     max_age_seconds = 3000
  #   }
}


resource "aws_s3_bucket_acl" "protocol" {
  bucket = aws_s3_bucket.name.id
  acl = var.privacy_one
}



// S3 Object

resource "aws_s3_object" "indexfile" {
  bucket = aws_s3_bucket.name.id
  key = var.objectname
  source = "index.html"
}

resource "aws_s3_object" "errorfile" {
  bucket = aws_s3_bucket.name.id
  key = var.errorname
  source = "index.html"
}


resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = name.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


output "domain" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket_website_configuration.s3_bucket.website_domain
}