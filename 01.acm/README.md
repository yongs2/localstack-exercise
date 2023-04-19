# [AWS Certificate Manager (ACM)](https://docs.localstack.cloud/user-guide/aws/acm/)

See [AWS Certificate Manager](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)

## 1. Using AWS CLI

### 1.1 Request a certificate

```sh
# Request a certificate
awslocal acm request-certificate \
        --domain-name www.example.com \
        --validation-method DNS \
        --options CertificateTransparencyLoggingPreference=DISABLED
```

### 1.2 List certificates

```sh
# List all certificates
awslocal acm list-certificates --max-items 10
```

### 1.3 Get certificate details

```sh
CERT_ARN=$(awslocal acm list-certificates --query CertificateSummaryList[0].CertificateArn | sed 's/"//g')

# View the certificate details
awslocal acm get-certificate --certificate-arn ${CERT_ARN}
awslocal acm describe-certificate --certificate-arn ${CERT_ARN}
```

### 1.4 Delete certificate

```sh
# Delete the certificate
awslocal acm delete-certificate --certificate-arn ${CERT_ARN}
awslocal acm list-certificates
```

## 2. Using terraform

### 2.1 Request a certificate

- [Resource: aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List certificates

```sh
awslocal acm list-certificates --max-items 10
```

### 2.3 Get certificate details

```sh
CERT_ARN=$(terraform output -raw cert_arn)

awslocal acm get-certificate --certificate-arn ${CERT_ARN}
awslocal acm describe-certificate --certificate-arn ${CERT_ARN}
```

### 2.4 Delete certificate

```sh
terraform destroy -auto-approve
```
