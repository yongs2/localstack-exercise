# [Elastic Compute Cloud (EC2)](https://docs.localstack.cloud/user-guide/aws/elastic-compute-cloud/)

See [Amazon Elastic Compute Cloud](hhttps://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

## 1. Using AWS CLI

### 1.1 list all image list

```sh
awslocal ec2 describe-images --query 'Images[].ImageId' --output json
```

### 1.2 Create Security Group

```sh
# Creates a security group (https://docs.aws.amazon.com/cli/latest/reference/ec2/create-security-group.html)
awslocal ec2 create-security-group --group-name default --description "My security group"

# Adds the specified inbound (ingress) rules to a security group. (https://docs.aws.amazon.com/cli/latest/reference/ec2/authorize-security-group-ingress.html)
awslocal ec2 authorize-security-group-ingress \
  --group-name default \
  --protocol tcp \
  --port 8080

# Describes the specified security groups or all of your security groups (https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html)
SG_ID=$(awslocal ec2 \
  describe-security-groups \
  --group-names default \
  --output json \
  --query 'SecurityGroups[0].GroupId' \
  --output text)
```

### 1.3 Create Key Pair

```sh
KEY_NAME=mung-key

# Creates key pair (https://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html)
awslocal ec2 create-key-pair --key-name ${KEY_NAME}

# Describes the specified key pairs or all of your key pairs (https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-key-pairs.html)
awslocal ec2 describe-key-pairs --key-name ${KEY_NAME}
```

### 1.4 Create ec2 instance

```sh
# Launches the specified number of instances using an AMI for which you have permissions (https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html)
awslocal ec2 run-instances \
  --image-id ami-0c2b8ca1dad447f8a \
  --count 1 \
  --instance-type t2.micro \
  --key-name ${KEY_NAME} \
  --security-group-ids ${SG_ID}
```

### 1.5 List all ec2 instances

```sh
# list all ec2 instances (https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html)
awslocal ec2 describe-instances

# list all key pairs (https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-key-pairs.html)
awslocal ec2 describe-key-pairs

# Describes the specified security groups or all of your security groups. (https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html)
awslocal ec2 describe-security-groups
```

### 1.6 Clean up

```sh
# Get ec2 instance id
INST_ID=$(awslocal ec2 \
  describe-instances \
  --query 'Reservations[].Instances[?KeyName==`'${KEY_NAME}'`].InstanceId' \
  --output text)

# Shuts down the specified instances (https://docs.aws.amazon.com/cli/latest/reference/ec2/terminate-instances.html)
awslocal ec2 terminate-instances --instance-ids ${INST_ID}

# check ec2 instance status
awslocal ec2 \
  describe-instances \
  --query 'Reservations[].Instances[?InstanceId==`'${INST_ID}'`].State.Name' \
  --output text

# Deletes the specified key pair (https://docs.aws.amazon.com/cli/latest/reference/ec2/delete-key-pair.html)
awslocal ec2 \
  delete-key-pair \
  --key-name ${KEY_NAME}

# Deletes a security group. (https://docs.aws.amazon.com/cli/latest/reference/ec2/delete-security-group.html)
awslocal ec2 delete-security-group --group-name default
```

## 2. Using terraform

- [Resource: aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [Resource: aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
- [Resource: aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

### 2.1 Create a ec2 instance

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List all ec2 instances

```sh
awslocal ec2 describe-instances
awslocal ec2 describe-key-pairs
awslocal ec2 describe-security-groups
```

### 2.3 Stop the ec2 instance

```sh
terraform destroy -auto-approve
```
