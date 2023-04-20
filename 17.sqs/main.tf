variable "queueName" {
  default = "sample-queue"
}

# awslocal sqs create-queue --queue-name sample-queue
resource "aws_sqs_queue" "myqueue" {
  name = var.queueName

  tags = {
    Environment = "test"
  }
}

# return queue url
output "myqueue" {
  value = aws_sqs_queue.myqueue.id
}
