variable "apiName" {
  default = "My First API"
}

# awslocal apigateway create-rest-api --name 'My First API' --description 'This is my first API'
resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = var.apiName
  description = "This is my first API"
}

# return the ID of the API
output "api_id" {
  value = aws_api_gateway_rest_api.MyDemoAPI.id
}

# awslocal apigateway create-resource --rest-api-id ${API_ID} --parent-id ${ROOT_ID} --path-part 'get'
resource "aws_api_gateway_resource" "MyDemoResource" {
  depends_on = [aws_api_gateway_rest_api.MyDemoAPI]

  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "get"
}

# return the ID of the resource
output "resource_id" {
  value = aws_api_gateway_resource.MyDemoResource.id
}

# awslocal apigateway put-method --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --authorization-type NONE
resource "aws_api_gateway_method" "MyDemoMethod" {
  depends_on = [aws_api_gateway_resource.MyDemoResource]

  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "GET"
  authorization = "NONE"
}

# awslocal apigateway put-method-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 --response-models '{"application/json": "Empty"}'
resource "aws_api_gateway_method_response" "response_200" {
  depends_on = [aws_api_gateway_method.MyDemoMethod]

  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = "GET"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

# awslocal apigateway put-integration --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --type HTTP --integration-http-method GET --uri https://httpbin.org/get
resource "aws_api_gateway_integration" "MyDemoIntegration" {
  depends_on = [aws_api_gateway_method_response.response_200]

  rest_api_id             = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id             = aws_api_gateway_resource.MyDemoResource.id
  http_method             = aws_api_gateway_method.MyDemoMethod.http_method
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = "https://httpbin.org/get"
}

# awslocal apigateway put-integration-response --rest-api-id ${API_ID} --resource-id ${RSC_GET_ID} --http-method GET --status-code 200 --response-templates '{"application/json": ""}'
resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  depends_on = [aws_api_gateway_integration.MyDemoIntegration]

  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = {
    "application/json" = ""
  }
}
