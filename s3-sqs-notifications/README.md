# [Testing S3 notifications locally with LocalStack & Terraform](https://hashnode.localstack.cloud/testing-s3-notifications-locally-with-localstack-terraform) - Sep 7, 2022

## Init

```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

## Trigger a notification

- invoke it using the AWS CLI

```sh
# check s3bucket and queues
awslocal s3api list-buckets
awslocal sqs list-queues

# copy over this file inside S3 bucket 
echo "test"> /tmp/app.txt
awslocal s3 cp /tmp/app.txt s3://$(terraform output -raw s3bucket_id)/

# uploaded a file, it must have triggered a notification on our SQS queue
awslocal sqs \
  receive-message \
    --queue-url $(terraform output -raw queue_url) \
 | jq -r '.Messages[0].Body' | jq .
```

## Cleanup

```sh
terraform destroy -auto-approve
```
