# Create S3 bucket
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

# Create and upload Lambda function archive - get
data "archive_file" "get" {
  type = "zip"

  source_dir  = "${path.module}/get"
  output_path = "/tmp/get.zip"
}

resource "aws_s3_object" "get" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "get.zip"
  source = data.archive_file.get.output_path

  etag = filemd5(data.archive_file.get.output_path)
}

# Create the Lambda function - get-tips-lambda
resource "aws_lambda_function" "get-tips-lambda" {
  function_name = "get-tips-lambda"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.get.key

  runtime = "nodejs12.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.get.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

# Create and upload Lambda function archive - post
data "archive_file" "post" {
  type = "zip"

  source_dir  = "${path.module}/post"
  output_path = "/tmp/post.zip"
}

resource "aws_s3_object" "post" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "post.zip"
  source = data.archive_file.post.output_path

  etag = filemd5(data.archive_file.post.output_path)
}

# Create the Lambda function - post-tips-lambda
resource "aws_lambda_function" "post-tips-lambda" {
  function_name = "post-tips-lambda"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.post.key

  runtime = "nodejs12.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.post.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

# iam
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
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create DynamoDB
resource "aws_dynamodb_table" "codingtips-dynamodb-table" {
  name = "CodingTips"

  # Configure provisioned capacity
  read_capacity  = 5
  write_capacity = 5

  hash_key  = "Author"
  range_key = "Date"

  attribute {
    name = "Author"
    type = "S"
  }
  attribute {
    name = "Date"
    type = "N"
  }
}

# api-gateway
resource "aws_api_gateway_rest_api" "codingtips-api-gateway" {
  name        = "CodingTipsAPI"
  description = "API to access codingtips application"
  body        = data.template_file.codingtips_api_swagger.rendered
}

data "template_file" "codingtips_api_swagger" {
  template = file("swagger.yaml")

  vars = {
    get_lambda_arn  = aws_lambda_function.get-tips-lambda.invoke_arn
    post_lambda_arn = aws_lambda_function.post-tips-lambda.invoke_arn
  }
}

resource "aws_api_gateway_deployment" "codingtips-api-gateway-deployment" {
  rest_api_id = aws_api_gateway_rest_api.codingtips-api-gateway.id
  stage_name  = "default"
}
