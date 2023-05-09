// DynamoDB TABLES
resource "aws_dynamodb_table" "dogs" {
  name           = "dogs"
  read_capacity  = "20"
  write_capacity = "20"
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
}

// Kinesis stream
resource "aws_kinesis_stream" "caught_dogs_stream" {
  name             = "caughtDogs"
  shard_count      = 1
  retention_period = 30

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kinesis_stream" "hot_dogs_stream" {
  name             = "hotDogs"
  shard_count      = 1
  retention_period = 30

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kinesis_stream" "eaten_hot_dogs_stream" {
  name             = "eatenHotDogs"
  shard_count      = 1
  retention_period = 30

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

# Create and upload Lambda function archive
resource "null_resource" "dog_catcher_lambda" {
  provisioner "local-exec" {
    command = <<-EOT
      CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ${var.tmpDir}/dogCatcher/main ./dogCatcher/main.go
      zip -j ${var.tmpDir}/dogCatcher.zip ${var.tmpDir}/dogCatcher/main
    EOT
  }
}

resource "aws_lambda_function" "dog_catcher_lambda" {
  depends_on = [null_resource.dog_catcher_lambda]

  function_name = "dogCatcher"
  filename      = "${var.tmpDir}/dogCatcher.zip"
  handler       = "main"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = var.goRuntime
  timeout       = 5
  memory_size   = 128
}

resource "null_resource" "dog_processor_lambda" {
  provisioner "local-exec" {
    command = <<-EOT
      CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ${var.tmpDir}/dogProcessor/main ./dogProcessor/main.go
      zip -j ${var.tmpDir}/dogProcessor.zip ${var.tmpDir}/dogProcessor/main
    EOT
  }
}

resource "aws_lambda_function" "dog_processor_lambda" {
  depends_on = [null_resource.dog_processor_lambda]

  function_name = "dogProcessor"
  filename      = "${var.tmpDir}/dogProcessor.zip"
  handler       = "main"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = var.goRuntime
  timeout       = 5
  memory_size   = 128
}

resource "null_resource" "hot_dog_despatcher_lambda" {
  provisioner "local-exec" {
    command = <<-EOT
      CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ${var.tmpDir}/hotDogDespatcher/main ./hotDogDespatcher/main.go
      zip -j ${var.tmpDir}/hotDogDespatcher.zip ${var.tmpDir}/hotDogDespatcher/main
    EOT
  }
}

resource "aws_lambda_function" "hot_dog_despatcher_lambda" {
  depends_on = [null_resource.hot_dog_despatcher_lambda]

  function_name = "hotDogDespatcher"
  filename      = "${var.tmpDir}/hotDogDespatcher.zip"
  handler       = "main"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = var.goRuntime
  timeout       = 5
  memory_size   = 128
}

// Lambda Role
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

// LAMBDA TRIGGERS
resource "aws_lambda_event_source_mapping" "dog_processor_trigger" {
  event_source_arn              = aws_kinesis_stream.caught_dogs_stream.arn
  function_name                 = "dogProcessor"
  batch_size                    = 1
  starting_position             = "LATEST"
  enabled                       = true
  maximum_record_age_in_seconds = 604800
}

resource "aws_lambda_event_source_mapping" "dog_processor_trigger_2" {
  event_source_arn              = aws_kinesis_stream.eaten_hot_dogs_stream.arn
  function_name                 = "dogProcessor"
  batch_size                    = 1
  starting_position             = "LATEST"
  enabled                       = true
  maximum_record_age_in_seconds = 604800
}

resource "aws_lambda_event_source_mapping" "hot_dog_despatcher_trigger" {
  event_source_arn              = aws_kinesis_stream.hot_dogs_stream.arn
  function_name                 = "hotDogDespatcher"
  batch_size                    = 1
  starting_position             = "LATEST"
  enabled                       = true
  maximum_record_age_in_seconds = 604800
}
