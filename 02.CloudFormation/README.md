# [CloudFormation](https://docs.localstack.cloud/user-guide/aws/cloudformation/)

See [AWSCloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)

## 1. Using AWS CLI

### 1.1 Deploy the bucket on LocalStack

```sh
# The template file (ending with .yaml or .json) should contain the stack content from above
awslocal cloudformation deploy --stack-name cfn-quickstart-stack --template-file "./cfn-quickstart-stack.yaml"
awslocal cloudformation list-stacks

# Verify the bucket was created successfully
# The output should include a bucket with the name cfn-quickstart-bucket
awslocal s3api list-buckets

# Delete the stack (this will also delete the bucket)
awslocal cloudformation delete-stack --stack-name cfn-quickstart-stack
```

### 1.2 deploy the EC2 instance on LocalStack

```sh
awslocal cloudformation deploy --stack-name ec2-instance --template-file "./ec2-instance.yaml"

awslocal cloudformation list-stacks

awslocal ec2 describe-instances

awslocal cloudformation delete-stack --stack-name ec2-instance
```

## 2. Using terraform

- [Resource: aws_cloudformation_stack](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack)

### 2.1 Deploy the bucket and EC2 instance on LocalStack

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List stacks and check the bucket and EC2 instance

```sh
awslocal cloudformation list-stacks

awslocal s3api list-buckets
awslocal ec2 describe-instances
```

### 2.3 Delete the stack

```sh
terraform destroy -auto-approve
```
