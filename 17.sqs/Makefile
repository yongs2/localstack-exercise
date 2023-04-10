export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Create a Queue
	awslocal sqs create-queue --queue-name sample-queue

list:		## List all the Queues
	awslocal sqs list-queues

url:		## Get Queue URL
	$(eval QUEUE_URL=$(shell awslocal sqs get-queue-url --queue-name sample-queue --output text))

send: url	## Send messages to Queue
	awslocal sqs send-message --queue-url ${QUEUE_URL} --message-body test

recv: url	## Receive messages from Queue
	awslocal sqs receive-message --queue-url=${QUEUE_URL}

clean: url	## Delete Queue
	awslocal sqs delete-queue --queue-url ${QUEUE_URL}

.PHONY: usage install create list url send recv clean
