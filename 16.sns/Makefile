export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Create a SNS topic
	awslocal sns create-topic --name test-topic

set:		## set-topic-attributes
	awslocal sns set-topic-attributes \
		--topic-arn arn:aws:sns:us-east-1:000000000000:test-topic \
		--attribute-name DisplayName \
		--attribute-value MyTopicDisplayName

list:		## List all the SNS topics
	awslocal sns list-topics
	awslocal sns list-subscriptions

get:		## get-topic-attributes
	awslocal sns get-topic-attributes \
		--topic-arn arn:aws:sns:us-east-1:000000000000:test-topic

publish:	## Publish a message to a SNS topic
	awslocal sns publish \
		--topic-arn arn:aws:sns:us-east-1:000000000000:test-topic \
		--message "Hello World"

subs:		## subscribe arn
	awslocal sns subscribe --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic --protocol email --notification-endpoint test@gmail.com

arn:		## Get SNS Subscription ARN
	$(eval SUBS_ARN=$(shell awslocal sns list-subscriptions-by-topic \
		--topic-arn arn:aws:sns:us-east-1:000000000000:test-topic \
		--query Subscriptions[0].SubscriptionArn --output text))

attr: arn	## Set SNS Subscription attributes
	awslocal sns set-subscription-attributes \
		--subscription-arn ${SUBS_ARN} \
		--attribute-name RawMessageDelivery \
		--attribute-value true

clean: arn	## Delete SNS Subscription
	awslocal sns unsubscribe --subscription-arn ${SUBS_ARN}
	awslocal sns delete-topic --topic-arn arn:aws:sns:us-east-1:000000000000:test-topic

.PHONY: usage install create set list get publish subs attr clean
