# [Deploy Serverless Applications with AWS Lambda and API Gateway](https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway) 

## Init

```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

## Create and upload Lambda function archive

- invoke it using the AWS CLI

```sh
awslocal lambda invoke --function-name=$(terraform output -raw function_name) /tmp/response.json
cat /tmp/response.json
```

## Create an HTTP API with API Gateway

```sh
curl -X GET "$(terraform output -raw base_url)"
```

## Cleanup

```sh
terraform destroy -auto-approve
```
