# [CloudWatch](https://docs.localstack.cloud/user-guide/aws/cloudwatch/)

See [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)

## 1. Using AWS CLI

### 1.1 Create Metric alarm

```sh
awslocal cloudwatch put-metric-alarm \
    --alarm-name my-alarm \
    --metric-name Orders \
    --namespace test \
    --threshold 1 \
    --comparison-operator LessThanThreshold \
    --evaluation-periods 1 \
    --period 30 \
    --statistic Minimum \
    --treat-missing notBreaching
```

### 1.2 watch the status of the alarm

```sh
watch awslocal cloudwatch \
  describe-alarms \
  --alarm-names my-alarm \
  --query 'MetricAlarms[0].StateValue' \
  --output text
```

### 1.3 set the metric-alarm to state ALARM

```sh
awslocal cloudwatch put-metric-data --namespace test --metric-data '[{"MetricName": "Orders", "Value": -1}]'
```

### 1.4 Delete the metric-alarm

```sh
awslocal cloudwatch delete-alarms --alarm-names my-alarm
```

## 2. Using terraform

- [Resource: aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)

### 2.1 Create Metric alarm

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 watch the status of the alarm

```sh
watch awslocal cloudwatch \
  describe-alarms \
  --alarm-names my-alarm \
  --query 'MetricAlarms[0].StateValue' \
  --output text
```

### 2.3 set the metric-alarm to state ALARM

```sh
awslocal cloudwatch put-metric-data --namespace test --metric-data '[{"MetricName": "Orders", "Value": -1}]'
```

### 2.4 Delete the metric-alarm

```sh
terraform destroy -auto-approve
```
