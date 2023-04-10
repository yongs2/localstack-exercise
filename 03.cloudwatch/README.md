# [CloudWatch](https://docs.localstack.cloud/user-guide/aws/cloudwatch/)

See [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)

## 1. Create Metric alarm:

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

## 2. watch the status of the alarm:

```sh
watch "awslocal cloudwatch describe-alarms --alarm-names my-alarm | jq '.MetricAlarms[0].StateValue'"
```

## 3. set the metric-alarm to state ALARM:

```sh
awslocal cloudwatch put-metric-data --namespace test --metric-data '[{"MetricName": "Orders", "Value": -1}]'
```

## 4. Delete certificate

```sh
awslocal cloudwatch delete-alarms --alarm-names my-alarm
```
