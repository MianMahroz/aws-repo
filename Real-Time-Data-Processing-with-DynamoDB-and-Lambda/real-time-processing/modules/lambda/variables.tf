variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  type        = string
}

variable "lambda_source_dir" {
  description = "Path to the Lambda function source code"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}