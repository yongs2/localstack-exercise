export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a dynamodb table
	awslocal dynamodb create-table \
		--table-name example-table \
		--attribute-definitions AttributeName=id,AttributeType=S \
		--key-schema AttributeName=id,KeyType=HASH \
		--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

enable:			## Enable DynamoDB stream
	awslocal dynamodb update-table \
		--table-name example-table \
		--stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES

get:			## Get stream record
	@echo "# list all DynamoDB Streams"
	$(eval STREAM_ARN=$(shell awslocal dynamodbstreams \
		list-streams \
		--query 'Streams[0].StreamArn' \
		--output text))

	@echo "# Get Shard ID"
	$(eval SHARD_ID=$(shell awslocal dynamodbstreams \
		describe-stream \
		--stream-arn ${STREAM_ARN} \
		--query 'StreamDescription.Shards[0].ShardId' \
		--output text))

	$(eval SHARD_ITER=$(shell awslocal dynamodbstreams \
		get-shard-iterator \
		--stream-arn ${STREAM_ARN} \
		--shard-id ${SHARD_ID} \
		--shard-iterator-type TRIM_HORIZON \
		--query 'ShardIterator' \
		--output text))

	@echo "# Get stream record"
	awslocal dynamodbstreams get-records \
		--shard-iterator ${SHARD_ITER}

list:			## list all dynomodb tables
	awslocal dynamodb list-tables
	
clean: 			## Delete dynamodb table
	awslocal dynamodb delete-table --table-name example-table

.PHONY: usage install create enable get list clean
