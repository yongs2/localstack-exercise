# [Simple Storage Service (S3) Control](https://docs.localstack.cloud/references/coverage/coverage_s3control/)

See [Amazon S3 Control](https://docs.aws.amazon.com/AmazonS3/latest/API/API_Operations_AWS_S3_Control.html)

## 1. PutPublicAccessBlock

- [Refer test case](https://github.com/localstack/localstack/blob/master/tests/integration/test_s3control.py)

```sh
# Creates or modifies the PublicAccessBlock configuration for an Amazon Web Services account (https://docs.aws.amazon.com/cli/latest/reference/s3control/put-public-access-block.html)
awslocal s3control \
  put-public-access-block \
  --account-id 000000000000 \
  --public-access-block-configuration '{"BlockPublicAcls": true, "IgnorePublicAcls": true, "BlockPublicPolicy": true, "RestrictPublicBuckets": true}'

# FIXME: 다음과 같이 에러 출력
Could not connect to the endpoint URL: "http://000000000000.localhost:4566/v20180820/configuration/publicAccessBlock"
```

## 2. GetPublicAccessBlock

```sh
# Retrieves the PublicAccessBlock configuration for an Amazon Web Services account (https://docs.aws.amazon.com/cli/latest/reference/s3control/get-public-access-block.html)
awslocal s3control \
  get-public-access-block \
  --account-id 000000000000

# FIXME: 다음과 같이 에러 출력
Could not connect to the endpoint URL: "http://000000000000.localhost:4566/v20180820/configuration/publicAccessBlock"
```

## 3. DeletePublicAccessBlock

```sh
# Removes the PublicAccessBlock configuration for an Amazon Web Services account (https://docs.aws.amazon.com/cli/latest/reference/s3control/delete-public-access-block.html)
awslocal s3control \
  delete-public-access-block \
  --account-id 000000000000

# FIXME: 다음과 같이 에러 출력
Could not connect to the endpoint URL: "http://000000000000.localhost:4566/v20180820/configuration/publicAccessBlock"
```

## 4. CreateAccessPoint

```sh
# Creates an access point and associates it with the specified bucket (https://docs.aws.amazon.com/cli/latest/reference/s3control/create-access-point.html)
awslocal s3control \
  create-access-point \
  --account-id 000000000000 \
  --name my-access-point \
  --bucket my-bucket \
  --vpc-configuration '{"VpcId": "vpc-1234567890abcdef0"}'

# FIXME: 다음과 같이 에러 출력
Could not connect to the endpoint URL: "http://000000000000.localhost:4566/v20180820/accesspoint/my-access-point"
```

## 5. CreateMultiRegionAccessPoint

```sh
# Creates a Multi-Region Access Point and associates it with the specified buckets (https://docs.aws.amazon.com/cli/latest/reference/s3control/create-multi-region-access-point.html)
awslocal s3control \
  create-multi-region-access-point \
  --account-id 000000000000 \
  --details '{"Name": "my-multi-region-access-point", "PublicAccessBlock": { "BlockPublicAcls": true, "IgnorePublicAcls": true, "BlockPublicPolicy": true, "RestrictPublicBuckets": true }, "Regions": [ { "Bucket": "string", "BucketAccountId": "string" } ] }'

# FIXME: 다음과 같이 에러 출력
Could not connect to the endpoint URL: "http://000000000000.localhost:4566/v20180820/async-requests/mrap/create"

curl -v http://000000000000.localhost:4566/s3control/v20180820/configuration/publicAccessBlock
```
