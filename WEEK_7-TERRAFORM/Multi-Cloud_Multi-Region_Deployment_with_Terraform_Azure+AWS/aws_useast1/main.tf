provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "assets" {
  bucket = "company-dev-assets-useast1-williams"
  tags = {
    project = "multicloud-foundation"
    owner   = "williams"
    env     = "dev"
  }
}

resource "aws_s3_bucket_versioning" "assets_versioning" {
  bucket = aws_s3_bucket.assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- Outputs ---
output "aws_useast1_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}