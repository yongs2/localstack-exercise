# [CloudWatch Logs](https://docs.localstack.cloud/user-guide/aws/logs/)

See [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)

## 1. Create a kinesis stream, a log group and stream

```sh
# create a kinesis stream
awslocal kinesis create-stream --stream-name logtest --shard-count 1

# create a log group (https://docs.aws.amazon.com/cli/latest/reference/logs/create-log-group.html)
awslocal logs create-log-group --log-group-name test

# create a log stream (https://docs.aws.amazon.com/cli/latest/reference/logs/create-log-stream.html)
awslocal logs create-log-stream \
	--log-group-name test \
	--log-stream-name test
```

## 2. Creates or updates a subscription filter and associates it with the specified log group

```sh
KINESIS_ARN=$(awslocal kinesis describe-stream --stream-name logtest --query StreamDescription.StreamARN --output text)

# Then we can configure the subscription filter (https://docs.aws.amazon.com/cli/latest/reference/logs/put-subscription-filter.html)
awslocal logs put-subscription-filter \
    --log-group-name "test" \
    --filter-name "kinesis_test" \
    --filter-pattern "" \
    --destination-arn ${KINESIS_ARN} \
    --role-arn "arn:aws:iam::000000000000:role/kinesis_role"
```

## 3. list log groups and streams

```sh
# Lists the specified log groups (https://docs.aws.amazon.com/cli/latest/reference/logs/describe-log-groups.html)
awslocal logs describe-log-groups --log-group-name-prefix test
# Lists the log streams for the specified log group (https://docs.aws.amazon.com/cli/latest/reference/logs/describe-log-streams.html)
awslocal logs describe-log-streams --log-group-name test --log-stream-name-prefix test
```


## 4. Add a log event

```sh
# timestamp=$(($(date +'%s * 1000 + %-N / 1000000'))) # alpine linux 에서는 %N 처리 안됨
timestamp=$(($(date +'%s000')))
awslocal logs put-log-events \
  --log-group-name test \
  --log-stream-name test \
  --log-events "[{\"timestamp\": ${timestamp} , \"message\": \"hello from cloudwatch\"}]"
```

## 5. Get Log Data

```sh
# retrieve the data
shard_iterator=$(awslocal kinesis get-shard-iterator --stream-name logtest --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON | jq -r .ShardIterator)
record=$(awslocal kinesis get-records --limit 10 --shard-iterator $shard_iterator | jq -r '.Records[0].Data')
echo $record | base64 -d | zcat
```

## 6. Clean Up

```sh
# delete log stream (https://docs.aws.amazon.com/cli/latest/reference/logs/delete-log-stream.html)
awslocal logs delete-log-stream --log-group-name test --log-stream-name test

# delete log group (https://docs.aws.amazon.com/cli/latest/reference/logs/delete-log-group.html)
awslocal logs delete-log-group --log-group-name test

# Deletes a Kinesis data stream
awslocal kinesis delete-stream --stream-name logtest
awslocal kinesis describe-stream-summary --stream-name logtest
```
