export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

create:			## Create an API
	awslocal apigateway create-rest-api --name 'My First API' --description 'This is my first API'

apiid:			## Get API ID
	$(eval API_ID=$(shell awslocal apigateway get-rest-apis --query 'items[?name==`My First API`].id' --output text))

rootid: apiid	## Get root resource ID
	$(eval ROOT_ID=$(shell awslocal apigateway get-resources --rest-api-id ${API_ID} --query 'items[?path==`/`].id' --output text))

resource: apiid rootid	## Create a resource
	awslocal apigateway create-resource --rest-api-id ${API_ID} --parent-id ${ROOT_ID} --path-part 'get'

rscgetid: apiid		## Get resource ID
	$(eval RSC_GET_ID=$(shell awslocal apigateway get-resources --rest-api-id ${API_ID} --query 'items[?path==`/get`].id' --output text))

put: apiid rscgetid	## Create a PUT method
	awslocal apigateway put-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --authorization-type NONE
	awslocal apigateway put-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 --response-models '{"application/json": "Empty"}'
	awslocal apigateway put-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --type HTTP --integration-http-method GET --uri https://httpbin.org/get
	awslocal apigateway put-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 --response-templates '{"application/json": ""}'

list: apiid rscgetid	## List all resources and methods
	awslocal apigateway get-resources --rest-api-id ${API_ID}
	awslocal apigateway get-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET || true
	awslocal apigateway get-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 || true
	awslocal apigateway get-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET || true
	awslocal apigateway get-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 || true

invoke: apiid rscgetid	## Invoke the API
	awslocal apigateway test-invoke-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --path-with-query-string '/get?foo=bar'

clean: apiid rscgetid	## Delete transcription job
	awslocal apigateway delete-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200
	awslocal apigateway delete-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET
	awslocal apigateway delete-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200
	awslocal apigateway delete-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET
	awslocal apigateway delete-resource --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID}
	awslocal apigateway delete-rest-api --rest-api-id ${API_ID}

.PHONY: usage install create resource put list invoke clean
