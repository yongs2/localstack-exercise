export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Create a kinesis stream, a log group and stream
	@echo "# create a kinesis stream"
	awslocal kinesis create-stream --stream-name logtest --shard-count 1

	@echo "# create a log group"
	awslocal logs create-log-group --log-group-name test

	@echo "# create a log stream"
	awslocal logs create-log-stream \
		--log-group-name test \
		--log-stream-name test

arn:		## Get the kinesis stream arn
	$(eval KINESIS_ARN=$(shell awslocal kinesis describe-stream --stream-name logtest --query StreamDescription.StreamARN --output text))

filter: arn	## Creates or updates a subscription filter and associates it with the specified log group
	@echo "# Then we can configure the subscription filter"
	awslocal logs put-subscription-filter \
		--log-group-name "test" \
		--filter-name "kinesis_test" \
		--filter-pattern "" \
		--destination-arn ${KINESIS_ARN} \
		--role-arn "arn:aws:iam::000000000000:role/kinesis_role"

list:		## list log groups and streams
	@echo "# Lists the specified log groups"
	awslocal logs describe-log-groups --log-group-name-prefix test
	@echo "# Lists the log streams for the specified log group"
	awslocal logs describe-log-streams --log-group-name test --log-stream-name-prefix test

add:		## Add log
	$(eval TIMESTAMP=$(shell date +'%s000'))
	awslocal logs put-log-events \
		--log-group-name test \
		--log-stream-name test \
		--log-events "[{\"timestamp\": $(TIMESTAMP) , \"message\": \"hello from cloudwatch\"}]"

get: 		## Retrieve the data
	$(eval SHARD_ITERATOR=$(shell awslocal kinesis get-shard-iterator --stream-name logtest --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON | jq -r .ShardIterator))
	$(eval RECORD=$(shell awslocal kinesis get-records --limit 10 --shard-iterator $(SHARD_ITERATOR) | jq -r '.Records[0].Data'))
	echo $(RECORD) | base64 -d | zcat

clean:		## clean Up
	@echo "# delete log stream"
	awslocal logs delete-log-stream --log-group-name test --log-stream-name test

	@echo "# delete log group"
	awslocal logs delete-log-group --log-group-name test

	@echo "# Deletes a Kinesis data stream"
	awslocal kinesis delete-stream --stream-name logtest
	awslocal kinesis describe-stream-summary --stream-name logtest
	
.PHONY: usage install create arn filter list add get clean
