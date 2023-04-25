variable "snsTopicName" {
  default = "my-sns-topic"
}

variable "queueName" {
  default = "my-sns-queue"
}

variable "eventBusName" {
  default = "my-event-bus"
}

variable "ruleName" {
  default = "my-rule"
}

# awslocal sns create-topic --name my-sns-topic
resource "aws_sns_topic" "snsTopic" {
  name = var.snsTopicName
}

# return the ARN of the topic
output "snsTopicArn" {
  value = aws_sns_topic.snsTopic.arn
}


# awslocal sqs create-queue --queue-name my-sns-queue
resource "aws_sqs_queue" "myQueue" {
  name = var.queueName
}

# return the ARN of the queue
output "queueArn" {
  value = aws_sqs_queue.myQueue.arn
}

# return the URL of the queue
output "queueUrl" {
  value = aws_sqs_queue.myQueue.id
}

# awslocal sns subscribe \
#   --topic-arn ${TOPIC_ARN} \
#   --protocol sqs \
#   --notification-endpoint ${QUEUE_ARN}
resource "aws_sns_topic_subscription" "mySubscription" {
  depends_on = [
    aws_sns_topic.snsTopic,
    aws_sqs_queue.myQueue
  ]

  topic_arn = aws_sns_topic.snsTopic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.myQueue.arn
}

# awslocal events create-event-bus --name my-event-bus
resource "aws_cloudwatch_event_bus" "myEventBus" {
  depends_on = [
    aws_sns_topic_subscription.mySubscription
  ]

  name = var.eventBusName
}

# awslocal events put-rule \
#   --name my-rule \
#   --event-bus-name my-event-bus \
#   --event-pattern '{"source":["my-application"],"detail-type": ["myDetailType"]}'
resource "aws_cloudwatch_event_rule" "myRule" {
  depends_on = [
    aws_cloudwatch_event_bus.myEventBus
  ]

  name           = var.ruleName
  event_bus_name = aws_cloudwatch_event_bus.myEventBus.name

  event_pattern = jsonencode({
    source = [
      "my-application"
    ],
    detail-type = [
      "myDetailType"
    ]
  })
}

# return rule
output "myRule" {
  value = aws_cloudwatch_event_rule.myRule
}

# awslocal events put-targets \
#   --rule my-rule \
#   --event-bus-name my-event-bus \
#   --targets "Id"="1","Arn"="${TOPIC_ARN}"
resource "aws_cloudwatch_event_target" "myTarget" {
  depends_on = [
    aws_cloudwatch_event_rule.myRule
  ]

  rule           = aws_cloudwatch_event_rule.myRule.name
  event_bus_name = aws_cloudwatch_event_bus.myEventBus.name
  arn            = aws_sns_topic.snsTopic.arn
  target_id      = "1"
}

# return target
output "myTarget" {
  value = aws_cloudwatch_event_target.myTarget
}
