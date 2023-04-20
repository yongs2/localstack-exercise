# [S3](https://docs.localstack.cloud/user-guide/aws/s3/)

See [Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

## 1. Using AWS CLI

### 1.1 Create a bucket

```sh
# Creates a new S3 bucket (https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html)
awslocal s3api create-bucket --bucket sample-bucket
```

### 1.2 list buckets

```sh
# Returns a list of all buckets owned by the authenticated sender of the request (https://docs.aws.amazon.com/cli/latest/reference/s3api/list-buckets.html)
awslocal s3api list-buckets
```

### 1.3 Adds an object to a bucket

```sh
cat <<EOF | tee index.html
<!DOCTYPE html>
<html>
<head>
	<title>My Website</title>
</head>
<body>
	<h1>Welcome to my website!</h1>
	<p>Here is some sample text.</p>
</body>
</html>
EOF

# Adds an object to a bucket (https://docs.aws.amazon.com/cli/latest/reference/s3api/put-object.html)
awslocal s3api put-object --bucket sample-bucket --key index.html --body index.html
```

### 1.4 Get an object from a bucket

```sh
# Retrieves objects from Amazon S3
awslocal s3api get-object --bucket sample-bucket --key index.html index.html
```

### 1.5 CORS configuration

```sh
cat <<EOF | tee cors-config.json 
{
  "CORSRules": [
    {
      "AllowedHeaders": ["*"],
      "AllowedMethods": ["GET", "POST", "PUT"],
      "AllowedOrigins": ["http://localhost:3000"],
      "ExposeHeaders": ["ETag"]
    }
  ]
}
EOF

# Sets the cors configuration for your bucket (https://docs.aws.amazon.com/cli/latest/reference/s3api/put-bucket-cors.html)
awslocal s3api put-bucket-cors --bucket sample-bucket --cors-configuration file://cors-config.json

# Returns the Cross-Origin Resource Sharing (CORS) configuration information set for the bucket (https://docs.aws.amazon.com/cli/latest/reference/s3api/get-bucket-cors.html)
awslocal s3api get-bucket-cors --bucket sample-bucket
```

### 1.6 Delete a bucket

```sh
awslocal s3api delete-object --bucket sample-bucket --key index.html

# Deletes the S3 bucket (https://docs.aws.amazon.com/cli/latest/reference/s3api/delete-bucket.html)
awslocal s3api delete-bucket --bucket sample-bucket
```

## 2. Using terraform

- [Resource: aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

### 2.1 Create a cluster

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 list buckets

```sh
awslocal s3api list-buckets
```

### 2.3 Adds an object to a bucket

```sh
BUCKET_ID=$(terraform output -json | jq -r .sample_bucket.id)
awslocal s3api put-object --bucket ${BUCKET_ID} --key index.html --body index.html
```

### 2.4 Get an object from a bucket

```sh
awslocal s3api get-object --bucket ${BUCKET_ID} --key index.html index.html
```

### 2.5 CORS configuration

```sh
awslocal s3api put-bucket-cors --bucket ${BUCKET_ID} --cors-configuration file://cors-config.json
awslocal s3api get-bucket-cors --bucket ${BUCKET_ID}
```

### 2.6 Delete a cluster

```sh
terraform destroy -auto-approve
```
