# [Route 53 Resolver](https://docs.localstack.cloud/references/coverage/coverage_route53resolver/)

See [Amazon Route 53 Resolver](https://docs.aws.amazon.com/Route53/latest/APIReference/API_Operations_Amazon_Route_53_Resolver.html)

## 1. Using AWS CLI

### 1.1 CreateResolverEndpoint

```sh
# Create VPC
CIDR_1="10.0.1.0/24"
awslocal ec2 \
  create-vpc \
    --cidr-block ${CIDR_1} \
    --tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]

VPC_ID_1=$(awslocal ec2 \
  describe-vpcs \
    --query 'Vpcs[?CidrBlock==`'${CIDR_1}'`].VpcId' \
    --output text)

# Create Subnet_1
awslocal ec2 \
  create-subnet \
    --vpc-id ${VPC_ID_1} \
    --cidr-block ${CIDR_1} \
    --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]

SUBNET_ID_1=$(awslocal ec2 \
  describe-subnets \
    --query 'Subnets[?VpcId==`'${VPC_ID_1}'`].SubnetId' \
    --output text)

awslocal ec2 \
  describe-subnets \
    --subnet-ids ${SUBNET_ID_1}

# Create VPC
CIDR_2="10.0.2.0/24"
awslocal ec2 \
  create-vpc \
    --cidr-block ${CIDR_2} \
    --tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]

VPC_ID_2=$(awslocal ec2 \
  describe-vpcs \
    --query 'Vpcs[?CidrBlock==`'${CIDR_2}'`].VpcId' \
    --output text)

# Create Subnet_2
awslocal ec2 \
  create-subnet \
    --vpc-id ${VPC_ID_2} \
    --cidr-block ${CIDR_2} \
    --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]

SUBNET_ID_2=$(awslocal ec2 \
  describe-subnets \
    --query 'Subnets[?VpcId==`'${VPC_ID_2}'`].SubnetId' \
    --output text)

awslocal ec2 \
  describe-subnets \
    --subnet-ids ${SUBNET_ID_2}

# Create Security Group
GRP_NAME=MySecurityGroup
awslocal ec2 \
  create-security-group \
    --group-name ${GRP_NAME} \
    --description "My security group"

SG_ID=$(awslocal ec2 \
  describe-security-groups \
    --query 'SecurityGroups[?GroupName==`'${GRP_NAME}'`].GroupId' \
    --output text)

# Creates a Resolver endpoint (https://docs.aws.amazon.com/cli/latest/reference/route53resolver/create-resolver-endpoint.html)
EP_NAME=my-inbound-endpoint
awslocal route53resolver \
  create-resolver-endpoint \
    --name ${EP_NAME} \
    --creator-request-id 2020-01-01-18:47 \
    --security-group-ids ${SG_ID} \
    --direction INBOUND \
    --ip-addresses SubnetId=${SUBNET_ID_1},Ip=10.0.1.5 SubnetId=${SUBNET_ID_2},Ip=10.0.2.6

# [in a subnet with CIDR block 10.0.0.0/24, the following five IP addresses are reserved (0~3,255)](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html)
```

### 1.2 ListResolverEndpoints

```sh
# Lists all the Resolver endpoints that were created using the current Amazon Web Services account (https://docs.aws.amazon.com/cli/latest/reference/route53resolver/list-resolver-endpoints.html)
awslocal route53resolver list-resolver-endpoints

REP_ID=$(awslocal route53resolver \
  list-resolver-endpoints \
    --query 'ResolverEndpoints[?Name==`'${EP_NAME}'`].Id' \
    --output text)
```

### 1.3 GetResolverEndpoint

```sh
# Gets information about a specified Resolver endpoint, such as whether it's an inbound or an outbound Resolver endpoint, and the current status of the endpoint (https://docs.aws.amazon.com/cli/latest/reference/route53resolver/get-resolver-endpoint.html)

awslocal route53resolver \
  get-resolver-endpoint \
    --resolver-endpoint-id ${REP_ID}
```

### 1.4 DeleteResolverEndpoint

```sh
# Deletes a Resolver endpoint (https://docs.aws.amazon.com/cli/latest/reference/route53resolver/delete-resolver-endpoint.html)
awslocal route53resolver \
  delete-resolver-endpoint \
    --resolver-endpoint-id ${REP_ID}

# Clean up
awslocal ec2 delete-security-group --group-id ${SG_ID}
awslocal ec2 delete-subnet --subnet-id ${SUBNET_ID_2}
awslocal ec2 delete-subnet --subnet-id ${SUBNET_ID_1}
awslocal ec2 delete-vpc --vpc-id ${VPC_ID_2}
awslocal ec2 delete-vpc --vpc-id ${VPC_ID_1}
```

## 2. Using terraform

- [Resource: aws_route53_resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint)

### 2.1 Create a Route 53 Resolver endpoint

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Delete a Route 53 Resolver endpoint

```sh
terraform destroy -auto-approve
```
