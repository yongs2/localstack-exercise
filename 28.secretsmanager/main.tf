variable "secretName" {
  default = "MyTestSecret"
}

# awslocal secretsmanager \
#   create-secret \
#     --name MyTestSecret \
#     --description "My test secret created with the CLI." \
#     --secret-string "{\"user\":\"diegor\",\"password\":\"EXAMPLE-PASSWORD\"}"
# awslocal secretsmanager \
#   tag-resource \
#     --secret-id MyTestSecret \
#     --tags '[{"Key": "FirstTag", "Value": "FirstValue"}, {"Key": "SecondTag", "Value": "SecondValue"}]'
resource "aws_secretsmanager_secret" "example" {
  name        = var.secretName
  description = "My test secret created with Terraform."

  tags = {
    FirstTag  = "FirstValue"
    SecondTag = "SecondValue"
  }
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    user : "diegor",
    password : "EXAMPLE-PASSWORD"
  })
}

# return secret id
output "secret" {
  value = aws_secretsmanager_secret.example
}
