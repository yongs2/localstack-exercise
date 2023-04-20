export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

TOPIC_NAME=test-topic

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Create a SNS topic
	awslocal sns create-topic --name ${TOPIC_NAME}

tarn:		## Get SNS Topic ARN
	$(eval TOPIC_ARN=$(shell awslocal sns \
		list-topics \
		--query "Topics[?contains(TopicArn, '${TOPIC_NAME}')].TopicArn" \
    	--output text))

set: tarn	## set-topic-attributes
	awslocal sns \
		set-topic-attributes \
		--topic-arn ${TOPIC_ARN} \
		--attribute-name DisplayName \
		--attribute-value MyTopicDisplayName

list:		## List all the SNS topics
	awslocal sns list-topics
	awslocal sns list-subscriptions

get: tarn	## get-topic-attributes
	awslocal sns \
		get-topic-attributes \
		--topic-arn ${TOPIC_ARN}

publish: tarn	## Publish a message to a SNS topic
	awslocal sns \
		publish \
		--topic-arn ${TOPIC_ARN} \
		--message "Hello World"

subs: tarn	## subscribe arn
	awslocal sns \
		subscribe \
		--topic-arn ${TOPIC_ARN} \
		--protocol email \
		--notification-endpoint test@gmail.com

sarn: tarn	## Get SNS Subscription ARN
	$(eval SUBS_ARN=$(shell awslocal sns list-subscriptions-by-topic \
		--topic-arn ${TOPIC_ARN} \
		--query Subscriptions[0].SubscriptionArn --output text))

attr: sarn	## Set SNS Subscription attributes
	awslocal sns set-subscription-attributes \
		--subscription-arn ${SUBS_ARN} \
		--attribute-name RawMessageDelivery \
		--attribute-value true

clean: sarn	## Delete SNS Subscription
	awslocal sns unsubscribe --subscription-arn ${SUBS_ARN}
	awslocal sns delete-topic --topic-arn ${TOPIC_ARN}

.PHONY: usage install create set list get publish subs attr clean
