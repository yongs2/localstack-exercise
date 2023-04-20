variable "streamName" {
  default = "logtest"
}

variable "logGroupName" {
  default = "test"
}

variable "logStreamName" {
  default = "test"
}

variable "filterName" {
  default = "kinesis_test"
}

# awslocal kinesis create-stream --stream-name logtest --shard-count 1
resource "aws_kinesis_stream" "kinesis_stream" {
  name        = var.streamName
  shard_count = 1

  tags = {
    Environment = "test"
  }
}

output "kinesis_stream" {
  value = aws_kinesis_stream.kinesis_stream
}

# awslocal logs create-log-group --log-group-name test
resource "aws_cloudwatch_log_group" "log_group" {
  name = var.logGroupName

  tags = {
    Environment = "test"
  }
}

output "log_group" {
  value = aws_cloudwatch_log_group.log_group
}

# awslocal logs create-log-stream --log-group-name test --log-stream-name test
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.logStreamName
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

output "log_stream" {
  value = aws_cloudwatch_log_stream.log_stream
}

# awslocal logs put-subscription-filter \
#     --log-group-name "test" \
#     --filter-name "kinesis_test" \
#     --filter-pattern "" \
#     --destination-arn ${KINESIS_ARN} \
#     --role-arn "arn:aws:iam::000000000000:role/kinesis_role"
resource "aws_cloudwatch_log_subscription_filter" "log_subscription_filter" {
  name            = var.filterName
  log_group_name  = aws_cloudwatch_log_group.log_group.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.kinesis_stream.arn
  role_arn        = "arn:aws:iam::000000000000:role/kinesis_role"
}
