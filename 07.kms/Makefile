export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

RESULT_DATA=/tmp/my_encrypted_data

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Creating key
	awslocal kms create-key

list:		## List keys
	awslocal kms list-keys

key:		## get access key
	$(eval KEY_ID=$(shell awslocal kms list-keys --query "Keys[0].KeyId" --output text))

encrypt: key	## Use the key now to encrypt something
	awslocal kms encrypt \
		--key-id ${KEY_ID} \
		--plaintext "some important stuff" \
		--output text \
		--query CiphertextBlob \
		| base64 -d > ${RESULT_DATA}

decrypt: key	## Decrypt our file using the same KMS key
	awslocal kms decrypt \
		--ciphertext-blob fileb://${RESULT_DATA} \
		--output text \
		--query Plaintext \
		| base64 -d

clean: key	 ## Disable key
	awslocal kms disable-key --key-id ${KEY_ID}
	
.PHONY: usage install create list key encrypt decrypt clean
