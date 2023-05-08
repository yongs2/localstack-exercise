export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a case
	awslocal support \
		create-case \
		--category-code "using-aws" \
		--cc-email-addresses "myemail@example.com" \
		--communication-body "I want to learn more about an AWS service." \
		--issue-type "technical" \
		--language "en" \
		--service-code "general-info" \
		--severity-code "low" \
		--subject "Question about my account"

desc :			## Returns a list of cases
	awslocal support describe-cases

id:				# get case id
	$(eval CASE_ID=$(shell awslocal support \
		describe-cases \
		--query 'cases[?subject==`Question about my account`].caseId' \
		--output text))

clean: id		## Resolves a support case
	awslocal support \
		resolve-case \
		--case-id ${CASE_ID}

.PHONY: usage install create desc clean
