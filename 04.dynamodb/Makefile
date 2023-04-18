export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## create a table
	awslocal dynamodb create-table \
		--table-name global01 \
		--key-schema AttributeName=id,KeyType=HASH \
		--attribute-definitions AttributeName=id,AttributeType=S \
		--billing-mode PAY_PER_REQUEST \
		--region ap-south-1

replicas:	## create replicas
	awslocal dynamodb update-table \
		--table-name global01 \
		--replica-updates '[{"Create": {"RegionName": "eu-central-1"}}, {"Create": {"RegionName": "us-west-1"}}]' \
		--region ap-south-1

list:		## list a table
	@echo "# default region us-east-1"
	awslocal dynamodb list-tables --region us-east-1    
	awslocal dynamodb list-tables --region ap-south-1
	awslocal dynamodb list-tables --region eu-central-1
	awslocal dynamodb list-tables --region us-west-1

put:		## put itm to table
	awslocal dynamodb put-item --table-name global01 --item '{"id":{"S":"foo"}}' --region eu-central-1

query:		## query a table
	awslocal dynamodb describe-table --table-name global01 --query 'Table.ItemCount' --region ap-south-1
	awslocal dynamodb describe-table --table-name global01 --query 'Table.Replicas' --region us-west-1

clean:	 	## delete a table
	awslocal dynamodb delete-table --table-name global01 --region ap-south-1
	
.PHONY: usage install create replicas list put query clean
