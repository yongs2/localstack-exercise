export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

DOC_NAME="example"

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a SSM document
	awslocal ssm \
		create-document \
		--content file://01_create.yml \
		--name ${DOC_NAME} \
		--document-type "Automation" \
		--document-format YAML

desc:			## Describes the specified SSM document
	awslocal ssm \
		describe-document \
		--name ${DOC_NAME}

get :			## Gets the contents of SSM document
	awslocal ssm \
		get-document \
		--name ${DOC_NAME}

list:			## list all SSM documents
	awslocal ssm \
		list-documents

atag:			## add tags to a document
	awslocal ssm \
		add-tags-to-resource \
		--resource-type "Document" \
		--resource-id ${DOC_NAME} \
		--tags "Key=Environment,Value=Dev" "Key=Owner,Value=JohnDoe"

ltag:			## list tags for a document
	awslocal ssm \
		list-tags-for-resource \
		--resource-type "Document" \
		--resource-id ${DOC_NAME}

dtag:			## removes tags from a document
	awslocal ssm \
		remove-tags-from-resource \
		--resource-type "Document" \
		--resource-id ${DOC_NAME} \
		--tag-keys "Owner"

update:			## Updates one or more values for an SSM document
	awslocal ssm \
		update-document \
		--content file://02_update.yml \
		--name ${DOC_NAME} \
		--document-version "1" \
		--document-format YAML

clean:			## Deletes the SSM document
	awslocal ssm \
		delete-document \
    	--name ${DOC_NAME}

.PHONY: usage install create desc get list update clean
