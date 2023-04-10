# [Simple Email Service (SES)](https://docs.localstack.cloud/user-guide/aws/ses/) : Pro

See [Amazon Simple Email Service](https://docs.aws.amazon.com/ses/latest/dg/Welcome.html)

## 1. Send Email

```sh
# Composes an email message and immediately queues it for sending (https://docs.aws.amazon.com/cli/latest/reference/ses/send-email.html)
awslocal ses send-email \
    --from user1@yourdomain.com \
    --message 'Body={Text={Data="Lorem ipsum dolor sit amet, consectetur adipiscing elit, ..."}},Subject={Data=Test Email}' \
    --destination 'ToAddresses=recipient1@example.com'

```

## 2. Verify email identity

```sh
# Adds an email address to the list of identities for your Amazon SES account in the current AWS region and attempts to verify it (https://docs.aws.amazon.com/cli/latest/reference/ses/verify-email-identity.html)
awslocal ses verify-email-identity --email-address user1@yourdomain.com
```
