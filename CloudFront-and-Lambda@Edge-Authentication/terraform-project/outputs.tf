output "website_url" {
  description = "URL of the website"
  value       = module.cloudfront.website_url
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_website.bucket_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}