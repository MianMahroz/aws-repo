output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "origin_access_identity_path" {
  description = "Path of the origin access identity"
  value       = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
}