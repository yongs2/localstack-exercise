export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

CIDR_BLOCK="10.0.0.0/16"

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

crvpc:			## Create ec2 vpc
	awslocal ec2 \
		create-vpc \
		--cidr-block ${CIDR_BLOCK}

vpcid:			## get vpc id
	$(eval VPC_ID=$(shell awslocal ec2 describe-vpcs \
		--query 'Vpcs[?CidrBlock==`'${CIDR_BLOCK}'`].VpcId' \
		--output text))

create: crvpc vpcid	## Create ec2 vpc and tag it
	awslocal ec2 \
		create-tags \
		--resources ${VPC_ID} \
		--tags Key=Environment,Value=Production

resources:		## Get all tagged resources
	awslocal resourcegroupstaggingapi \
		get-resources \
		--tag-filters Key=Environment,Values=Production \
		--tags-per-page 100

	awslocal resourcegroupstaggingapi \
		get-resources \
		--resource-type-filters ec2

keys:			## Get all tag keys
	awslocal resourcegroupstaggingapi \
		get-tag-keys

values:			## Get all tag values
	awslocal resourcegroupstaggingapi \
		get-tag-values \
		--key Environment

clean: vpcid	## Delete ec2 vpc and tag
	awslocal ec2 \
		delete-tags \
		--resources ${VPC_ID} \
		--tags Key=Environment,Value=Production
	awslocal ec2 describe-tags

	awslocal ec2 delete-vpc \
		--vpc-id ${VPC_ID}
	awslocal ec2 describe-vpcs

.PHONY: usage install create resources keys values clean
