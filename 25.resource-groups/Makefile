export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Create an event bus, rule and target
	awslocal resource-groups \
		create-group \
		--name resource-group-name \
		--resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"resource_type1\",\"resource_type2\"],\"TagFilters\":[{\"Key\":\"Key1\",\"Values\":[\"Value1\",\"Value2\"]},{\"Key\":\"Key2\",\"Values\":[\"Value1\",\"Value2\"]}]}"}'

	awslocal resource-groups \
		create-group \
		--name my-resource-group \
		--resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::EC2::Instance\"],\"TagFilters\":[{\"Key\":\"Stage\",\"Values\":[\"Test\"]}]}"}'

get:		## Get resource group
	awslocal resource-groups \
		get-group \
		--group-name resource-group-name

	awslocal resource-groups \
		get-group \
		--group-name my-resource-group

	awslocal resource-groups \
		get-group-query \
		--group-name resource-group-name

	awslocal resource-groups \
		get-group-query \
		--group-name my-resource-group

list:		## list all resource-groups
	awslocal resource-groups list-groups

update:		## update resource group
	awslocal resource-groups \
		update-group \
		--group-name my-resource-group \
		--description "EC2 instances S3 buckets and RDS DBs that we are using for the test stage."

	awslocal resource-groups \
		update-group-query \
		--group-name resource-group-name \
		--resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"resource_type1\",\"resource_type2\"],\"TagFilters\":[{\"Key\":\"Key1\",\"Values\":[\"Value1\",\"Value2\"]},{\"Key\":\"Key2\",\"Values\":[\"Value1\",\"Value2\"]}]}"}'

	awslocal resource-groups \
		update-group-query \
		--group-name my-resource-group \
		--resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::EC2::Instance\",\"AWS::S3::Bucket\",\"AWS::RDS::DBInstance\"],\"TagFilters\":[{\"Key\":\"Stage\",\"Values\":[\"Test\"]}]}"}'

clean: 		## Delete all resources
	awslocal resource-groups \
		delete-group \
		--group-name resource-group-name
	awslocal resource-groups list-groups

	awslocal resource-groups \
		delete-group \
		--group-name my-resource-group
	awslocal resource-groups list-groups

.PHONY: usage install create get list update clean
