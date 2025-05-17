data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "data_processor" {
  function_name    = var.lambda_function_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = var.lambda_role_arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  timeout          = 30
  memory_size      = 256

  environment {
    variables = var.environment_variables
  }

  depends_on = [
    data.archive_file.lambda_zip
  ]
}