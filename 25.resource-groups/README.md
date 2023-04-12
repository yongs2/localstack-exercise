# [resource-groups](https://docs.localstack.cloud/references/coverage/coverage_resource-groups/)

See [AWS Resource Groups](https://docs.aws.amazon.com/ARG/latest/userguide/resource-groups.html)

## 1. Creates a resource group

```sh
# Creates a resource group with the specified name and description (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/create-group.html)
awslocal resource-groups \
  create-group \
    --name resource-group-name \
    --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"resource_type1\",\"resource_type2\"],\"TagFilters\":[{\"Key\":\"Key1\",\"Values\":[\"Value1\",\"Value2\"]},{\"Key\":\"Key2\",\"Values\":[\"Value1\",\"Value2\"]}]}"}'

awslocal resource-groups \
  create-group \
    --name my-resource-group \
    --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::EC2::Instance\"],\"TagFilters\":[{\"Key\":\"Stage\",\"Values\":[\"Test\"]}]}"}'
```

## 2. Get a resource group

```sh
# Returns information about a specified resource group (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/get-group.html)
awslocal resource-groups \
  get-group \
    --group-name resource-group-name

awslocal resource-groups \
  get-group \
    --group-name my-resource-group

# Retrieves the resource query associated with the specified resource group (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/get-group-query.html)
awslocal resource-groups \
  get-group-query \
    --group-name resource-group-name

awslocal resource-groups \
  get-group-query \
    --group-name my-resource-group
```

## 3. list all resource groups

```sh
# Returns a list of existing Resource Groups in your account (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/list-groups.html)
awslocal resource-groups list-groups
```

## 4. Update a resource group

```sh
# Updates the description for an existing group (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/update-group.html)
awslocal resource-groups \
  update-group \
    --group-name my-resource-group \
    --description "EC2 instances S3 buckets and RDS DBs that we are using for the test stage."

# Updates the resource query of a group (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/update-group-query.html)
awslocal resource-groups \
  update-group-query \
    --group-name resource-group-name \
    --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"resource_type1\",\"resource_type2\"],\"TagFilters\":[{\"Key\":\"Key1\",\"Values\":[\"Value1\",\"Value2\"]},{\"Key\":\"Key2\",\"Values\":[\"Value1\",\"Value2\"]}]}"}'

awslocal resource-groups \
  update-group-query \
    --group-name my-resource-group \
    --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::EC2::Instance\",\"AWS::S3::Bucket\",\"AWS::RDS::DBInstance\"],\"TagFilters\":[{\"Key\":\"Stage\",\"Values\":[\"Test\"]}]}"}'
```

## 6. Clean up

```sh
# Deletes the specified resource group (https://docs.aws.amazon.com/cli/latest/reference/resource-groups/delete-group.html)
awslocal resource-groups \
  delete-group \
  --group-name resource-group-name
awslocal resource-groups list-groups

awslocal resource-groups \
  delete-group \
  --group-name my-resource-group
awslocal resource-groups list-groups
```
