# return vpc info
output "vpc" {
  value = aws_vpc.vpc1.id
}

# return subnet info
output "subnet" {
  value = {
    pub_subnet1 = aws_subnet.pub-subnet1.arn
    pub_subnet2 = aws_subnet.pub-subnet2.arn
    pri_subnet1 = aws_subnet.pri-subnet1.arn
    pri_subnet2 = aws_subnet.pri-subnet2.arn
  }
}

# return gateway info
output "igw" {
  value = aws_internet_gateway.igw.id
}

output "natgw" {
  value = aws_nat_gateway.natgw.id
}

# return eip
output "eip" {
  value = aws_eip.eip.public_ip
}

# return route-table info
output "route-table" {
  value = {
    public_route = {
      table_id = aws_route_table.public-route-table.id
      assoc_ids  = [for a in aws_route_table_association.public-route-table-association : a.id]
    }
    private_route = {
      table_id = aws_route_table.private-route-table.id
      assoc_ids  = [for a in aws_route_table_association.private-route-table-association : a.id]
    }
  }
}
