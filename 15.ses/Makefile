export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

send:		## send mail
	awslocal ses send-email \
		--from user1@yourdomain.com \
		--message 'Body={Text={Data="Lorem ipsum dolor sit amet, consectetur adipiscing elit, ..."}},Subject={Data=Test Email}' \
		--destination 'ToAddresses=recipient1@example.com'

verify:		## Verify email identity
	awslocal ses verify-email-identity --email-address user1@yourdomain.com

list:		## List email identities
	awslocal ses list-identities

.PHONY: usage install send verify list
