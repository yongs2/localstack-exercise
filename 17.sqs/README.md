# [Simple Queue Service (SQS)](https://docs.localstack.cloud/user-guide/aws/sqs/)

See [Amazon Simple Queue Service](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html)

## 1. Using AWS CLI

### 1.1 Create a Queue

```sh
# Creates a new standard or FIFO queue (https://docs.aws.amazon.com/cli/latest/reference/sqs/create-queue.html)
awslocal sqs create-queue --queue-name sample-queue
```

### 1.2 List all the Queues

```sh
# Returns a list of your queues in the current region (https://docs.aws.amazon.com/cli/latest/reference/sqs/list-queues.html)
awslocal sqs list-queues
```

### 1.3 Get Queue URL

```sh
# Returns the URL of an existing Amazon SQS queue (https://docs.aws.amazon.com/cli/latest/reference/sqs/get-queue-url.html)
QUEUE_URL=$(awslocal sqs get-queue-url --queue-name sample-queue --output text)
echo "QUEUE_URL: $QUEUE_URL"
```

### 1.4 Send messages to Queue

```sh
# Delivers a message to the specified queue (https://docs.aws.amazon.com/cli/latest/reference/sqs/send-message.html)
awslocal sqs send-message --queue-url ${QUEUE_URL} --message-body test

# SQS Query API
curl "${QUEUE_URL}?Action=SendMessage&MessageBody=hello%2Fworld"
curl -s "${QUEUE_URL}?Action=SendMessage&MessageBody=hello%2Fworld%2fJSON" \
    -H "Accept: application/json" | jq .
```

### 1.5 Receive messages from Queue

```sh
# Retrieves one or more messages (up to 10), from the specified queue (https://docs.aws.amazon.com/cli/latest/reference/sqs/receive-message.html)
awslocal sqs receive-message --queue-url=${QUEUE_URL}

# SQS Query API
curl -s "http://localhost:4566/_aws/sqs/messages?QueueUrl=${QUEUE_URL}" \
    -H "Accept: application/json" | jq .
```

### 1.6 Delete Queue

```sh
# Deletes the queue specified by the QueueUrl , regardless of the queue's contents (https://docs.aws.amazon.com/cli/latest/reference/sqs/delete-queue.html)
awslocal sqs delete-queue --queue-url ${QUEUE_URL}
```

## 2. Using terraform

- [Resource: aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue)

### 2.1 Create a Queue

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Send messages to Queue

```sh
QUEUE_URL=$(terraform output -raw myqueue)
awslocal sqs send-message --queue-url ${QUEUE_URL} --message-body test

# SQS Query API
curl "${QUEUE_URL}?Action=SendMessage&MessageBody=hello%2Fworld"
curl -s "${QUEUE_URL}?Action=SendMessage&MessageBody=hello%2Fworld%2fJSON" \
    -H "Accept: application/json" | jq .
```

### 2.3 Receive messages from Queue

```sh
awslocal sqs receive-message --queue-url=${QUEUE_URL}

# SQS Query API
curl -s "http://localhost:4566/_aws/sqs/messages?QueueUrl=${QUEUE_URL}" \
    -H "Accept: application/json" | jq .
```

### 2.4 Delete Queue

```sh
terraform destroy -auto-approve
```
