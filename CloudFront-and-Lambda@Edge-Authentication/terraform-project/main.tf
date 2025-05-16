terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "website_files" {
  source = "./modules/website-files"
  bucket_name = module.s3_website.bucket_name
}

module "lambda_edge" {
  source        = "./modules/lambda-edge"
  function_name = "cloudfront-auth"
  runtime       = "nodejs18.x"
}

module "s3_website" {
  source      = "./modules/s3-website"
  bucket_name = "${var.project_name}-website-${random_id.this.hex}"
  
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  s3_bucket_regional_domain_name = module.s3_website.regional_domain_name
  origin_access_identity_path    = module.s3_website.origin_access_identity_path
  lambda_edge_arn     = module.lambda_edge.qualified_arn
  
}

resource "random_id" "this" {
  byte_length = 8
}