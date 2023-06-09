# [Kinesis Data Firehose](https://docs.localstack.cloud/user-guide/aws/kinesis-firehose/)

See [Amazon Kinesis Data Firehose](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html)

## 1. Using AWS CLI

### 1.1 Creating an Kinesis Data Firehose Delivery Stream

```sh
# deliver data sent to a Kinesis stream into Elasticsearch via Firehose
awslocal es create-elasticsearch-domain --domain-name es-local
awslocal es list-domain-names 

# create our target S3 bucket
awslocal s3 mb s3://kinesis-activity-backup-local
awslocal s3 ls

# create our Kinesis stream
awslocal kinesis create-stream --stream-name kinesis-es-local-stream --shard-count 2
awslocal kinesis list-streams

# our Firehose delivery stream with Elasticsearch as destination, and S3 (https://docs.aws.amazon.com/cli/latest/reference/firehose/create-delivery-stream.html)
awslocal firehose create-delivery-stream \
  --delivery-stream-name activity-to-elasticsearch-local \
  --delivery-stream-type KinesisStreamAsSource \
  --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/kinesis-es-local-stream,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" \
  --elasticsearch-destination-configuration "RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,DomainARN=arn:aws:es:us-east-1:000000000000:domain/es-local,IndexName=activity,TypeName=activity,S3BackupMode=AllDocuments,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::kinesis-activity-backup-local}"
awslocal firehose list-delivery-streams

# Check whether the Elasticsearch cluster is already started up, wait false
awslocal es describe-elasticsearch-domain --domain-name es-local --query DomainStatus.Processing
```

### 1.2 Verify the existence of Kinesis Data Firehose Delivery Stream

```sh
# Describes the specified delivery stream and its status (https://docs.aws.amazon.com/cli/latest/reference/firehose/describe-delivery-stream.html)
awslocal firehose describe-delivery-stream \
    --delivery-stream-name activity-to-elasticsearch-local
```

### 1.3 Put it into Kinesis

```sh
# put it into Kinesis
awslocal kinesis put-record \
    --stream-name kinesis-es-local-stream \
    --data '{ "target": "barry" }' \
    --partition-key partition
```

### 1.4 Put it into the Firehose delivery stream

- FIXME: An error occurred (InternalError) when calling the PutRecord operation (reached max retries: 4): exception while calling firehose.PutRecord: Traceback (most recent call last):

```sh
# Writes a single data record into an Amazon Kinesis Data Firehose delivery stream (https://docs.aws.amazon.com/cli/latest/reference/firehose/put-record.html)
awslocal firehose put-record \
    --delivery-stream-name activity-to-elasticsearch-local \
    --record '{"Data":"eyJ0YXJnZXQiOiJIZWxsbyB3b3JsZCJ9"}'
```

### 1.5 Check the entries in Elasticsearch

```sh
curl -s http://es-local.us-east-1.es.localhost.localstack.cloud:4566/activity/_search | jq '.hits.hits'
```

### 1.6 Clean Up

```sh
# Deletes a delivery stream and its data (https://docs.aws.amazon.com/cli/latest/reference/firehose/delete-delivery-stream.html)
awslocal firehose delete-delivery-stream --delivery-stream-name activity-to-elasticsearch-local
awslocal firehose list-delivery-streams

# Delete the Kinesis stream
awslocal kinesis delete-stream --stream-name kinesis-es-local-stream
awslocal kinesis list-streams

# Delete the S3 bucket
awslocal s3 rb s3://kinesis-activity-backup-local --force
awslocal s3 ls

# Delete the Elasticsearch domain
awslocal es delete-elasticsearch-domain --domain-name es-local
awslocal es list-domain-names 
```

## 2. Using terraform

- [Resource: aws_kinesis_firehose_delivery_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream)

### 2.1 Creating an Kinesis Data Firehose Delivery Stream

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Verify the existence of Kinesis Data Firehose Delivery Stream

```sh
awslocal firehose \
    describe-delivery-stream \
    --delivery-stream-name activity-to-elasticsearch-local
```

### 2.3 Put it into Kinesis

```sh
awslocal kinesis \
    put-record \
    --stream-name kinesis-es-local-stream \
    --data '{ "target": "barry" }' \
    --partition-key partition
```

### 2.4 Check the entries in Elasticsearch

```sh
curl -s http://es-local.us-east-1.es.localhost.localstack.cloud:4566/activity/_search | jq '.hits.hits'
```

### 2.5 Delete an Kinesis Data Firehose Delivery Stream

```sh
terraform destroy -auto-approve
```
