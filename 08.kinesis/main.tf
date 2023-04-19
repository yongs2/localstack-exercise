variable "name" {
  default = "Foo"
}

# awslocal kinesis create-stream --stream-name Foo
resource "aws_kinesis_stream" "test" {
  name             = var.name
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "test"
  }
}

output "stream" {
  value = aws_kinesis_stream.test
}
