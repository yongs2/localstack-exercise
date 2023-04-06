# [AWS Certificate Manager (ACM)](https://docs.localstack.cloud/user-guide/aws/acm/)

## 1. Request a certificate

```sh
```sh
# Request a certificate
awslocal acm request-certificate \
        --domain-name www.example.com \
        --validation-method DNS \
        --options CertificateTransparencyLoggingPreference=DISABLED
```

## 2. List certificates

```sh
# List all certificates
awslocal acm list-certificates --max-items 10
```

## 3. Get certificate details

```sh
CERT_ARN=$(awslocal acm list-certificates --query CertificateSummaryList[0].CertificateArn | sed 's/"//g')

# View the certificate details
awslocal acm get-certificate --certificate-arn ${CERT_ARN}
awslocal acm describe-certificate --certificate-arn ${CERT_ARN}
```

## 4. Delete certificate

```sh
# Delete the certificate
awslocal acm delete-certificate --certificate-arn ${CERT_ARN}
awslocal acm list-certificates
```
