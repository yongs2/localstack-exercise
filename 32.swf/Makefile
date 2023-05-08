export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

DOMAIN_NAME="default"

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

exist:			## Check if the domain exists
	$(eval DEP_DOMAIN_NAME=$(shell awslocal swf \
		list-domains \
		--registration-status DEPRECATED \
		--query 'domainInfos[?name==`'${DOMAIN_NAME}'`].name' \
		--output text))

create: exist			## Registers a new domain
	if [ -z "${DEP_DOMAIN_NAME}" ]; then \
		awslocal swf \
			register-domain \
			--name ${DOMAIN_NAME} \
			--workflow-execution-retention-period-in-days 1 \
			--description "Default domain for localstack"; \
		echo "created domain ${DOMAIN_NAME}" ; \
	else \
		awslocal swf \
			undeprecate-domain \
			--name ${DOMAIN_NAME}; \
		echo "undeprecated domain ${DOMAIN_NAME}" ; \
	fi 

list:			## list of domains registered in the account
	awslocal swf \
		list-domains \
		--registration-status REGISTERED
		
	awslocal swf \
		list-domains \
		--registration-status DEPRECATED

desc :			## Returns information about the specified domain
	awslocal swf \
		describe-domain \
		--name ${DOMAIN_NAME}
	
clean:			## Deprecates the specified domain
	awslocal swf \
		deprecate-domain \
		--name ${DOMAIN_NAME}

.PHONY: usage install create desc get atag ltag dtag clean
