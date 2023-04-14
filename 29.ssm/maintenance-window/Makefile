export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

WINDDOW_NAME=My-Tutorial-Maintenance-Window

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a new maintenance window.
	awslocal ssm \
		create-maintenance-window \
		--name ${WINDDOW_NAME} \
		--schedule "rate(5 minutes)" \
		--duration 2 --cutoff 1 \
		--allow-unassociated-targets \
		--tags "Key=Purpose,Value=Tutorial"

desc:			## Retrieves the maintenance windows in an Amazon Web Services account
	awslocal ssm \
		describe-maintenance-windows

id:				## Get Windows ID from Name
	$(eval WINDOW_ID=$(shell awslocal ssm \
		describe-maintenance-windows \
		--query 'WindowIdentities[?Name==`'${WINDDOW_NAME}'`].WindowId' \
		--output text))

get : id		## Retrieves a maintenance window
	awslocal ssm \
		get-maintenance-window \
		--window-id ${WINDOW_ID}

update: id		# FIXME: Updates an existing maintenance window (501)
	awslocal ssm \
		update-maintenance-window \
		--window-id ${WINDOW_ID} \
		--name "My-Renamed-MW"

rtaget: id		# FIXME: Registers a target with a maintenance window (501)
	awslocal ssm \
		register-target-with-maintenance-window \
		--window-id ${WINDOW_ID} \
		--target "Key=InstanceIds,Values=i-0000293ffd8c57862" \
		--owner-information "Single instance" \
		--resource-type "INSTANCE"

dtarget: id		# FIXME: Lists the targets registered with the maintenance window (501)
	awslocal ssm \
		describe-maintenance-window-targets \
		--window-id ${WINDOW_ID}

utarget: id		# FIXME: Modifies the target of an existing maintenance window (501)
	awslocal ssm \
		update-maintenance-window-target \
		--window-id ${WINDOW_ID} \
		--window-target-id "57e8344e-fe64-4023-8191-6bf05EXAMPLE" \
		--name "NewName" \
		--no-replace

rtask: id		# FIXME: Adds a new task to a maintenance window (501)
	awslocal ssm \
		register-task-with-maintenance-window \
		--window-id ${WINDOW_ID} \
		--targets Key=InstanceIds,Values=i-1234520122EXAMPLE \
		--task-arn AWS-RestartEC2Instance \
		--service-role-arn arn:aws:iam::111222333444:role/SSM --task-type AUTOMATION \
		--task-invocation-parameters "{\"Automation\":{\"DocumentVersion\":\"\$LATEST\",\"Parameters\":{\"InstanceId\":[\"{{RESOURCE_ID}}\"]}}}" \
		--priority 0 \
		--max-concurrency 1 \
		--max-errors 1 \
		--name "AutomationExample" \
		--description "Restarting EC2 Instance for maintenance"
dtask: id		# FIXME: describe-maintenance-window-tasks (501)
	awslocal ssm \
		describe-maintenance-window-tasks \
    	--window-id ${WINDOW_ID}

gtask: id		# FIXME: get-maintenance-window-task (501)
	awslocal ssm \
		get-maintenance-window-task \
    	--window-id ${WINDOW_ID} \
    	--window-task-id 0e842a8d-2d44-4886-bb62-af8dcEXAMPLE

utask: id		# FIXME: update-maintenance-window-task (501)
	aws ssm \
		update-maintenance-window-task \
		--window-id ${WINDOW_ID} \
		--window-task-id "23d3809e-9fbe-4ddf-b41a-b49d7EXAMPLE" \
		--service-role-arn "arn:aws:iam::111222333444:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
		
clean: id		## Deletes a maintenance window
	awslocal ssm \
		delete-maintenance-window \
		--window-id ${WINDOW_ID}

.PHONY: usage install create desc get list update clean
