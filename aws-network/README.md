# AWS Network

See [AWS Network](https://github.com/pjt3591oo/aws-network-terraform)

## 1. Using terraform

- [Resource: aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Resource: aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Resource: aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
- [Resource: aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)
- [Resource: aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)
- [Resource: aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- [Resource: aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)

### 2.1 Create a network

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

- Using tfvars to separate dev, stage, and prod

```sh
# dev
terraform apply -var-file=dev.tfvars -state-out=terraform.tfstate.dev -auto-approve

# stage
terraform apply -var-file=stage.tfvars -state-out=terraform.tfstate.stage -auto-approve

# Production
terraform apply -var-file=prod.tfvars -state-out=terraform.tfstate.prod -auto-approve

```

### 2.2 List all network resources

```sh
# dev
terraform output -state=terraform.tfstate.dev
terraform state list -state=terraform.tfstate.dev

# stage
terraform output -state=terraform.tfstate.stage
terraform state list -state=terraform.tfstate.stage

# Production
terraform output -state=terraform.tfstate.prod
terraform state list -state=terraform.tfstate.prod

# dev: 10.10.0.0/16, stage: 10.11.0.0/16, prod: 10.12.0.0/16
CIDR_PREFIX="10.10."
awslocal ec2 describe-vpcs --query 'Vpcs[?contains(CidrBlock, `'${CIDR_PREFIX}'`)]'
awslocal ec2 describe-subnets --query 'Subnets[?contains(CidrBlock, `'${CIDR_PREFIX}'`)]'

# gateways
awslocal ec2 describe-internet-gateways
awslocal ec2 describe-nat-gateways
# for EIP
awslocal ec2 describe-addresses
awslocal ec2 describe-route-tables
```

### 2.3 Delete a network

```sh
# dev
terraform destroy -state=terraform.tfstate.dev -auto-approve

# stage
terraform destroy -state=terraform.tfstate.stage -auto-approve

# Production
terraform destroy -state=terraform.tfstate.prod -auto-approve
```
