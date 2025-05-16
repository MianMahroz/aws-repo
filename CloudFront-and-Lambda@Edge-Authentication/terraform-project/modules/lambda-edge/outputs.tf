output "qualified_arn" {
  description = "Qualified ARN of the Lambda function (with version)"
  value       = aws_lambda_function.this.qualified_arn
}

output "version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.this.version
}