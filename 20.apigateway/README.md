# [apigateway](https://docs.localstack.cloud/references/coverage/coverage_apigateway/)

See [Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)

## 1. Create an API

```sh
# Creates a new RestApi resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/create-rest-api.html)
awslocal apigateway create-rest-api --name 'My First API' --description 'This is my first API'

# Lists the RestApis resources for your collection (https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-rest-apis.html)
API_ID=$(awslocal apigateway get-rest-apis --query 'items[?name==`My First API`].id' --output text)

# Get the root resource ID (https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-resources.html)
ROOT_ID=$(awslocal apigateway get-resources --rest-api-id ${API_ID} --query 'items[?path==`/`].id' --output text)
```

## 2. Create new resource and method

```sh
# Create new resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/create-resource.html)
awslocal apigateway create-resource --rest-api-id ${API_ID} --parent-id ${ROOT_ID} --path-part 'get'

# Get the resource ID for PATH /get
RSC_GET_ID=$(awslocal apigateway get-resources --rest-api-id ${API_ID} --query 'items[?path==`/get`].id' --output text)

# Add a method to an existing Resource resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/put-method.html)
awslocal apigateway put-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --authorization-type NONE

# Adds a MethodResponse to an existing Method resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/put-method-response.html)
awslocal apigateway put-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 --response-models '{"application/json": "Empty"}'

# Sets up a method's integration (https://docs.aws.amazon.com/cli/latest/reference/apigateway/put-integration.html)
awslocal apigateway put-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --type HTTP --integration-http-method GET --uri https://httpbin.org/get

# Represents a put integration (https://docs.aws.amazon.com/cli/latest/reference/apigateway/put-integration-response.html)
awslocal apigateway put-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 --response-templates '{"application/json": ""}'
```

## 3. List all resources and methods

```sh
awslocal apigateway get-resources --rest-api-id ${API_ID}

# Describe an existing Method resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-method.html)
awslocal apigateway get-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET

# Describes a MethodResponse resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-method-response.html)
awslocal apigateway get-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200

# Get the integration settings (https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-integration.html)
awslocal apigateway get-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET

# Represents a get integration response (https://docs.aws.amazon.com/cli/latest/reference/apigateway/get-integration-response.html)
awslocal apigateway get-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200
```

## 4. Invoke the API

```sh
# Simulate the invocation of a Method in your RestApi with headers, parameters, and an incoming request body (https://docs.aws.amazon.com/cli/latest/reference/apigateway/test-invoke-method.html)
awslocal apigateway test-invoke-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --path-with-query-string '/get?foo=bar'
```

## 5. Clean up

```sh
# Represents a delete integration response (https://docs.aws.amazon.com/cli/latest/reference/apigateway/delete-integration-response.html)
awslocal apigateway delete-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200

# Represents a delete integration (https://docs.aws.amazon.com/cli/latest/reference/apigateway/delete-integration.html)
awslocal apigateway delete-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET

# Deletes an existing MethodResponse resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/delete-method-response.html)
awslocal apigateway delete-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200

# Deletes an existing Method resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/delete-method.html)
awslocal apigateway delete-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET

# Deletes a Resource resource (https://docs.aws.amazon.com/cli/latest/reference/apigateway/delete-resource.html)
awslocal apigateway delete-resource --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID}

# Deletes the specified API (https://docs.aws.amazon.com/cli/latest/reference/apigateway/delete-rest-api.html)
awslocal apigateway delete-rest-api --rest-api-id ${API_ID}
```
