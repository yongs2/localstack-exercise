# VPC
variable "cidrVpc" {
  default = "10.10.0.0/16"
}

variable "tagNameVpc" {
  default = "vpc"
}

# Public Subnet1
variable "cidrPubSubnet1" {
  default = "10.10.1.0/24"
}

variable "tagNamePubSubnet1" {
  default = "pub-subnet1"
}

variable "outpostArnPubSubnet1" {
  default = ""
}

# Public Subnet2
variable "cidrPubSubnet2" {
  default = "10.10.2.0/24"
}

variable "tagNamePubSubnet2" {
  default = "pub-subnet2"
}

variable "outpostArnPubSubnet2" {
  default = ""
}

# Private Subnet1
variable "cidrPriSubnet1" {
  default = "10.10.3.0/24"
}

variable "tagNamePriSubnet1" {
  default = "pri-subnet1"
}

variable "outpostArnPriSubnet1" {
  default = ""
}

# Private Subnet2
variable "cidrPriSubnet2" {
  default = "10.10.4.0/24"
}

variable "tagNamePriSubnet2" {
  default = "pri-subnet2"
}

variable "outpostArnPriSubnet2" {
  default = ""
}

# Internet gateway
variable "tagNameIgw" {
  default = "igw"
}

# EIP
variable "tagNameEip" {
  default = "eip"
}

# NAT Gateway
variable "tagNameNatgw" {
  default = "natgw"
}

# Public Route table
variable "tagNamePubRouteTable" {
  default = "public-route-table"
}

# Private Route table
variable "tagNamePriRouteTable" {
  default = "private-route-table"
}
