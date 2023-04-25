# [EventBridge](https://docs.localstack.cloud/references/coverage/coverage_events/)

See [Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)

## 1. Using AWS CLI

### 1.1 Create sns topic and sqs queue

```sh
# Create SNS topic
awslocal sns create-topic --name my-sns-topic

# Get SNS topic arn
TOPIC_ARN=$(awslocal sns \
  list-topics \
  --query 'Topics[?contains(TopicArn, `my-sns-topic`)].TopicArn' \
  --output text)

# Create SQS queue
awslocal sqs create-queue --queue-name my-sns-queue

# Get SQS queue url
QUEUE_URL=$(awslocal sqs \
  get-queue-url \
  --queue-name my-sns-queue \
  --output text)

# Get SQS queue arn
QUEUE_ARN=$(awslocal sqs \
  get-queue-attributes \
  --queue-url ${QUEUE_URL} \
  --attribute-names QueueArn \
  --query Attributes.QueueArn \
  --output text)
echo $TOPIC_ARN, $QUEUE_URL, $QUEUE_ARN

# Subscribe SQS queue to SNS topic
awslocal sns subscribe \
  --topic-arn ${TOPIC_ARN} \
  --protocol sqs \
  --notification-endpoint ${QUEUE_ARN}
```

### 1.2 Create an event bus

```sh
# Creates a new event bus within your account (https://docs.aws.amazon.com/cli/latest/reference/events/create-event-bus.html)
awslocal events create-event-bus --name my-event-bus

# Lists all the event buses in your account, including the default event bus (https://docs.aws.amazon.com/cli/latest/reference/events/list-event-buses.html)
awslocal events list-event-buses

# Displays details about an event bus in your account (https://docs.aws.amazon.com/cli/latest/reference/events/describe-event-bus.html)
awslocal events describe-event-bus --name my-event-bus
```

### 1.3 Create a Rule

- If you omit --event-bus-name, the default event bus is used

```sh
# Creates or updates the specified rule (https://docs.aws.amazon.com/cli/latest/reference/events/put-rule.html)
awslocal events put-rule \
  --name my-rule \
  --event-bus-name my-event-bus \
  --event-pattern '{"source":["my-application"],"detail-type": ["myDetailType"]}'
  
# Lists your Amazon EventBridge rules (https://docs.aws.amazon.com/cli/latest/reference/events/list-rules.html)
awslocal events list-rules --event-bus-name my-event-bus

# Describes the specified rule (https://docs.aws.amazon.com/cli/latest/reference/events/describe-rule.html)
awslocal events describe-rule --name my-rule --event-bus-name my-event-bus
```

### 1.4 Create a target

- If you omit --event-bus-name, the default event bus is used

```sh
# Adds the specified targets to the specified rule (https://docs.aws.amazon.com/cli/latest/reference/events/put-targets.html)
awslocal events put-targets \
  --rule my-rule \
  --event-bus-name my-event-bus \
  --targets "Id"="1","Arn"="${TOPIC_ARN}"

# Lists the targets assigned to the specified rule (https://docs.aws.amazon.com/cli/latest/reference/events/list-targets-by-rule.html)
awslocal events list-targets-by-rule \
  --rule my-rule \
  --event-bus-name my-event-bus
```

### 1.5 put events

- Must specify the event bus name

```sh
cat << EOF | tee /tmp/event.json
[
  {
    "EventBusName": "my-event-bus",
    "Time": "2022-04-12T13:00:00Z",
    "Source": "my-application",
    "Resources": ["resource-1"],
    "DetailType": "myDetailType",
    "Detail": "{\"key1\": \"value1\", \"key2\": \"value2\"}"
  }
]
EOF

# Sends custom events to Amazon EventBridge so that they can be matched to rules (https://docs.aws.amazon.com/cli/latest/reference/events/put-events.html)
awslocal events put-events --entries file:///tmp/event.json
```

### 1.6 Check a message in SQS queue

```sh
awslocal sqs receive-message --queue-url ${QUEUE_URL} --wait-time-seconds 10
```

### 1.7 Clean up

```sh
# delete the sns topic
SUBS_ARN=$(awslocal sns list-subscriptions \
  --query 'Subscriptions[?Endpoint==`'${QUEUE_ARN}'`].SubscriptionArn' \
  --output text)
awslocal sns unsubscribe --subscription-arn ${SUBS_ARN}
awslocal sns delete-topic --topic-arn ${TOPIC_ARN}

# delete the sqs
awslocal sqs delete-queue --queue-url ${QUEUE_URL}

# Removes the specified targets from the specified rule (https://docs.aws.amazon.com/cli/latest/reference/events/remove-targets.html)
awslocal events remove-targets --rule my-rule --ids 0 1
awslocal events list-targets-by-rule --rule my-rule --event-bus-name my-event-bus

# Deletes the specified rule (https://docs.aws.amazon.com/cli/latest/reference/events/delete-rule.html)
awslocal events delete-rule --name my-rule
awslocal events list-rules --event-bus-name my-event-bus

# Deletes the specified custom event bus or partner event bus (https://docs.aws.amazon.com/cli/latest/reference/events/delete-event-bus.html)
awslocal events delete-event-bus --name my-event-bus
awslocal events list-event-buses
```

## 2. Using terraform

- [Resource: aws_cloudwatch_event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus)
- [Resource: aws_cloudwatch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)
- [Resource: aws_cloudwatch_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)

### 2.1 Create a event bus, rule, target

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List all event-bus, rule and target

```sh
awslocal events list-event-buses
awslocal events list-rules \
  --event-bus-name my-event-bus
awslocal events list-targets-by-rule \
  --rule my-rule \
  --event-bus-name my-event-bus
```

### 2.3 put events

- Must specify the event bus name

```sh
cat << EOF | tee /tmp/event.json
[
  {
    "EventBusName": "my-event-bus",
    "Time": "2022-04-12T13:00:00Z",
    "Source": "my-application",
    "Resources": ["resource-1"],
    "DetailType": "myDetailType",
    "Detail": "{\"key1\": \"value1\", \"key2\": \"value2\"}"
  }
]
EOF

# Sends custom events to Amazon EventBridge so that they can be matched to rules (https://docs.aws.amazon.com/cli/latest/reference/events/put-events.html)
awslocal events put-events --entries file:///tmp/event.json
```

### 2.4 Check a message in SQS queue

```sh
awslocal sqs receive-message --queue-url ${QUEUE_URL} --wait-time-seconds 10
```

### 2.5 Delete the event bus, rule, target

```sh
terraform destroy -auto-approve
```
