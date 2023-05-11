output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

# Create the Lambda function
output "get-tips-lambda" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.get-tips-lambda.function_name
}

output "post-tips-lambda" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.post-tips-lambda.function_name
}

# Create an HTTP API with API Gateway
output "base_url" {
  description = "Base URL for API Gateway stage."

  # [Recommended URL format](https://docs.localstack.cloud/user-guide/aws/apigateway/#recommended-url-format)
  value = "http://${aws_api_gateway_rest_api.codingtips-api-gateway.id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_deployment.codingtips-api-gateway-deployment.stage_name}/api"
  # value = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.invoke_url}/api"
  # base_url = "https://2vnpd4p34w.execute-api.us-east-1.amazonaws.com/default/api"
}
