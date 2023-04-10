# [Identity and Access Management (IAM)](https://docs.localstack.cloud/user-guide/aws/iam/)

See [AWS Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

## 1. Creating IAM Users and Access Keys

```sh
# By default, if no custom credentials are configured, requests made to LocalStack are running under the administrative root user:
awslocal sts get-caller-identity

# create a new user named test
awslocal iam create-user --user-name test

# create an access key pair for the user
RESULT_JSON=/tmp/access-key.json
awslocal iam create-access-key --user-name test > ${RESULT_JSON}
AWS_ACCESS_KEY_ID=$(cat ${RESULT_JSON} | jq -r .AccessKey.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(cat ${RESULT_JSON} | jq -r .AccessKey.SecretAccessKey)
awslocal sts get-caller-identity
```

## 2. Enforcing IAM Policies

```sh
awslocal iam create-policy --policy-name p1 --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":"s3:CreateBucket","Resource":"*"}]}'
awslocal iam attach-user-policy --user-name test --policy-arn arn:aws:iam::000000000000:policy/p1
```

## 3. list 

```sh
# list
awslocal iam list-users
awslocal iam list-access-keys --user-name test
awslocal iam list-policies --query 'Policies[?PolicyName==`p1`].Arn'
awslocal iam list-user-policies --user-name test
```

## 4. Get

```sh
# get
awslocal iam get-user
awslocal iam get-policy --policy-arn arn:aws:iam::000000000000:policy/p1
```

## 5. Delete

```sh
# delete
awslocal iam delete-access-key --access-key-id ${AWS_ACCESS_KEY_ID}
awslocal iam list-attached-user-policies --user-name test
awslocal iam detach-user-policy --user-name test --policy-arn arn:aws:iam::000000000000:policy/p1
awslocal iam delete-policy --policy-arn arn:aws:iam::000000000000:policy/p1
awslocal iam delete-user --user-name test

awslocal sts get-caller-identity
```
