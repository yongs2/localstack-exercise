# [Simple Notification Service (SNS)](https://docs.localstack.cloud/user-guide/aws/sns/)

See [Amazon Simple Notification Service](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)

## 1. Create a SNS topic

```sh
# Creates a topic to which notifications can be published (https://docs.aws.amazon.com/cli/latest/reference/sns/create-topic.html)
awslocal sns create-topic --name test-topic
```

## 2. Set the SNS topic attribute using the SNS topic

```sh
# Allows a topic owner to set an attribute of the topic to a new value (https://docs.aws.amazon.com/cli/latest/reference/sns/set-topic-attributes.html)
awslocal sns set-topic-attributes \
    --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic \
    --attribute-name DisplayName \
    --attribute-value MyTopicDisplayName
```

## 3. List all the SNS topics

```sh
# Returns a list of the requester's topics (https://docs.aws.amazon.com/cli/latest/reference/sns/list-topics.html)
awslocal sns list-topics
```

## 4. Get attributes for a single SNS topic

```sh
# Returns all of the properties of a topic (https://docs.aws.amazon.com/cli/latest/reference/sns/get-topic-attributes.html)
awslocal sns get-topic-attributes --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic
```

## 5. Publish messages to SNS topic

```sh
# Sends a message to an Amazon SNS topic (https://docs.aws.amazon.com/cli/latest/reference/sns/publish.html)
awslocal sns publish --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic --message "Hello World"
```

## 6. Subscribe to the SNS topic

```sh
# Subscribes an endpoint to an Amazon SNS topic (https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html)
SUBS_ARN=$(awslocal sns subscribe --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic --protocol email --notification-endpoint test@gmail.com --output text)
```

## 7. Set SNS Subscription attributes

```sh
# Allows a subscription owner to set an attribute of the subscription to a new value (https://docs.aws.amazon.com/cli/latest/reference/sns/set-subscription-attributes.html)
awslocal sns set-subscription-attributes \
    --subscription-arn ${SUBS_ARN} \
    --attribute-name RawMessageDelivery \
    --attribute-value true
```

## 8. List all the SNS subscriptions

```sh
# Returns a list of the requester's subscriptions (https://docs.aws.amazon.com/cli/latest/reference/sns/list-subscriptions.html)
awslocal sns list-subscriptions
```

## 9. Unsubscribe from SNS topic

```sh
# Deletes a subscription (https://docs.aws.amazon.com/cli/latest/reference/sns/unsubscribe.html)
awslocal sns unsubscribe --subscription-arn ${SUBS_ARN}
```

## 10. Delete SNS topic

```sh
# Deletes a topic and all its subscriptions (https://docs.aws.amazon.com/cli/latest/reference/sns/delete-topic.html)
awslocal sns delete-topic --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic
```
