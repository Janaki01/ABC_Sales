resource "aws_lambda_function" "etl_lambda" {
  function_name = "etl-lambda-postgres-s3"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  timeout       = 60
#   memory_size   = 1024

  filename         = "../lambda/lambda_build/etl_lambda.zip"
  source_code_hash = filebase64sha256("../lambda/lambda_build/etl_lambda.zip")

  environment {
    variables = {
      DB_HOST   = aws_db_instance.postgres.address
      DB_PORT   = "5432"
      DB_NAME   = "postgres"
      DB_USER   = var.db_username
      DB_PASSWORD   = var.db_password
      S3_BUCKET = aws_s3_bucket.excel_output.bucket
    }
  }
}