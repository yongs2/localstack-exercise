variable "cidrBlock" {
  default = "10.0.0.0/16"
}

# awslocal ec2 \
#   create-vpc \
#   --cidr-block ${CIDR_BLOCK}
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidrBlock

  tags = {
    Environment = "local"
  }
}

# awslocal ec2 \
#   create-tags \
#   --resources ${VPC_ID} \
#   --tags Key=Environment,Value=Production
resource "aws_ec2_tag" "example" {
  resource_id = aws_vpc.my_vpc.id
  key         = "Environment"
  value       = "Production"
}

# awslocal resourcegroupstaggingapi \
#   get-resources \
#     --tag-filters Key=Environment,Values=Production \
#     --tags-per-page 100
data "aws_resourcegroupstaggingapi_resources" "tagKey" {
  tag_filter {
    key    = "Environment"
    values = ["Production"]
  }
}

# return tagKey
output "tagKey" {
  value = data.aws_resourcegroupstaggingapi_resources.tagKey
}

# awslocal resourcegroupstaggingapi \
#   get-resources \
#     --resource-type-filters ec2
data "aws_resourcegroupstaggingapi_resources" "tagEc2" {
  resource_type_filters = ["ec2"]
}

# return tagEc2
output "tagEc2" {
  value = data.aws_resourcegroupstaggingapi_resources.tagEc2
}

# Get All Resource Tag Mappings
data "aws_resourcegroupstaggingapi_resources" "tagAll" {}

# return all
output "tagAll" {
  value = data.aws_resourcegroupstaggingapi_resources.tagAll
}
