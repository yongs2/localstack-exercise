# [config](https://docs.localstack.cloud/references/coverage/coverage_config/)

See [AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)

## 1. Using AWS CLI

### 1.1 Creates a new configuration recorder

```sh
# Creates a new configuration recorder to record your selected resource configurations (https://docs.aws.amazon.com/cli/latest/reference/configservice/put-configuration-recorder.html)
awslocal configservice put-configuration-recorder \
  --configuration-recorder name=default,roleARN=arn:aws:iam::123456789012:role/config-role \
  --recording-group allSupported=true,includeGlobalResourceTypes=true
```

### 1.2 List all configuration recorders

```sh
# Returns the details for the specified configuration recorders (https://docs.aws.amazon.com/cli/latest/reference/configservice/describe-configuration-recorders.html)
awslocal configservice describe-configuration-recorders

# Returns the current status of the specified configuration recorder (https://docs.aws.amazon.com/cli/latest/reference/configservice/describe-configuration-recorder-status.html)
awslocal configservice describe-configuration-recorder-status   --configuration-recorder-names default
```

### 1.3 Creates a delivery channel

```sh
cat <<EOF | tee /tmp/deliveryChannel.json
{
    "name": "default",
    "s3BucketName": "config-bucket-123456789012",
    "snsTopicARN": "arn:aws:sns:us-east-1:123456789012:config-topic",
    "configSnapshotDeliveryProperties": {
        "deliveryFrequency": "Twelve_Hours"
    }
}
EOF

# Creates a delivery channel object to deliver configuration information to an Amazon S3 bucket and Amazon SNS topic (https://docs.aws.amazon.com/cli/latest/reference/configservice/put-delivery-channel.html)
awslocal configservice put-delivery-channel --delivery-channel file:///tmp/deliveryChannel.json

# Returns details about the specified delivery channel (https://docs.aws.amazon.com/cli/latest/reference/configservice/describe-delivery-channels.html)
awslocal configservice describe-delivery-channels
```

### 1.4 Start recording configurations

```sh
# Starts recording configurations of the Amazon Web Services resources (https://docs.aws.amazon.com/cli/latest/reference/configservice/start-configuration-recorder.html)
awslocal configservice start-configuration-recorder --configuration-recorder-name default
```

### 1.5 Clean up

```sh
# Stops recording configurations of the Amazon Web Services resources (https://docs.aws.amazon.com/cli/latest/reference/configservice/stop-configuration-recorder.html)
awslocal configservice stop-configuration-recorder --configuration-recorder-name default

# Deletes the delivery channel (https://docs.aws.amazon.com/cli/latest/reference/configservice/delete-delivery-channel.html)
awslocal configservice delete-delivery-channel --delivery-channel-name default

# Deletes the configuration recorder (https://docs.aws.amazon.com/cli/latest/reference/configservice/delete-configuration-recorder.html)
awslocal configservice delete-configuration-recorder --configuration-recorder-name default
```

## 2. Using terraform

- [Resource: aws_config_configuration_recorder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder)
- [Resource: aws_config_delivery_channel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel)
- [Resource: aws_config_configuration_recorder_status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status)

### 2.1 Create a new configuration recorder and delivery channel, start confiugration recorder

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List all configuration recorders and delivery channels

```sh
awslocal configservice describe-configuration-recorders

awslocal configservice \
  describe-configuration-recorder-status \
  --configuration-recorder-names default

awslocal configservice describe-delivery-channels
```

### 2.3 Stop the configuration recorder, Delete the configuration recorder and delivery channel

```sh
terraform destroy -auto-approve
```
