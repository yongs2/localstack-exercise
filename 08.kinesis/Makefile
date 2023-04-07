export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

RESULT_DATA=/tmp/my_encrypted_data

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Creating a Stream
	awslocal kinesis create-stream --stream-name Foo

list:		## List streams
	awslocal kinesis list-streams

put:		## put a record
	awslocal kinesis put-record --stream-name Foo --partition-key 123 --data testdata

get:		## get the record
	$(eval SHARD_ITERATOR=$(shell awslocal kinesis get-shard-iterator --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON --stream-name Foo --output text))
	awslocal kinesis get-records --shard-iterator ${SHARD_ITERATOR} --query Records[0].Data | base64 -d

summary:	## summary of the stream
	awslocal kinesis describe-stream-summary --stream-name Foo

clean: 	 	## clean Up
	awslocal kinesis delete-stream --stream-name Foo
	
.PHONY: usage install create list put get summary clean
