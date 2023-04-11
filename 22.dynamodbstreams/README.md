# [dynamodbstreams](https://docs.localstack.cloud/references/coverage/coverage_dynamodbstreams/)

See [DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)

## 1. Create DynamoDB table

```sh
# Create DynamoDB table
awslocal dynamodb create-table \
  --table-name example-table \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

## 2. Enable DynamoDB stream

```sh
# Enable DynamoDB stream
awslocal dynamodb update-table \
  --table-name example-table \
  --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES
```

## 3. Get Stream Record

```sh
# list all DynamoDB Streams
STREAM_ARN=$(awslocal dynamodbstreams list-streams \
  --query 'Streams[0].StreamArn' \
  --output text)

# Get Shard ID
SHARD_ID=$(awslocal dynamodbstreams describe-stream \
  --stream-arn ${STREAM_ARN} \
  --query 'StreamDescription.Shards[0].ShardId' \
  --output text)

SHARD_ITER=$(awslocal dynamodbstreams get-shard-iterator \
  --stream-arn ${STREAM_ARN} \
  --shard-id ${SHARD_ID} \
  --shard-iterator-type TRIM_HORIZON \
  --query 'ShardIterator' \
  --output text)

# Get stream record
awslocal dynamodbstreams get-records \
  --shard-iterator ${SHARD_ITER}
```

## 4. list all dynomodb tables

```sh
# list all dynomodb tables
awslocal dynamodb list-tables
```

## 5. Clean up

```sh
# delete table
awslocal dynamodb delete-table --table-name example-table
```
