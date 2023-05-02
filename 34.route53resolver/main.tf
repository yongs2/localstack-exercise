variable "cidr_1" {
  default = "10.0.1.0/24"
}

variable "ip_1" {
  default = "10.0.1.5"
}

variable "cidr_2" {
  default = "10.0.2.0/24"
}

variable "ip_2" {
  default = "10.0.2.6"
}

variable "securityGroupName" {
  default = "MySecurityGroup"
}

variable "resolverEndpointName" {
  default = "my-inbound-endpoint"
}

# awslocal ec2 \
# 	create-vpc \
# 		--cidr-block ${CIDR_1} \
# 		--tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]
resource "aws_vpc" "vpc1" {
  cidr_block = var.cidr_1
  tags = {
    Name = "MyVpc"
  }
}

# awslocal ec2 \
#   create-vpc \
# 	  --cidr-block ${CIDR_2} \
# 	  --tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]
resource "aws_vpc" "vpc2" {
  cidr_block = var.cidr_2
  tags = {
    Name = "MyVpc"
  }
}

# awslocal ec2 \
# 	create-subnet \
# 		--vpc-id ${VPC_ID_1} \
# 		--cidr-block ${CIDR_1} \
# 		--tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.cidr_1

  tags = {
    Name = "my-ipv4-only-subnet"
  }
}

# awslocal ec2 \
# 	create-subnet \
# 		--vpc-id ${VPC_ID_2} \
# 		--cidr-block ${CIDR_2} \
# 		--tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.cidr_2

  tags = {
    Name = "my-ipv4-only-subnet"
  }
}

# awslocal ec2 \
# 	create-security-group \
# 		--group-name ${GRP_NAME} \
# 		--description "My security group"
resource "aws_security_group" "MySecurityGroup" {
  name        = var.securityGroupName
  description = "My security group"
}

# awslocal route53resolver \
# 	create-resolver-endpoint \
# 		--name ${EP_NAME} \
# 		--creator-request-id 2020-01-01-18:47 \
# 		--security-group-ids ${SG_ID} \
# 		--direction INBOUND \
# 		--ip-addresses SubnetId=${SUBNET_ID_1},Ip=${IP_1} SubnetId=${SUBNET_ID_2},Ip=${IP_2}
resource "aws_route53_resolver_endpoint" "MyResolverEndpoint" {
  name      = var.resolverEndpointName
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.MySecurityGroup.id
  ]

  ip_address {
    subnet_id = aws_subnet.subnet1.id
    ip        = var.ip_1
  }

  ip_address {
    subnet_id = aws_subnet.subnet2.id
    ip        = var.ip_2
  }

  tags = {
    Environment = "Local"
  }
}

# return a resolver endpoint
output "MyResolverEndpoint" {
  value = aws_route53_resolver_endpoint.MyResolverEndpoint
}
