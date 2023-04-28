export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

ZONE_NAME=example.com

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a new public or private hosted zone
	awslocal route53 \
		create-hosted-zone \
		--name ${ZONE_NAME} \
		--caller-reference r1

list:			## list of the public and private hosted zones
	awslocal route53 list-hosted-zones

id:				# Get Zone ID
	$(eval ZONE_ID=$(shell awslocal route53 \
		list-hosted-zones \
		--query 'HostedZones[?Name==`'${ZONE_NAME}'.`].Id' \
		--output text))

get: id			## Gets information about a specified hosted zone
	awslocal route53 \
		get-hosted-zone \
		--id ${ZONE_ID}
	
clean: id		## Deletes a hosted zone
	awslocal route53 \
		delete-hosted-zone \
		--id ${ZONE_ID}

.PHONY: usage install create list get clean
