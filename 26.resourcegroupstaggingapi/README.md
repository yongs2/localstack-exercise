# [Resource Groups Tagging API](https://docs.localstack.cloud/references/coverage/coverage_resourcegroupstaggingapi/)

See [Resource Groups Tagging API](https://docs.aws.amazon.com/resourcegroupstagging/latest/APIReference/overview.html)

## 1. Using AWS CLI

### 1.1 Create ec2 vpc and tag it

- [Refer test case](https://github.com/localstack/localstack/blob/master/tests/integration/test_rgsa.py)

```sh
CIDR_BLOCK="10.0.0.0/16"
# create ec2 vpc
awslocal ec2 \
  create-vpc \
  --cidr-block ${CIDR_BLOCK}

# get vpc id
VPC_ID=$(awslocal ec2 \
  describe-vpcs \
  --query 'Vpcs[?CidrBlock==`'${CIDR_BLOCK}'`].VpcId' \
  --output text)

# create tag
awslocal ec2 \
  create-tags \
  --resources ${VPC_ID} \
  --tags Key=Environment,Value=Production
```

### 1.2 GetResources

```sh
# Returns all the tagged or previously tagged resources that are located in the specified Amazon Web Services Region for the account (https://docs.aws.amazon.com/cli/latest/reference/resourcegroupstaggingapi/get-resources.html)
awslocal resourcegroupstaggingapi \
  get-resources \
    --tag-filters Key=Environment,Values=Production \
    --tags-per-page 100

awslocal resourcegroupstaggingapi \
  get-resources \
    --resource-type-filters ec2
```

### 1.3 GetTagKeys

```sh
# Returns all tag keys currently in use in the specified Amazon Web Services Region for the calling account (https://docs.aws.amazon.com/cli/latest/reference/resourcegroupstaggingapi/get-tag-keys.html)
awslocal resourcegroupstaggingapi \
  get-tag-keys
```

### 1.4 GetTagValues

```sh
# Returns all tag values for the specified key that are used in the specified Amazon Web Services Region for the calling account (https://docs.aws.amazon.com/cli/latest/reference/resourcegroupstaggingapi/get-tag-values.html)
awslocal resourcegroupstaggingapi \
  get-tag-values \
    --key Environment
```

### 1.5 Clean up

```sh
# delete tag
awslocal ec2 \
		delete-tags \
		--resources ${VPC_ID} \
		--tags Key=Environment,Value=Production
    
# delete vpc
awslocal ec2 delete-vpc \
  --vpc-id ${VPC_ID}
```

## 2. Using terraform

- [Data Source: aws_resourcegroupstaggingapi_resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/resourcegroupstaggingapi_resources)

### 2.1 Create a resource group

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 GetTagKeys

```sh
awslocal resourcegroupstaggingapi \
  get-tag-keys
```

### 2.3 GetTagValues

```sh
awslocal resourcegroupstaggingapi \
  get-tag-values \
    --key Environment
```

### 2.4 Delete the resource group

```sh
terraform destroy -auto-approve
```
