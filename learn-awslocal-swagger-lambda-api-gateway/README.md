# [INFRASTRUCTURE AS CODE: TERRAFORM AND AWS SERVERLESS](https://ordina-jworks.github.io/cloud/2019/01/14/Infrastructure-as-code-with-terraform-and-aws-serverless.html)

Refer [codingtips-blog](https://gitlab.com/nxtra/codingtips-blog)

## Init

```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

## list Resources

```sh
awslocal lambda list-functions
awslocal dynamodb list-tables
awslocal apigateway get-rest-apis
```

## test

```sh
# post data
curl -v -X POST $(terraform output -raw base_url) \
-H 'Content-Type: application/json' -d '
{
  "author": "test1",
  "tip": "The coding tip",
  "category": "coding"
}'

# get data
curl -v -X GET $(terraform output -raw base_url)
```

## Clean up

```sh
terraform destroy -auto-approve
```
