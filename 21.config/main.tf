variable "crName" {
  default = "default"
}

variable "channelName" {
  default = "default"
}

variable "s3_bucket_name" {
  default = "config-bucket-123456789012"
}

variable "sns_topic_arn" {
  default = "arn:aws:sns:us-east-1:123456789012:config-topic"
}

# awslocal configservice put-configuration-recorder \
#   --configuration-recorder name=default,roleARN=arn:aws:iam::123456789012:role/config-role \
#   --recording-group allSupported=true,includeGlobalResourceTypes=true
resource "aws_config_configuration_recorder" "example" {
  name     = var.crName
  role_arn = "arn:aws:iam::123456789012:role/config-role"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

# return a configuration recorder
output "configRecorder" {
  value = aws_config_configuration_recorder.example
}

# awslocal configservice put-delivery-channel --delivery-channel file:///tmp/deliveryChannel.json
resource "aws_config_delivery_channel" "example" {
  depends_on = [aws_config_configuration_recorder.example]

  name           = var.channelName
  s3_bucket_name = var.s3_bucket_name
  sns_topic_arn  = var.sns_topic_arn
  snapshot_delivery_properties {
    delivery_frequency = "Twelve_Hours"
  }
}

# return a delivery channel
output "deliveryChannel" {
  value = aws_config_delivery_channel.example
}

# awslocal configservice start-configuration-recorder --configuration-recorder-name default
resource "aws_config_configuration_recorder_status" "example" {
  depends_on = [aws_config_delivery_channel.example]

  name       = aws_config_configuration_recorder.example.name
  is_enabled = true
}

# return a configuration recorder status
output "configRecorderStatus" {
  value = aws_config_configuration_recorder_status.example
}
