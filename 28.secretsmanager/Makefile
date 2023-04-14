export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

SECRET_ID="MyTestSecret"

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Creates a new secret
	awslocal secretsmanager \
		create-secret \
		--name ${SECRET_ID} \
		--description "My test secret created with the CLI." \
		--secret-string "{\"user\":\"diegor\",\"password\":\"EXAMPLE-PASSWORD\"}"

update:			## Modify a secret
	awslocal secretsmanager \
		update-secret \
		--secret-id ${SECRET_ID} \
		--description "This is a new description for the secret."

	awslocal secretsmanager \
		put-secret-value \
		--secret-id ${SECRET_ID} \
		--secret-string "{\"user\":\"diegor\",\"password\":\"EXAMPLE-PASSWORD\"}"

get :			## Retrieves the details of a secret
	awslocal secretsmanager \
		describe-secret \
		--secret-id ${SECRET_ID}

list:			## Lists all secrets
	awslocal secretsmanager \
		list-secrets

tag:			## Attaches tags to a secret
	awslocal secretsmanager \
		tag-resource \
		--secret-id ${SECRET_ID} \
		--tags '[{"Key": "FirstTag", "Value": "FirstValue"}, {"Key": "SecondTag", "Value": "SecondValue"}]'

untag:			## Removes tags from a secret
	awslocal secretsmanager \
		untag-resource \
		--secret-id ${SECRET_ID} \
		--tag-keys '[ "FirstTag", "SecondTag"]'

delete:			## Deletes a secret
	awslocal secretsmanager \
		delete-secret \
		--secret-id ${SECRET_ID} \
		--recovery-window-in-days 7

restore:		## Restores a secret
	awslocal secretsmanager \
		restore-secret \
		--secret-id ${SECRET_ID}

clean:			## Delete a secret immediately
	awslocal secretsmanager \
		delete-secret \
		--secret-id ${SECRET_ID} \
		--force-delete-without-recovery

.PHONY: usage install create update get list tag untag delete restore clean
