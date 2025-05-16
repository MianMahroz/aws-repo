resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/files/", "**")

  bucket       = var.bucket_name
  key          = each.value
  source       = "${path.module}/files/${each.value}"
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1], "text/plain")
  etag         = filemd5("${path.module}/files/${each.value}")
}

locals {
  mime_types = {
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "svg"  = "image/svg+xml",
    "json" = "application/json"
  }
}