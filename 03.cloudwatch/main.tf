# awslocal cloudwatch put-metric-alarm \
#     --alarm-name my-alarm \
#     --metric-name Orders \
#     --namespace test \
#     --threshold 1 \
#     --comparison-operator LessThanThreshold \
#     --evaluation-periods 1 \
#     --period 30 \
#     --statistic Minimum \
#     --treat-missing notBreaching
resource "aws_cloudwatch_metric_alarm" "my-alarm" {
  alarm_name          = "my-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Orders"
  namespace           = "test"
  period              = 30
  statistic           = "Minimum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}
