export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a new configuration recorder
	awslocal configservice put-configuration-recorder \
		--configuration-recorder name=default,roleARN=arn:aws:iam::123456789012:role/config-role \
		--recording-group allSupported=true,includeGlobalResourceTypes=true

mkjson:			## Creates a JSON file for delivery channel
	@echo '{"name":"default","s3BucketName":"config-bucket-123456789012","snsTopicARN":"arn:aws:sns:us-east-1:123456789012:config-topic","configSnapshotDeliveryProperties":{"deliveryFrequency":"Twelve_Hours"}}' > /tmp/deliveryChannel.json
		
channel: mkjson	## Creates a delivery channel
	awslocal configservice put-delivery-channel --delivery-channel file:///tmp/deliveryChannel.json	

start:			## Start recording configurations
	awslocal configservice start-configuration-recorder --configuration-recorder-name default

list:			## List all configuration recorders and delivery channels
	awslocal configservice describe-configuration-recorders
	awslocal configservice describe-configuration-recorder-status --configuration-recorder-names default || true
	awslocal configservice describe-delivery-channels
	
clean: 			## Delete delivery channel and configuration recorder
	awslocal configservice stop-configuration-recorder --configuration-recorder-name default || true
	awslocal configservice delete-delivery-channel --delivery-channel-name default || true
	awslocal configservice delete-configuration-recorder --configuration-recorder-name default || true

.PHONY: usage install create channel start list clean
