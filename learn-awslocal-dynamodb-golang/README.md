# [Setup a mock AWS locally using Localstack](https://hsingh.dev/setup-a-mock-aws-locally-using-localstack)

## Set up golang-dev

```sh
cat /etc/os-release

# for Alpine Linux v3.17 in hashicorp/terraform:1.4.5
apk add go
```

## Creating a Table, Populating the table and Retrieving all Data

```sh
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"
export LOCALSTACK_ENDPOINT="http://localhost:4566"

make run
```

## Delete a table

```sh
make clean
```
