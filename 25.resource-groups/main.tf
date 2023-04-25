variable "rgName1" {
  default = "resource-group-name"
}

variable "rgName2" {
  default = "my-resource-group"
}

# awslocal resource-groups \
#   create-group \
#     --name resource-group-name \
#     --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"resource_type1\",\"resource_type2\"],\"TagFilters\":[{\"Key\":\"Key1\",\"Values\":[\"Value1\",\"Value2\"]},{\"Key\":\"Key2\",\"Values\":[\"Value1\",\"Value2\"]}]}"}'
resource "aws_resourcegroups_group" "example1" {
  name = var.rgName1
  resource_query {
    type = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters = ["resource_type1", "resource_type2"]
      TagFilters = [
        {
          Key    = "Key1"
          Values = ["Value1", "Value2"]
        },
        {
          Key    = "Key2"
          Values = ["Value1", "Value2"]
        }
      ]
    })
  }
}

# return resouce-group of example1
output "example1" {
  value = aws_resourcegroups_group.example1
}

# awslocal resource-groups \
#   create-group \
#     --name my-resource-group \
#     --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::EC2::Instance\"],\"TagFilters\":[{\"Key\":\"Stage\",\"Values\":[\"Test\"]}]}"}'
resource "aws_resourcegroups_group" "example2" {
  name = var.rgName2
  resource_query {
    type = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters = ["AWS::EC2::Instance"]
      TagFilters = [
        {
          Key    = "Stage"
          Values = ["Test"]
        }
      ]
    })
  }
}

# return resouce-group of example2
output "example2" {
  value = aws_resourcegroups_group.example2
}
