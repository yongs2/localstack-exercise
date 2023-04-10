export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

SAMPLE_FILE=index.html

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Creates a new S3 bucket
	awslocal s3api create-bucket --bucket sample-bucket

list:		## list buckets
	awslocal s3api list-buckets
	awslocal s3api list-objects --bucket sample-bucket

add:		## Adds an object to a bucket
	awslocal s3api put-object --bucket sample-bucket --key ${SAMPLE_FILE} --body ${SAMPLE_FILE}

get:		## Get an object from a bucket
	awslocal s3api get-object --bucket sample-bucket --key ${SAMPLE_FILE} ${SAMPLE_FILE}

cors:		## Set CORS configuration
	awslocal s3api put-bucket-cors --bucket sample-bucket --cors-configuration file://cors-config.json
	awslocal s3api get-bucket-cors --bucket sample-bucket

clean:	 	## Delete a bucket
	$(eval KEYS=$(shell awslocal s3api list-objects --bucket sample-bucket --query Contents[].Key --output text))
	@for KEY in $(KEYS); do \
		echo "KEY="$$KEY; \
		awslocal s3api delete-object --bucket sample-bucket --key $$KEY ; \
    done
	awslocal s3api delete-bucket --bucket sample-bucket

.PHONY: usage install create list add get cors clean
