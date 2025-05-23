output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.data_processor.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.data_processor.function_name
}