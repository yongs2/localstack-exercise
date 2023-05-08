# Defines a DynamoDB table with a randomly generated name
resource "random_pet" "table_name" {
  prefix    = "environment"
  separator = "_"
  length    = 4
}

resource "aws_dynamodb_table" "environment" {
  name         = random_pet.table_name.id
  billing_mode = "PROVISIONED"
  table_class  = "STANDARD_INFREQUENT_ACCESS"

  # Configure provisioned capacity
  read_capacity  = var.env_table_read_capacity
  write_capacity = var.env_table_write_capacity

  # Manage TTL
  ttl {
    enabled        = true
    attribute_name = "expiry"
  }

  # Configure global tables
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  dynamic "replica" {
    for_each = var.replica_regions
    iterator = replica_region

    content {
      region_name = replica_region.value
    }
  }

  hash_key  = "deviceId"
  range_key = "epochS"

  attribute {
    name = "deviceId"
    type = "S"
  }

  attribute {
    name = "epochS"
    type = "N"
  }

  # Add secondary indexes
  attribute {
    name = "eventId"
    type = "S"
  }

  # Add a global secondary index
  attribute {
    name = "geoLocation"
    type = "S"
  }

  # Add secondary indexes
  local_secondary_index {
    name            = "by_eventId"
    range_key       = "eventId"
    projection_type = "ALL"
  }

  # Add a global secondary index
  global_secondary_index {
    name               = "by_geoLocation"
    hash_key           = "geoLocation"
    range_key          = "epochS"
    write_capacity     = 5
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["userId", "location"]
  }

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}

# Populate your table
locals {
  example_data = csvdecode(file("data/example_environments.csv"))
}

resource "aws_dynamodb_table_item" "example" {
  for_each = var.load_example_data ? { for row in local.example_data : row.eventId => row } : {}

  table_name = aws_dynamodb_table.environment.name
  hash_key   = aws_dynamodb_table.environment.hash_key
  range_key  = aws_dynamodb_table.environment.range_key

  item = <<EOF
{
    "userId": {"S": "${each.value.userId}"},
    "deviceId": {"S": "${each.value.deviceId}"},
    "eventId": {"S": "${each.value.eventId}"},
    "geoLocation": {"S": "${each.value.geoLocation}"},
    "epochS": {"N": "${each.value.epochS}"},
    "expiry": {"N": "${each.value.expiry}"},
    "tempC": {"N": "${each.value.tempC}"},
    "humidityPct": {"N": "${each.value.humidityPct}"},
    "pressurePa": {"N": "${each.value.pressurePa}"}
}
EOF

  lifecycle {
    ignore_changes = [item]
  }
}
