output "files" {
  description = "Map of uploaded website files"
  value       = aws_s3_object.website_files
}