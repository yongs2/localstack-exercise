# VPC
resource "aws_vpc" "vpc1" {
  cidr_block           = var.cidrVpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = var.tagNameVpc
  }
}
