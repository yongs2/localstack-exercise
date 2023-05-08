export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

DOC_NAME=AWS-RunShellScript
INST_ID=i-04df0c15

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

run:			## Runs commands on one or more managed nodes
	awslocal ssm \
		send-command \
		--document-name ${DOC_NAME} \
		--document-version "1" \
		--instance-ids ${INST_ID} \
		--parameters "commands='cat ./uptime',workingDirectory=/proc" \

list:			## list all commands
	awslocal ssm \
		list-commands

id:			## Get command id
	$(eval CMD_ID=$(shell awslocal ssm \
		list-commands \
		--query 'Commands[?DocumentName==`'${DOC_NAME}'`].CommandId' \
		--output text | awk 'NR==1{print $$1}'))

linv: id		# FIXME: list all status about command execution (501)
	awslocal ssm \
		list-command-invocations \
		--command-id ${CMD_ID} \
		--details

get : id		## Returns detailed information about command execution for an invocation or plugin
	awslocal ssm \
		get-command-invocation \
		--command-id ${CMD_ID} \
		--instance-id ${INST_ID}

cancel: id		# FIXME: Attempts to cancel the command specified by the Command ID (501)
	awslocal ssm \
		cancel-command \
    	--command-id ${CMD_ID}

.PHONY: usage install run list get
