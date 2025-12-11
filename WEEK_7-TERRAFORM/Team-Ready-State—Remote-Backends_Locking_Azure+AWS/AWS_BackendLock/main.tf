terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    # Values supplied at init
    # bucket         = "tfstate-williams-prod"
    # key            = "envs/prod/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform_state_lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "demo" {
  bucket = "williams-demo-bucket-${random_id.suffix.hex}"
}

output "demo_bucket_name" {
  value = aws_s3_bucket.demo.bucket
}