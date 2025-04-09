module "wordpress-serverless" {
  source            = "./modules/lambda"

  function_name     = "wordpress-serverless"
  runtime           = "provided.al2" # must be al2, limitation is on bref's side
  handler           = "index.php"
  memory_size       = 1024
  timeout           = 28

  s3_bucket         = "uc-terraform"
  s3_key            = "lambda/wordpress-serverless.zip"
  source_code_hash  = filebase64sha256("../../dist/lambda.zip")

  layer_arns = [
    "arn:aws:lambda:ap-southeast-2:534081306603:layer:arm-php-84-fpm:19"
  ]

  environment_variables = {

  }

  enable_function_url = true
  local_zip_path = "../../dist/lambda.zip"
}