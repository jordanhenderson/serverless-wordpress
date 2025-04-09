resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  architectures = var.architectures

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  source_code_hash = var.source_code_hash

  layers = var.layer_arns

  environment {
    variables = var.environment_variables
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [1] : []
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }

  depends_on = [aws_s3_object.lambda_zip[0]]
}

resource "aws_lambda_function_url" "url" {
  count              = var.enable_function_url ? 1 : 0
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

resource "aws_s3_object" "lambda_zip" {
  count = var.local_zip_path != "" ? 1 : 0

  bucket = var.s3_bucket
  key    = var.s3_key
  source = var.local_zip_path
  etag   = filemd5(var.local_zip_path)
}