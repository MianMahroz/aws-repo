variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "origin_access_identity_path" {
  description = "Path of the origin access identity"
  type        = string
}

variable "lambda_edge_arn" {
  description = "ARN of the Lambda@Edge function"
  type        = string
}

