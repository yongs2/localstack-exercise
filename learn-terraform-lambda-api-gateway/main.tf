resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

# Create and upload Lambda function archive
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "/tmp/hello-world.zip"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}

# Create the Lambda function
resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello_world.key

  runtime = "nodejs12.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create an HTTP API with API Gateway
resource "aws_api_gateway_rest_api" "lambda" {
  name = "serverless_lambda_gw"
}

resource "aws_api_gateway_resource" "hello_world" {
  depends_on = [aws_api_gateway_rest_api.lambda]

  rest_api_id = aws_api_gateway_rest_api.lambda.id
  parent_id   = aws_api_gateway_rest_api.lambda.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello_world" {
  depends_on = [aws_api_gateway_resource.hello_world]

  rest_api_id   = aws_api_gateway_rest_api.lambda.id
  resource_id   = aws_api_gateway_resource.hello_world.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "hello_world" {
  depends_on = [aws_api_gateway_method.hello_world]

  rest_api_id = aws_api_gateway_rest_api.lambda.id
  resource_id = aws_api_gateway_resource.hello_world.id
  http_method = "GET"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "hello_world" {
  depends_on = [aws_api_gateway_method_response.hello_world]

  rest_api_id             = aws_api_gateway_rest_api.lambda.id
  resource_id             = aws_api_gateway_resource.hello_world.id
  http_method             = aws_api_gateway_method.hello_world.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_api_gateway_integration_response" "hello_world" {
  depends_on = [aws_api_gateway_integration.hello_world]

  rest_api_id = aws_api_gateway_rest_api.lambda.id
  resource_id = aws_api_gateway_resource.hello_world.id
  http_method = aws_api_gateway_method.hello_world.http_method
  status_code = aws_api_gateway_method_response.hello_world.status_code
  response_templates = {
    "application/json" = ""
  }
}

# awslocal apigateway create-deployment \
#   --rest-api-id <REST_API_ID> \
#   --stage-name test
resource "aws_api_gateway_deployment" "hello_world" {
  rest_api_id = aws_api_gateway_rest_api.lambda.id
  stage_name  = "hello"

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.hello_world.id,
      aws_api_gateway_method.hello_world.id,
      aws_api_gateway_integration.hello_world.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_api_gateway_rest_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.lambda.execution_arn}/*/*"
}
