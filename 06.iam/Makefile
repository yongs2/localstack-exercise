export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

RESULT_JSON=/tmp/access-key.json

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Creating IAM Users and Access Keys
	awslocal sts get-caller-identity
	awslocal iam create-user --user-name test
	awslocal iam create-access-key --user-name test > ${RESULT_JSON}

key:		## get access key
	$(eval AWS_ACCESS_KEY_ID=$(shell cat ${RESULT_JSON} | jq -r .AccessKey.AccessKeyId))
	$(eval AWS_SECRET_ACCESS_KEY=$(shell cat ${RESULT_JSON} | jq -r .AccessKey.SecretAccessKey))

policy: key		## Enforcing IAM Policies
	awslocal sts get-caller-identity
	awslocal iam create-policy --policy-name p1 --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":"s3:CreateBucket","Resource":"*"}]}'
	awslocal iam attach-user-policy --user-name test --policy-arn arn:aws:iam::000000000000:policy/p1

list: key	## list all domains
	awslocal iam list-users
	awslocal iam list-access-keys --user-name test
	awslocal iam list-policies --query 'Policies[?PolicyName==`p1`].Arn'
	awslocal iam list-user-policies --user-name test

get: key	## get user and policy
	awslocal iam get-user
	awslocal iam get-policy --policy-arn arn:aws:iam::000000000000:policy/p1

clean: key	 	## delete the domain
	awslocal iam delete-access-key --access-key-id ${AWS_ACCESS_KEY_ID}
	awslocal iam list-attached-user-policies --user-name test
	awslocal iam detach-user-policy --user-name test --policy-arn arn:aws:iam::000000000000:policy/p1
	awslocal iam delete-policy --policy-arn arn:aws:iam::000000000000:policy/p1
	awslocal iam delete-user --user-name test
	awslocal sts get-caller-identity
	
.PHONY: usage install create key policy list list clean
