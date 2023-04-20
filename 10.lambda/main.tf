variable "layerName" {
  default = "layer1"
}

variable "layer_content" {
  default = <<EOF
def util():
  print("Output from Lambda layer util function")
EOF
}

variable "tmpDir" {
  default = "/tmp"
}

variable "layerBaseDir" {
  default = "layer"
}

variable "layerFile" {
  default = "testlayer.py"
}

variable "functionName" {
  default = "func1"
}

variable "func_content" {
  default = <<EOF
def handler(*args, **kwargs):
  import testlayer; testlayer.util()
  print("Debug output from Lambda function")
EOF
}

variable "functionFile" {
  default = "testlambda.py"
}

# create function zip file
resource "local_file" "layerFile" {
  content  = var.layer_content
  filename = "${var.tmpDir}/${var.layerBaseDir}/${var.layerFile}"
}

data "archive_file" "layerZipFile" {
  depends_on = [
    local_file.layerFile
  ]
  type        = "zip"
  source_dir  = "${var.tmpDir}/${var.layerBaseDir}"
  output_path = "${var.tmpDir}/testlayer.zip"
}

# awslocal lambda publish-layer-version \
#     --layer-name layer1 \
#     --zip-file fileb:///tmp/testlayer.zip
resource "aws_lambda_layer_version" "layer1" {
  layer_name = var.layerName
  filename   = data.archive_file.layerZipFile.output_path
}

# return layer arn
output "layerArn" {
  value = aws_lambda_layer_version.layer1.arn
}

# role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# return role arn
output "roleArn" {
  value = aws_iam_role.lambda_role.arn
}

# create function zip file
resource "local_file" "functionFile" {
  content  = var.func_content
  filename = var.functionFile
}

data "archive_file" "testlambda" {
  depends_on = [
    local_file.functionFile
  ]
  type        = "zip"
  source_file = local_file.functionFile.filename
  output_path = "/tmp/testlambda.zip"
}

# awslocal lambda create-function \
#   --function-name func1 \
#   --runtime python3.8 \
#   --role arn:aws:iam::000000000000:role/lambda-role \
#   --handler testlambda.handler \
#   --timeout 30 \
#   --zip-file fileb:///tmp/testlambda.zip \
#   --layers ${LAYER_VER_ARN}
resource "aws_lambda_function" "func1" {
  filename      = data.archive_file.testlambda.output_path
  function_name = var.functionName
  role          = aws_iam_role.lambda_role.arn
  handler       = "testlambda.handler"
  runtime       = "python3.8"

  layers = [aws_lambda_layer_version.layer1.arn]
}

# return function arn
output "functionArn" {
  value = aws_lambda_function.func1.arn
}
