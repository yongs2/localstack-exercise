variable "domainName" {
  default = "example.com"
}

# awslocal route53 \
#   create-hosted-zone \
#     --name ${ZONE_NAME} \
#     --caller-reference r1
resource "aws_route53_zone" "example" {
  name          = "example.com"
  force_destroy = true
}

# return domain
output "domain" {
  value = aws_route53_zone.example
}
