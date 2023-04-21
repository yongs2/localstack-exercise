export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Create a state machine
	awslocal stepfunctions create-state-machine \
		--name "WaitMachine" \
		--definition '{"StartAt":"WaitExecution","States":{"WaitExecution":{"Type":"Wait","Seconds":10,"End":true}}}' \
		--role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"

list:			## List all the state machines
	awslocal stepfunctions list-state-machines

smarn:			## Get StateMahcineArn
	$(eval SM_ARN=$(shell awslocal stepfunctions \
		list-state-machines \
		--query 'stateMachines[?name==`WaitMachine`].stateMachineArn' \
		--output text))

desc: smarn		##  Retrieve the state machine
	awslocal stepfunctions describe-state-machine --state-machine-arn ${SM_ARN}

exec: smarn		## Execute the state machine
	awslocal stepfunctions start-execution --state-machine-arn ${SM_ARN}

check: smarn		## Check the execution status
	$(eval EX_ARN=$(shell awslocal stepfunctions \
		list-executions \
		--state-machine-arn ${SM_ARN} \
		--query 'executions[0].executionArn' \
		--output text))
	awslocal stepfunctions describe-execution --execution-arn ${EX_ARN}

update: smarn		## Update the state machine definition
	awslocal stepfunctions update-state-machine \
		--state-machine-arn ${SM_ARN} \
		--definition file://statemachine.json \
		--role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"

clean: smarn		## Delete state machine
	awslocal stepfunctions delete-state-machine --state-machine-arn ${SM_ARN}

.PHONY: usage install create list desc exec check update clean
