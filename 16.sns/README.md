# [Simple Notification Service (SNS)](https://docs.localstack.cloud/user-guide/aws/sns/)

See [Amazon Simple Notification Service](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)

## 1. Using AWS CLI

### 1.1 Create a SNS topic

```sh
# Creates a topic to which notifications can be published (https://docs.aws.amazon.com/cli/latest/reference/sns/create-topic.html)
awslocal sns create-topic --name test-topic

TOPIC_ARN=$(awslocal sns list-topics \
    --query "Topics[?contains(TopicArn, 'test-topic')].TopicArn" \
    --output text)
```

### 1.2 Set the SNS topic attribute using the SNS topic

```sh
# Allows a topic owner to set an attribute of the topic to a new value (https://docs.aws.amazon.com/cli/latest/reference/sns/set-topic-attributes.html)
awslocal sns set-topic-attributes \
    --topic-arn ${TOPIC_ARN} \
    --attribute-name DisplayName \
    --attribute-value MyTopicDisplayName
```

### 1.3 List all the SNS topics

```sh
# Returns a list of the requester's topics (https://docs.aws.amazon.com/cli/latest/reference/sns/list-topics.html)
awslocal sns list-topics
```

### 1.4 Get attributes for a single SNS topic

```sh
# Returns all of the properties of a topic (https://docs.aws.amazon.com/cli/latest/reference/sns/get-topic-attributes.html)
awslocal sns get-topic-attributes --topic-arn ${TOPIC_ARN}
```

### 1.5 Publish messages to SNS topic

```sh
# Sends a message to an Amazon SNS topic (https://docs.aws.amazon.com/cli/latest/reference/sns/publish.html)
awslocal sns publish --topic-arn ${TOPIC_ARN} --message "Hello World"
```

### 1.6 Subscribe to the SNS topic

```sh
# Subscribes an endpoint to an Amazon SNS topic (https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html)
SUBS_ARN=$(awslocal sns subscribe \
    --topic-arn ${TOPIC_ARN} \
    --protocol email \
    --notification-endpoint test@gmail.com \
    --output text)
```

### 1.7 Set SNS Subscription attributes

```sh
# Allows a subscription owner to set an attribute of the subscription to a new value (https://docs.aws.amazon.com/cli/latest/reference/sns/set-subscription-attributes.html)
awslocal sns set-subscription-attributes \
    --subscription-arn ${SUBS_ARN} \
    --attribute-name RawMessageDelivery \
    --attribute-value true
```

### 1.8 List all the SNS subscriptions

```sh
# Returns a list of the requester's subscriptions (https://docs.aws.amazon.com/cli/latest/reference/sns/list-subscriptions.html)
awslocal sns list-subscriptions
```

### 1.9 Unsubscribe from SNS topic

```sh
# Deletes a subscription (https://docs.aws.amazon.com/cli/latest/reference/sns/unsubscribe.html)
awslocal sns unsubscribe --subscription-arn ${SUBS_ARN}
```

### 1.10 Delete SNS topic

```sh
# Deletes a topic and all its subscriptions (https://docs.aws.amazon.com/cli/latest/reference/sns/delete-topic.html)
awslocal sns delete-topic --topic-arn ${TOPIC_ARN}
```

## 2. Using terraform

- [Resource: aws_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)

### 2.1 Create a SNS topic and Subscribe to the SNS topic

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List all the SNS topics

```sh
awslocal sns list-topics
```

### 2.3 Publish messages to SNS topic

```sh
TOPIC_ARN=$(terraform output -raw mytopic)
awslocal sns publish --topic-arn ${TOPIC_ARN} --message "Hello World"
```

### 2.4 Unsubscribe from SNS topic and Delete SNS topic

```sh
terraform destroy -auto-approve
```
