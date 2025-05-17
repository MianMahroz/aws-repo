variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "dynamodb_stream_arn" {
  description = "ARN of the DynamoDB table stream"
  type        = string
}

variable "batch_size" {
  description = "Number of records to process in each batch"
  type        = number
  default     = 100
}