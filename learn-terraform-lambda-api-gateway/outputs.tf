output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

# Create the Lambda function
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}

# Create an HTTP API with API Gateway
output "base_url" {
  description = "Base URL for API Gateway stage."

  # [Recommended URL format](https://docs.localstack.cloud/user-guide/aws/apigateway/#recommended-url-format)
  value = "http://${aws_api_gateway_rest_api.lambda.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_deployment.hello_world.stage_name}/${aws_api_gateway_resource.hello_world.path_part}"
}
