export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Creating an Kinesis Data Firehose Delivery Stream
	@echo "# deliver data sent to a Kinesis stream into Elasticsearch via Firehose"
	awslocal es create-elasticsearch-domain --domain-name es-local
	awslocal es list-domain-names 

	@echo "# create our target S3 bucket"
	awslocal s3 mb s3://kinesis-activity-backup-local
	awslocal s3 ls

	@echo "# create our Kinesis stream"
	awslocal kinesis create-stream --stream-name kinesis-es-local-stream --shard-count 2
	awslocal kinesis list-streams

	@echo "# our Firehose delivery stream with Elasticsearch as destination, and S3 (https://docs.aws.amazon.com/cli/latest/reference/firehose/create-delivery-stream.html)"
	awslocal firehose create-delivery-stream \
		--delivery-stream-name activity-to-elasticsearch-local \
		--delivery-stream-type KinesisStreamAsSource \
		--kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/kinesis-es-local-stream,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" \
		--elasticsearch-destination-configuration "RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,DomainARN=arn:aws:es:us-east-1:000000000000:domain/es-local,IndexName=activity,TypeName=activity,S3BackupMode=AllDocuments,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::kinesis-activity-backup-local}"
	awslocal firehose list-delivery-streams

	@echo "# Check whether the Elasticsearch cluster is already started up, wait false"
	awslocal es describe-elasticsearch-domain --domain-name es-local --query DomainStatus.Processing

list:		## Lists your delivery streams in alphabetical order of their names
	awslocal firehose list-delivery-streams

put:		## Put it into Kinesis
	awslocal kinesis put-record \
		--stream-name kinesis-es-local-stream \
		--data '{ "target": "barry" }' \
		--partition-key partition

put2:		## FIXME: Put it into the Firehose delivery stream
	awslocal firehose put-record \
		--delivery-stream-name activity-to-elasticsearch-local \
		--record '{"Data":"eyJ0YXJnZXQiOiJIZWxsbyB3b3JsZCJ9"}'

check: 		## Check the entries in Elasticsearch
	curl -s http://es-local.us-east-1.es.localhost.localstack.cloud:4566/activity/_search | jq '.hits.hits'

clean: 	 	## clean Up
	@echo "# Deletes a delivery stream and its data"
	awslocal firehose delete-delivery-stream --delivery-stream-name activity-to-elasticsearch-local
	awslocal firehose list-delivery-streams

	@echo "# Delete the Kinesis stream"
	awslocal kinesis delete-stream --stream-name kinesis-es-local-stream
	awslocal kinesis list-streams

	@echo "# Delete the S3 bucket"
	awslocal s3 rb s3://kinesis-activity-backup-local --force
	awslocal s3 ls

	@echo "# Delete the Elasticsearch domain"
	awslocal es delete-elasticsearch-domain --domain-name es-local
	awslocal es list-domain-names
	
.PHONY: usage install create list put put2 check clean
