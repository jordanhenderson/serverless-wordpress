output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "function_url" {
  value       = var.enable_function_url ? aws_lambda_function_url.url[0].function_url : null
  description = "Public Function URL (if enabled)"
}
