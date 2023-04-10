# [DynamoDB](https://docs.localstack.cloud/user-guide/aws/dynamodb/)

See [Amazon DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)

## 1. Create a table

```sh
awslocal dynamodb create-table \
    --table-name global01 \
    --key-schema AttributeName=id,KeyType=HASH \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --billing-mode PAY_PER_REQUEST \
    --region ap-south-1
```

## 2. Create replicas

```sh
awslocal dynamodb update-table \
    --table-name global01 \
    --replica-updates '[{"Create": {"RegionName": "eu-central-1"}}, {"Create": {"RegionName": "us-west-1"}}]' \
    --region ap-south-1
```

## 3. list tables

```sh
awslocal dynamodb list-tables --region eu-central-1
```

## 4. Put and Query

```sh
awslocal dynamodb put-item --table-name global01 --item '{"id":{"S":"foo"}}' --region eu-central-1
awslocal dynamodb describe-table --table-name global01 --query 'Table.ItemCount' --region ap-south-1
awslocal dynamodb describe-table --table-name global01 --query 'Table.Replicas' --region us-west-1
```

## 5. Delete table

```sh
awslocal dynamodb delete-table --table-name global01 --region ap-south-1
```
