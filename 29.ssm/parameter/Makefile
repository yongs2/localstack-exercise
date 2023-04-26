export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

PARAM_NAME="/my/parameter"

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a new parameter
	awslocal ssm \
		put-parameter \
		--name ${PARAM_NAME} \
		--value "my-value" \
		--type String

desc:			## Get information about a parameter
	awslocal ssm \
		describe-parameters

get :			## Get information about a single parameter by specifying the parameter name
	awslocal ssm \
		get-parameter \
		--name ${PARAM_NAME}

atag:			## add tags to a parameter
	awslocal ssm \
		add-tags-to-resource \
		--resource-type "Parameter" \
		--resource-id ${PARAM_NAME} \
		--tags "Key=Environment,Value=Dev" "Key=Owner,Value=JohnDoe"

ltag:			## list tags for a parameter
	awslocal ssm \
		list-tags-for-resource \
		--resource-type "Parameter" \
		--resource-id ${PARAM_NAME}

dtag:			## removes tags from a parameter
	awslocal ssm \
		remove-tags-from-resource \
		--resource-type "Parameter" \
		--resource-id ${PARAM_NAME} \
		--tag-keys "Owner"
	
clean:			## Deletes a parameter
	awslocal ssm \
		delete-parameter \
		--name ${PARAM_NAME}

.PHONY: usage install create desc get atag ltag dtag clean
