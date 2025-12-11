provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "assets" {
  bucket = "company-dev-assets-eucentral1-williams"
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
output "aws_eucentral1_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}