export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## create metric alarm
	awslocal cloudwatch \
		put-metric-alarm \
		--alarm-name my-alarm \
		--metric-name Orders \
		--namespace test \
		--threshold 1 \
		--comparison-operator LessThanThreshold \
		--evaluation-periods 1 \
		--period 30 \
		--statistic Minimum \
		--treat-missing notBreaching

get:		## get the metric alarm
	awslocal cloudwatch \
  		describe-alarms \
		--alarm-names my-alarm \
		--query 'MetricAlarms[0].StateValue' \
		--output text

alarm:		## set the metric alarm to state ALARM
	awslocal cloudwatch \
		put-metric-data \
		--namespace test \
		--metric-data '[{"MetricName": "Orders", "Value": -1}]'

clean:	 	## Remove the metric alarm
	awslocal cloudwatch delete-alarms --alarm-names my-alarm
	
.PHONY: usage install create get alarm clean
