# [Kinesis](https://docs.localstack.cloud/user-guide/aws/kinesis/)
    
See [Amazon Kinesis Data Streams](https://docs.aws.amazon.com/streams/latest/dev/introduction.html)

## 1. Create a Stream

```sh
# Create a Stream (https://docs.aws.amazon.com/cli/latest/reference/kinesis/create-stream.html)
awslocal kinesis create-stream --stream-name Foo

# Describes the specified Kinesis data stream (https://docs.aws.amazon.com/cli/latest/reference/kinesis/describe-stream.html)
awslocal kinesis describe-stream-summary --stream-name Foo
```

### 2. Verify the existence of your new stream

```sh
# Lists your Kinesis data streams (https://docs.aws.amazon.com/cli/latest/reference/kinesis/list-streams.html)
awslocal kinesis list-streams
```

## 3. Put a Record

```sh
# Writes a single data record into an Amazon Kinesis data stream (https://docs.aws.amazon.com/cli/latest/reference/kinesis/put-record.html)
awslocal kinesis put-record --stream-name Foo --partition-key 123 --data testdata
```

## 4. Get the Record

```sh
# Gets an Amazon Kinesis shard iterator (https://docs.aws.amazon.com/cli/latest/reference/kinesis/get-shard-iterator.html)
SHARD_ITERATOR=$(awslocal kinesis get-shard-iterator --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON --stream-name Foo --output text)

# Gets data records from a Kinesis data stream's shard (https://docs.aws.amazon.com/cli/latest/reference/kinesis/get-records.html)
awslocal kinesis get-records --shard-iterator ${SHARD_ITERATOR}

# base64 decode
awslocal kinesis get-records --shard-iterator ${SHARD_ITERATOR} --query Records[0].Data | base64 -d
```

## 5. Clean Up

```sh
# Deletes a Kinesis data stream and all its shards and data (https://docs.aws.amazon.com/cli/latest/reference/kinesis/delete-stream.html)
awslocal kinesis delete-stream --stream-name Foo

# Provides a summarized description of the specified Kinesis data stream without the shard list (https://docs.aws.amazon.com/cli/latest/reference/kinesis/describe-stream-summary.html)
awslocal kinesis describe-stream-summary --stream-name Foo
```
