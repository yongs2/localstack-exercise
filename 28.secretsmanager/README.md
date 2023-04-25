# [Secrets Manager](https://docs.localstack.cloud/references/coverage/coverage_secretsmanager/)

See [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)

## 1. Using AWS CLI

### 1.1 Create a secret

```sh
# Creates a new secret (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/create-secret.html)
awslocal secretsmanager \
  create-secret \
    --name MyTestSecret \
    --description "My test secret created with the CLI." \
    --secret-string "{\"user\":\"diegor\",\"password\":\"EXAMPLE-PASSWORD\"}"
```

### 1.2 Modify a secret

```sh
# Modifies the details of a secret, including metadata and the secret value (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/update-secret.html)
awslocal secretsmanager \
  update-secret \
    --secret-id MyTestSecret \
    --description "This is a new description for the secret."

# Creates a new version with a new encrypted secret value and attaches it to the secret (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/put-secret-value.html)
awslocal secretsmanager \
  put-secret-value \
    --secret-id MyTestSecret \
    --secret-string "{\"user\":\"diegor\",\"password\":\"EXAMPLE-PASSWORD\"}"
```

### 1.3 Get a secret

```sh
# Retrieves the details of a secret (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/get-secret-value.html)
awslocal secretsmanager \
  describe-secret \
    --secret-id MyTestSecret
```

### 1.4 Find secrets

```sh
# Lists the secrets that are stored by Secrets Manager in the Amazon Web Services account, not including secrets that are marked for deletion (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/list-secrets.html)
awslocal secretsmanager list-secrets

awslocal secretsmanager \
  list-secrets \
    --filter Key="name",Values="Test"
```

### 1.5 Tag secrets

```sh
# Attaches tags to a secret (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/tag-resource.html)
awslocal secretsmanager \
  tag-resource \
    --secret-id MyTestSecret \
    --tags '[{"Key": "FirstTag", "Value": "FirstValue"}, {"Key": "SecondTag", "Value": "SecondValue"}]'

# Removes specific tags from a secret (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/untag-resource.html)
awslocal secretsmanager \
  untag-resource \
    --secret-id MyTestSecret \
    --tag-keys '[ "FirstTag", "SecondTag"]'
```

### 1.6 Delete a secret

```sh
# Deletes a secret and all of its versions (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/delete-secret.html)
awslocal secretsmanager \
  delete-secret \
    --secret-id MyTestSecret \
    --recovery-window-in-days 7
```

### 1.7 Restore a secret

```sh
# Cancels the scheduled deletion of a secret by removing the DeletedDate time stamp (https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/restore-secret.html)
awslocal secretsmanager \
  restore-secret \
   --secret-id MyTestSecret
```

### 1.8 Clean up

```sh
# Delete a secret immediately
awslocal secretsmanager \
  delete-secret \
    --secret-id MyTestSecret \
    --force-delete-without-recovery
```

## 2. Using terraform

- [Resource: aws_secretsmanager_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)
- [Resource: aws_secretsmanager_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version)

### 2.1 Create a secret and tag

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Get a secret

```sh
awslocal secretsmanager \
  describe-secret \
    --secret-id MyTestSecret
```

### 2.3 Find secrets

```sh
awslocal secretsmanager list-secrets

awslocal secretsmanager \
  list-secrets \
    --filter Key="name",Values="Test"

awslocal secretsmanager \
  list-secrets \
    --filter Key="tag-key",Values="FirstTag"
```

### 2.4 Tag secrets

```sh
awslocal secretsmanager \
  untag-resource \
    --secret-id MyTestSecret \
    --tag-keys '[ "FirstTag", "SecondTag"]'
```

### 2.5 Delete the secret

```sh
terraform destroy -auto-approve
```
