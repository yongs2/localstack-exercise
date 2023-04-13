# [Resource Groups Tagging API](https://docs.localstack.cloud/references/coverage/coverage_resourcegroupstaggingapi/)

See [Resource Groups Tagging API](https://docs.aws.amazon.com/resourcegroupstagging/latest/APIReference/overview.html)

## 1. Create ec2 vpc and tag it

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

## 2. GetResources

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

## 3. GetTagKeys

```sh
# Returns all tag keys currently in use in the specified Amazon Web Services Region for the calling account (https://docs.aws.amazon.com/cli/latest/reference/resourcegroupstaggingapi/get-tag-keys.html)
awslocal resourcegroupstaggingapi \
  get-tag-keys
```

## 4. GetTagValues

```sh
# Returns all tag values for the specified key that are used in the specified Amazon Web Services Region for the calling account (https://docs.aws.amazon.com/cli/latest/reference/resourcegroupstaggingapi/get-tag-values.html)
awslocal resourcegroupstaggingapi \
  get-tag-values \
    --key Environment
```

## 5. Clean up

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
