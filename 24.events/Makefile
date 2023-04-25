export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

TOPIC_NAME:=my-sns-topic
QUEUE_NAME:=my-sns-queue
EVENT_BUS_NAME:=my-event-bus
RULE_NAME:=my-rule

usage:				## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:			## Install dependencies
	@which awslocal || pip install awscli-local

# SNS
crsns:				## Create SNS topi
	awslocal sns create-topic --name ${TOPIC_NAME}

tarn:				## Get SNS topic arn
	$(eval TOPIC_ARN=$(shell awslocal sns \
		list-topics \
		--query 'Topics[?contains(TopicArn, `'${KEY_NAME}'`)].TopicArn' \
		--output text))

sarn:				## Get SNS subscription arn
	$(eval SUBS_ARN=$(shell awslocal sns \
		list-subscriptions \
		--query 'Subscriptions[?contains(TopicArn, `'${KEY_NAME}'`)].SubscriptionArn' \
		--output text))

dlsns: tarn sarn		## Delete SNS topic
	@echo "# unsubscribe the sns"
	awslocal sns unsubscribe --subscription-arn ${SUBS_ARN} || true
	@echo "# delete the sns"
	awslocal sns delete-topic --topic-arn ${TOPIC_ARN} || true

lsns:				## list SNS topics and subscriptions
	@echo "# list topics"
	awslocal sns list-topics
	@echo "# list subscriptions"
	awslocal sns list-subscriptions

# SQS
crsqs:				## Create SQS queue
	awslocal sqs create-queue --queue-name ${QUEUE_NAME}

qurl:				## Get SQS queue url
	$(eval QUEUE_URL=$(shell awslocal sqs \
		get-queue-url \
		--queue-name ${QUEUE_NAME} \
		--output text))

qarn: qurl			## Get SQS queue arn
	$(eval QUEUE_ARN=$(shell awslocal sqs \
		get-queue-attributes \
		--queue-url ${QUEUE_URL} \
		--attribute-names QueueArn \
		--query Attributes.QueueArn \
		--output text))

sg:				## Get Seurity Group ID
	$(eval SG_ID=$(shell awslocal ec2 \
		describe-security-groups \
		--group-names ${GRP_NAME} \
		--output json \
		--query 'SecurityGroups[0].GroupId' \
		--output text))

dlsqs: qurl			## Delete SQS queue
	@echo "# delete the sqs"
	awslocal sqs delete-queue --queue-url ${QUEUE_URL} || true

lsqs:				## list SQS queues
	@echo "# list queues"
	awslocal sqs list-queues

# SNS + SQS
subs: tarn qarn			## Subscribe SQS queue to SNS topic
	awslocal sns subscribe \
		--topic-arn ${TOPIC_ARN} \
		--protocol sqs \
		--notification-endpoint ${QUEUE_ARN}

# Events
create:	tarn			## Create an event bus, rule and target
	awslocal events create-event-bus --name ${EVENT_BUS_NAME}
	awslocal events put-rule \
		--name ${RULE_NAME} \
		--event-bus-name ${EVENT_BUS_NAME} \
		--event-pattern '{"source":["my-application"],"detail-type": ["myDetailType"]}'
	awslocal events put-targets \
		--rule ${RULE_NAME} \
		--event-bus-name ${EVENT_BUS_NAME} \
		--targets "Id"="1","Arn"="${TOPIC_ARN}"
	
list: lsns lsqs			## list all event buses, rules and targets
	awslocal events list-event-buses
	awslocal events list-rules --event-bus-name ${EVENT_BUS_NAME} || true
	awslocal events list-targets-by-rule --rule ${RULE_NAME} --event-bus-name ${EVENT_BUS_NAME} || true

put:				## Put Event
	@echo "# create event json file"
	EVENT_JSON_FILE=/tmp/event.json; \
	if [ ! -f $${EVENT_JSON_FILE} ] ; then \
		touch $${EVENT_JSON_FILE} ; \
		echo '[' >> $${EVENT_JSON_FILE} ; \
		echo '	{' >> $${EVENT_JSON_FILE} ; \
		echo '		"EventBusName": "'${EVENT_BUS_NAME}'",' >> $${EVENT_JSON_FILE} ; \
		echo '		"Time": "2022-04-12T13:00:00Z",' >> $${EVENT_JSON_FILE} ; \
		echo '		"Source": "my-application",' >> $${EVENT_JSON_FILE} ; \
		echo '		"Resources": ["resource-1"],' >> $${EVENT_JSON_FILE} ; \
		echo '		"DetailType": "myDetailType",' >> $${EVENT_JSON_FILE} ; \
		echo '		"Detail": "{\"key1\": \"value1\", \"key2\": \"value2\"}"' >> $${EVENT_JSON_FILE} ; \
		echo '	}' >> $${EVENT_JSON_FILE} ; \
		echo ']' >> $${EVENT_JSON_FILE} ; \
	fi
	awslocal events put-events --entries file:///tmp/event.json

recv: qurl			## Receive Event from SQS
	awslocal sqs receive-message --queue-url ${QUEUE_URL}

clean: dlsns dlsqs		## Delete all resources
	@echo "# Removes the specified targets from the specified rule"
	awslocal events remove-targets --rule ${RULE_NAME} --event-bus-name ${EVENT_BUS_NAME} --ids 0 1 || true
	awslocal events list-targets-by-rule --rule ${RULE_NAME} --event-bus-name ${EVENT_BUS_NAME} || true

	@echo "# Deletes the specified rule"
	awslocal events delete-rule --name ${RULE_NAME} --event-bus-name ${EVENT_BUS_NAME} || true
	awslocal events list-rules --event-bus-name ${EVENT_BUS_NAME}

	@echo "# Deletes the specified custom event bus or partner event bus"
	awslocal events delete-event-bus --name ${EVENT_BUS_NAME} || true
	awslocal events list-event-buses

.PHONY: usage install crsns crsqs subs create list put recv clean
