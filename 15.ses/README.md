# [Simple Email Service (SES)](https://docs.localstack.cloud/user-guide/aws/ses/) : Pro

See [Amazon Simple Email Service](https://docs.aws.amazon.com/ses/latest/dg/Welcome.html)

## 1. Using AWS CLI

### 1.1 Send Email

```sh
# Composes an email message and immediately queues it for sending (https://docs.aws.amazon.com/cli/latest/reference/ses/send-email.html)
awslocal ses send-email \
    --from user1@yourdomain.com \
    --message 'Body={Text={Data="Lorem ipsum dolor sit amet, consectetur adipiscing elit, ..."}},Subject={Data=Test Email}' \
    --destination 'ToAddresses=recipient1@example.com'

```

### 1.2 Verify email identity

```sh
# Adds an email address to the list of identities for your Amazon SES account in the current AWS region and attempts to verify it (https://docs.aws.amazon.com/cli/latest/reference/ses/verify-email-identity.html)
awslocal ses verify-email-identity --email-address user1@yourdomain.com
```

### 1.3 List email identities

```sh
# Returns a list containing all of the identities (email addresses and domains) (https://docs.aws.amazon.com/cli/latest/reference/ses/list-identities.html)
awslocal ses list-identities
```

### 1.4 Delete email identity

```sh
# Deletes the specified identity (an email address or a domain) from the list of verified identities (https://docs.aws.amazon.com/cli/latest/reference/ses/delete-identity.html)
awslocal ses delete-identity --identity user1@yourdomain.com
```

## 2. Using terraform

- [Resource: aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

### 2.1 Verify email identity

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List all identities

```sh
awslocal ses list-identities
```

### 2.3 Delete email identity

```sh
terraform destroy -auto-approve
```
