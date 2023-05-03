# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = var.tagNameIgw
  }
}

# EIP for NAT Gateway
# https://docs.aws.amazon.com/cli/latest/reference/ec2/associate-address.html
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = var.tagNameEip
  }

  # EIP may require IGW to exist prior to association
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub-subnet1.id

  tags = {
    Name = var.tagNameNatgw
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
