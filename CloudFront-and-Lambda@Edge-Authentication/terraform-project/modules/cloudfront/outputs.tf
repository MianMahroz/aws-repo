output "website_url" {
  description = "URL of the website"
  value       = "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.id
}