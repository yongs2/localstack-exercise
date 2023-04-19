# awslocal dynamodb create-table \
#     --table-name global01 \
#     --key-schema AttributeName=id,KeyType=HASH \
#     --attribute-definitions AttributeName=id,AttributeType=S \
#     --billing-mode PAY_PER_REQUEST \
#     --region ap-south-1
resource "aws_dynamodb_table" "global01" {
  name         = "global01"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "global01"
  }

  # replica-updates
  replica { # default region us-east-1
    region_name = "us-east-1"
  }

  replica {
    region_name = "ap-south-1"
  }

  replica {
    region_name = "eu-central-1"
  }

  replica {
    region_name = "us-west-1"
  }
}

# Output the certificate ARN
output "global01" {
  description = "table info"
  value       = aws_dynamodb_table.global01
}
