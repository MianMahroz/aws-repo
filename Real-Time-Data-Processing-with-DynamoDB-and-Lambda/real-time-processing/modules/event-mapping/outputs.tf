output "event_mapping_uuid" {
  description = "UUID of the event source mapping"
  value       = aws_lambda_event_source_mapping.dynamodb_stream.uuid
}