export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## create a domain
	awslocal es create-elasticsearch-domain --domain-name my-domain

get:		## get domain status, wait false
	awslocal es describe-elasticsearch-domain --domain-name my-domain | jq ".DomainStatus.Processing"

interact:	## interact a domain
	curl http://my-domain.us-east-1.es.localhost.localstack.cloud:4566
	curl -s http://my-domain.us-east-1.es.localhost.localstack.cloud:4566/_cluster/health | jq .

list:		## list all domains
	awslocal es list-domain-names 

clean:	 	## delete the domain
	awslocal es delete-elasticsearch-domain --domain-name my-domain
	
.PHONY: usage install create get interact list clean
