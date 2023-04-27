# [Key Management Service (KMS)](https://docs.localstack.cloud/user-guide/aws/kms/)

See [AWS Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)

## 1. Using AWS CLI

### 1.1 Creating key

```sh
# Creating key (https://docs.aws.amazon.com/cli/latest/reference/kms/create-key.html)
awslocal kms create-key
```

### 1.2 list IDs and Amazon Resource Identifiers (ARNs) of all the available keys

```sh
# list keys (https://docs.aws.amazon.com/cli/latest/reference/kms/list-keys.html)
awslocal kms list-keys
KEY_ID=$(awslocal kms list-keys --query "Keys[0].KeyId" --output text)
```

### 1.3 Use the key now to encrypt something

```sh
# encrypt (https://docs.aws.amazon.com/cli/latest/reference/kms/encrypt.html)
awslocal kms encrypt \
      --key-id ${KEY_ID} \
      --plaintext "some important stuff" \
      --output text \
      --query CiphertextBlob \
  | base64 -d > /tmp/my_encrypted_data
```

### 1.4 Decrypt our file using the same KMS key

```sh
# decrypt (https://docs.aws.amazon.com/cli/latest/reference/kms/decrypt.html)
awslocal kms decrypt \
      --ciphertext-blob fileb:///tmp/my_encrypted_data \
      --output text \
      --query Plaintext \
  | base64 -d
```

### 1.5 Disable key

```sh
# disalbe key (https://docs.aws.amazon.com/cli/latest/reference/kms/disable-key.html)
awslocal kms disable-key --key-id ${KEY_ID}
```

## 2. Using terraform

- [Resource: aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)

### 2.1 Create a new key, encrypted and decrypted the value of plaintext

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 list IDs and Amazon Resource Identifiers (ARNs) of all the available keys

```sh
awslocal kms list-keys
```

### 2.3 Delete key

```sh
terraform destroy -auto-approve
```