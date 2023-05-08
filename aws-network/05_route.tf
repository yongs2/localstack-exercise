# Public Route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.tagNamePubRouteTable
  }
}

# Private Route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = var.tagNamePriRouteTable
  }
}

# Subnet Route table
locals {
  pub_subnet_ids = ["${aws_subnet.pub-subnet1.id}", "${aws_subnet.pub-subnet2.id}"]
  pri_subnet_ids = ["${aws_subnet.pri-subnet1.id}", "${aws_subnet.pri-subnet2.id}"]
}

resource "aws_route_table_association" "public-route-table-association" {
  count          = length(local.pub_subnet_ids)
  subnet_id      = local.pub_subnet_ids[count.index]
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-route-table-association" {
  count          = length(local.pri_subnet_ids)
  subnet_id      = local.pri_subnet_ids[count.index]
  route_table_id = aws_route_table.private-route-table.id
}
