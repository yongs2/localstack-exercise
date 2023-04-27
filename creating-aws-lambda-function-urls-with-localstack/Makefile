export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Build, deploy, and invoke the Lambda function URL
	@which zip || apk add zip
	pip3 install -r requirements.txt -t .
	zip -r function.zip .
	awslocal lambda create-function \
		--function-name trending \
		--runtime python3.9 \
		--timeout 10 \
		--zip-file fileb://function.zip \
		--handler lambda_function.lambda_handler \
		--role arn:aws:iam::000000000000:role/cool-stacklifter

	awslocal lambda create-function-url-config \
		--function-name trending \
		--auth-type NONE

run:		## Invoke the Lambda function URL
	$(eval FUNC_URL=$(shell awslocal lambda get-function-url-config --function-name trending --query FunctionUrl --output text))
	curl -X GET $(FUNC_URL) | jq .

clean:		## Remove python libraries and zip file, delete the Lambda function
	find . -mindepth 1 -maxdepth 1 -type d -exec rm -r {} +
	rm -rf function.zip
	awslocal lambda delete-function --function-name trending

test-ci:
	make install create run; return_code=`echo $$?`;\
	make clean; exit $$return_code;
	
.PHONY: usage install create run clean test-ci
