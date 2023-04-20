variable "topicName" {
  default = "test-topic"
}

variable "displayName" {
  default = "MyTopicDisplayName"
}

# awslocal sns create-topic --name test-topic
# awslocal sns set-topic-attributes \
#     --topic-arn ${TOPIC_ARN} \
#     --attribute-name DisplayName \
#     --attribute-value MyTopicDisplayName
resource "aws_sns_topic" "mytopic" {
  name         = var.topicName
  display_name = var.displayName
}

# return topic arn
output "mytopic" {
  value = aws_sns_topic.mytopic.arn
}

# awslocal sns subscribe --topic-arn ${TOPIC_ARN} --protocol email --notification-endpoint test@gmail.com
# awslocal sns set-subscription-attributes \
#     --subscription-arn ${SUBS_ARN} \
#     --attribute-name RawMessageDelivery \
#     --attribute-value true
resource "aws_sns_topic_subscription" "mytopic_subscription" {
  topic_arn            = aws_sns_topic.mytopic.arn
  protocol             = "email"
  endpoint             = "test@gmail.com"
  raw_message_delivery = true
}

# return subscription arn
output "mytopic_subscription" {
  value = aws_sns_topic_subscription.mytopic_subscription.arn
}
