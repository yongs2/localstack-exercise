# [DynamoDB](https://docs.localstack.cloud/user-guide/aws/dynamodb/)

See [Amazon DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)

## 1. Using AWS CLI

### 1.1 Create a table

```sh
awslocal dynamodb create-table \
    --table-name global01 \
    --key-schema AttributeName=id,KeyType=HASH \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --billing-mode PAY_PER_REQUEST \
    --region ap-south-1
```

### 1.2 Create replicas

```sh
awslocal dynamodb update-table \
    --table-name global01 \
    --replica-updates '[{"Create": {"RegionName": "eu-central-1"}}, {"Create": {"RegionName": "us-west-1"}}]' \
    --region ap-south-1
```

### 1.3 list tables

```sh
awslocal dynamodb list-tables --region us-east-1    # default region us-east-1
awslocal dynamodb list-tables --region ap-south-1
awslocal dynamodb list-tables --region eu-central-1
awslocal dynamodb list-tables --region us-west-1
```

### 1.4 Put and Query

```sh
awslocal dynamodb put-item --table-name global01 --item '{"id":{"S":"foo"}}' --region eu-central-1
awslocal dynamodb describe-table --table-name global01 --query 'Table.ItemCount' --region ap-south-1
awslocal dynamodb describe-table --table-name global01 --query 'Table.Replicas' --region us-west-1
```

### 1.5 Delete table

```sh
awslocal dynamodb delete-table --table-name global01 --region ap-south-1
```

## 2. Using terraform

- [Resource: aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)

### 2.1 Create a table

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 list tables

```sh
awslocal dynamodb list-tables --region us-east-1    # default region us-east-1
awslocal dynamodb list-tables --region ap-south-1
awslocal dynamodb list-tables --region eu-central-1
awslocal dynamodb list-tables --region us-west-1
```

### 2.3 Put item and Query

```sh
awslocal dynamodb put-item --table-name global01 --item '{"id":{"S":"foo"}}' --region eu-central-1
awslocal dynamodb describe-table --table-name global01 --query 'Table.ItemCount' --region ap-south-1
awslocal dynamodb describe-table --table-name global01 --query 'Table.Replicas' --region us-west-1
```

### 2.4 Delete table

```sh
terraform destroy -auto-approve
```
