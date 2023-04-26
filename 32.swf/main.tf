variable "domainName" {
  default = "default"
}

# awslocal swf \
#   register-domain \
#     --name default \
#     --workflow-execution-retention-period-in-days 1 \
#     --description "Default domain for localstack"
resource "aws_swf_domain" "example" {
  name                                        = var.domainName
  description                                 = "Default domain for localstack"
  workflow_execution_retention_period_in_days = 1
}

# return domain
output "domain" {
  value = aws_swf_domain.example
}
