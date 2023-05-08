# [Manage AWS DynamoDB Scale](https://developer.hashicorp.com/terraform/tutorials/aws/aws-dynamodb-scale)

## Init

```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

## Changes

- Removed "Configure autoscaling", This is because Application Auto Scaling is supported by LocalStack only in the pro version

## Query your data

### Get table name

```sh
TABLE_NAME=$(terraform output -raw environment_table_name)
```

### Query your table for events for a specific device ID, b6c772c6-d621-46ff-86c6-7c662de62375

```sh
awslocal dynamodb \
  query \
    --table-name ${TABLE_NAME} \
    --region us-east-1 \
    --key-condition-expression "deviceId = :device" \
    --expression-attribute-values '{":device": {"S": "b6c772c6-d621-46ff-86c6-7c662de62375"}}'
```

### Query events by device ID, within a time range, using the us-east-1 global table replica.

```sh
awslocal dynamodb \
  query \
    --table-name ${TABLE_NAME} \
    --region us-east-1 \
    --key-condition-expression "deviceId = :device and (epochS between :start and :end)" \
    --expression-attribute-values '{":device": {"S": "b6c772c6-d621-46ff-86c6-7c662de62375"}, ":start": {"N": "1649257000"}, ":end": {"N": "1649260000"}}'
```

### Query events by geoLocation

```sh
awslocal dynamodb \
  query \
    --table-name ${TABLE_NAME} \
    --region us-east-1 \
    --index-name by_geoLocation \
    --key-condition-expression "geoLocation = :loc" \
    --expression-attribute-values '{":loc": {"S": "Earth-US-CA-Berkely"}}'
```

## Cleanup

```sh
terraform destroy -auto-approve
```
