export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## Creating Lambda layers locally
	@echo "# Create layer zip file"
	LAYER_DIR=/tmp/python; \
	LAYER_FILE=$${LAYER_DIR}/testlayer.py ; \
	if [ ! -d $${LAYER_DIR} ] ; then mkdir -p $${LAYER_DIR} ; fi ; \
	if [ ! -f $${LAYER_FILE} ] ; then \
		touch $${LAYER_FILE} ; \
		echo 'def util():' >> $${LAYER_FILE} ; \
		echo '    print("Output from Lambda layer util function")' >> $${LAYER_FILE} ; \
	fi
	(cd /tmp; zip -r testlayer.zip python)

	@echo "# create layer"
	awslocal lambda publish-layer-version \
		--layer-name layer1 \
		--zip-file fileb:///tmp/testlayer.zip

	@echo "# List layers"
	awslocal lambda list-layers

arn:		## get lambda layer arn
	$(eval LAYER_VER_ARN=$(shell awslocal lambda list-layers --query 'Layers[?LayerName==`layer1`].LatestMatchingVersion.LayerVersionArn' --output text))

func: arn	## Create the Lambda function
	@echo "# create function zip file"
	LAMBDA_FILE=/tmp/testlambda.py; \
	if [ ! -f $${LAMBDA_FILE} ] ; then \
		touch $${LAMBDA_FILE} ; \
		echo 'def handler(*args, **kwargs):' >> $${LAMBDA_FILE} ; \
		echo '  import testlayer; testlayer.util()' >> $${LAMBDA_FILE} ; \
		echo '  print("Debug output from Lambda function")' >> $${LAMBDA_FILE} ; \
	fi
	(cd /tmp; zip testlambda.zip testlambda.py)

	@echo "# create function"
	awslocal lambda create-function \
		--function-name func1 \
		--runtime python3.8 \
		--role arn:aws:iam::000000000000:role/lambda-role \
		--handler testlambda.handler \
		--timeout 30 \
		--zip-file fileb:///tmp/testlambda.zip \
		--layers ${LAYER_VER_ARN}
  
	@echo "# list functions"
	awslocal lambda list-functions

list:	## list layers and functions
	awslocal lambda list-layers
	awslocal lambda list-functions

log:		## get logs
	awslocal lambda invoke \
		--function-name func1 \
		out.log \
		--log-type Tail \
		--query 'LogResult' \
		--output text |  base64 -d

update:		## Update Function
	awslocal lambda update-function-configuration \
		--function-name func1 \
		--memory-size 256

get: 		## Retrieve a Lambda function
	awslocal lambda get-function --function-name func1

ver:		## get lambda layer arn
	$(eval LAYER_VER=$(shell awslocal lambda list-layers --query 'Layers[?LayerName==`layer1`].LatestMatchingVersion.Version' --output text))

clean: ver 	## clean Up
	@echo "# Delete function"
	awslocal lambda delete-function --function-name func1 || true
	awslocal lambda list-functions

	@echo "# Delete layer"
	awslocal lambda delete-layer-version --layer-name layer1 --version-number ${LAYER_VER} || true
	awslocal lambda list-layers
	
.PHONY: usage install create func list log update get clean
