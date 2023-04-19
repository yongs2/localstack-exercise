variable "plaintext" {
  default = "some important stuff"
}
# awslocal kms create-key
resource "aws_kms_key" "test" {
  description             = "test kms key"
  deletion_window_in_days = 10
}

# awslocal kms encrypt \
#       --key-id ${KEY_ID} \
#       --plaintext "some important stuff" \
#       --output text \
#       --query CiphertextBlob \
#   | base64 -d > /tmp/my_encrypted_data
resource "aws_kms_ciphertext" "encrypted_data" {
  key_id    = aws_kms_key.test.key_id
  plaintext = var.plaintext
}

output "key_id" {
  value = aws_kms_key.test.key_id
}

output "encrypted_data" {
  value = aws_kms_ciphertext.encrypted_data.ciphertext_blob
}

# awslocal kms decrypt \
#       --ciphertext-blob fileb:///tmp/my_encrypted_data \
#       --output text \
#       --query Plaintext \
#   | base64 -d
data "aws_kms_secrets" "decrypted_data" {
  secret {
    name    = "my_encrypted_data"
    payload = aws_kms_ciphertext.encrypted_data.ciphertext_blob
    key_id  = aws_kms_key.test.key_id
  }
}

output "decrypted_data" {
  value = nonsensitive(data.aws_kms_secrets.decrypted_data.plaintext["my_encrypted_data"])
}
