# Public Subnet 1
resource "aws_subnet" "pub-subnet1" {
  vpc_id                          = aws_vpc.vpc1.id
  cidr_block                      = var.cidrPubSubnet1
  map_customer_owned_ip_on_launch = false
  customer_owned_ipv4_pool        = true
  outpost_arn                     = var.outpostArnPubSubnet1
  availability_zone               = "us-east-1a"

  tags = {
    Name = var.tagNamePubSubnet1
  }
}

# Public Subnet 2
resource "aws_subnet" "pub-subnet2" {
  vpc_id                          = aws_vpc.vpc1.id
  cidr_block                      = var.cidrPubSubnet2
  map_customer_owned_ip_on_launch = false
  customer_owned_ipv4_pool        = true
  outpost_arn                     = var.outpostArnPubSubnet2
  availability_zone               = "us-east-1b"

  tags = {
    Name = var.tagNamePubSubnet2
  }
}

# Private Subnet 1
resource "aws_subnet" "pri-subnet1" {
  vpc_id                          = aws_vpc.vpc1.id
  cidr_block                      = var.cidrPriSubnet1
  map_customer_owned_ip_on_launch = false
  customer_owned_ipv4_pool        = true
  outpost_arn                     = var.outpostArnPriSubnet1
  availability_zone               = "us-east-1a"

  tags = {
    Name = var.tagNamePriSubnet1
  }
}

# Private Subnet 2
resource "aws_subnet" "pri-subnet2" {
  vpc_id                          = aws_vpc.vpc1.id
  cidr_block                      = var.cidrPriSubnet2
  map_customer_owned_ip_on_launch = false
  customer_owned_ipv4_pool        = true
  outpost_arn                     = var.outpostArnPriSubnet2
  availability_zone               = "us-east-1b"

  tags = {
    Name = var.tagNamePriSubnet2
  }
}
