terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
  dynamodb_table_arn = module.dynamodb.table_arn
  dynamodb_stream_arn = module.dynamodb.stream_arn
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}

module "lambda" {
  source = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  lambda_role_arn = module.iam.lambda_role_arn
  lambda_source_dir = "${path.root}/lambda-functions/processor"
  environment_variables = {
    TABLE_NAME = var.dynamodb_table_name
    REGION     = var.aws_region
  }
}

module "event_mapping" {
  source = "./modules/event-mapping"
  lambda_function_arn = module.lambda.function_arn
  dynamodb_stream_arn = module.dynamodb.stream_arn
  batch_size = var.event_batch_size
}