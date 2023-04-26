# [STS (Security Token Service)](https://docs.localstack.cloud/references/coverage/coverage_sts/)

See [AWS Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html)

## 1. Using AWS CLI

### 1.1 AssumeRole

```sh
# Returns a set of temporary security credentials that you can use to access Amazon Web Services resources (https://docs.aws.amazon.com/cli/latest/reference/sts/assume-role.html)
awslocal sts \
  assume-role \
    --role-arn arn:aws:iam::123456789012:role/xaccounts3access \
    --role-session-name s3-access-example
```

### 1.2 AssumeRoleWithSAML

```sh
# [Refer test case](https://github.com/localstack/localstack/blob/master/tests/integration/test_sts.py)
TEST_SAML_ASSERTION=$(base64 saml_assertion.xml)

# Returns a set of temporary security credentials for users who have been authenticated via a SAML authentication response (https://docs.aws.amazon.com/cli/latest/reference/sts/assume-role-with-saml.html)
awslocal sts \
  assume-role-with-saml \
    --role-arn arn:aws:iam::123456789012:role/TestSaml \
    --principal-arn arn:aws:iam::123456789012:saml-provider/SAML-test \
    --saml-assertion "${TEST_SAML_ASSERTION}"
```

### 1.3 AssumeRoleWithWebIdentity

```sh
# Returns a set of temporary security credentials for users who have been authenticated in a mobile or web application with a web identity provider (https://docs.aws.amazon.com/cli/latest/reference/sts/assume-role-with-web-identity.html)
awslocal sts \
  assume-role-with-web-identity \
    --duration-seconds 3600 \
    --role-session-name "app1" \
    --provider-id "www.amazon.com" \
    --policy-arns '[{"arn":"arn:aws:iam::123456789012:policy/webidentitydemopolicy1"},{"arn":"arn:aws:iam::123456789012:policy/webidentitydemopolicy2"}]' \
    --role-arn arn:aws:iam::123456789012:role/FederatedWebIdentityRole \
    --web-identity-token "Atza%7CIQEBLjAsAhRFiXuWpUXuRvQ9PZL3GMFcYevydwIUFAHZwXZXXXXXXXXJnrulxKDHwy87oGKPznh0D6bEQZTSCzyoCtL_8S07pLpr0zMbn6w1lfVZKNTBdDansFBmtGnIsIapjI6xKR02Yc_2bQ8LZbUXSGm6Ry6_BG7PrtLZtj_dfCTj92xNGed-CrKqjG7nPBjNIL016GGvuS5gSvPRUxWES3VYfm1wl7WTI7jn-Pcb6M-buCgHhFOzTQxod27L9CqnOLio7N3gZAGpsp6n1-AJBOCJckcyXe2c6uD0srOJeZlKUm2eTDVMf8IehDVI0r1QOnTV6KzzAI3OY87Vd_cVMQ"
```

### 1.4 GetCallerIdentity

```sh
# Returns details about the IAM user or role whose credentials are used to call the operation (https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html)
awslocal sts \
  get-caller-identity
```

### 1.5 GetFederationToken

```sh
# Returns a set of temporary security credentials for a federated user (https://docs.aws.amazon.com/cli/latest/reference/sts/get-federation-token.html)
awslocal sts \
  get-federation-token \
    --name "Bob" \
    --policy '{"Version":"2012-10-17","Statement":[{"Sid":"Stmt1","Effect":"Allow","Action":"s3:*","Resource":"*"}]}' \
    --duration-seconds 3600
```

### 1.6 GetSessionToken

```sh
# Returns a set of temporary credentials for an Amazon Web Services account or IAM user (https://docs.aws.amazon.com/cli/latest/reference/sts/get-session-token.html)
awslocal sts \
  get-session-token \
    --duration-seconds 900 \
    --serial-number "YourMFADeviceSerialNumber" \
    --token-code 123456
```

## 2. Using terraform

- [Data Source: aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)

### 2.1 GetCallerIdentity

- get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform output
```

### 2.2 Delete terraform resources

```sh
terraform destroy -auto-approve
```
