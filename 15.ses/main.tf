variable "verify_email" {
  default = "user1@yourdomain.com"
}

# awslocal ses verify-email-identity --email-address user1@yourdomain.com
resource "aws_ses_email_identity" "example" {
  email = var.verify_email
}

# return email identity
output "example" {
  value = aws_ses_email_identity.example
}
