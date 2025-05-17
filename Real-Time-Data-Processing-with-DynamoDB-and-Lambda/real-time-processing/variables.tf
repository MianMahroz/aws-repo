variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "RealTimeDataTable"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "DataProcessor"
}

variable "event_batch_size" {
  description = "Number of records to process in each Lambda invocation"
  type        = number
  default     = 100
}