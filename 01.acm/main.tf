# Create Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "www.example.com"
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  options {
    certificate_transparency_logging_preference = "DISABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Output the certificate ARN
output "cert_arn" {
  description = "certificate_arn"
  value       = aws_acm_certificate.cert.arn
}
