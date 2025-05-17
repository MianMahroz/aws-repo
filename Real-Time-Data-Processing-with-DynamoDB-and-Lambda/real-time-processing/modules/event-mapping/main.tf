resource "aws_lambda_event_source_mapping" "dynamodb_stream" {
  event_source_arn  = var.dynamodb_stream_arn
  function_name     = var.lambda_function_arn
  starting_position = "LATEST"
  batch_size        = var.batch_size
  enabled           = true
}