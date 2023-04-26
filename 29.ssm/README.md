# [Systems Manager (SSM)](https://docs.localstack.cloud/user-guide/aws/systems-manager/) : Pro

See [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)

## [ssm](https://docs.aws.amazon.com/cli/latest/reference/ssm/index.html), Categorized by create command

| command                   | status | note |
|---------------------------|--------|------|
| create-activation         | 501    |      |
| create-association        | 501    |      |
| create-association-batch  | 501    |      |
| create-document           | ./document |  |
| create-maintenance-window | ./maintenance-window | 400 in add-tags-to-resource |
| create-ops-item           | 501    |      |
| create-ops-metadata       | 501    |      |
| create-patch-baseline     | 501    |      |
| create-resource-data-sync | 501    |      |
| send-command              | ./command |   |
| put-compliance-items      | 501    |      |
| put-inventory             | 501    |      |
| put-parameter             | ./parameter | |
| put-resource-policy       | 501    |      |


## 1. Using AWS CLI

### 1.1 Not supported in localstack

#### 1.1.1 activation (501) 

```sh
awslocal ssm create-activation \
    --default-instance-name "HybridWebServers" \
    --iam-role "HybridWebServersRole" \
    --registration-limit 5
```

#### 1.1.2 association (501)

```sh
awslocal ssm create-association \
    --instance-id "i-0cb2b964d3e14fd9f" \
    --name "AWS-UpdateSSMAgent"
```

#### 1.1.3 ops-item (501)

```sh
awslocal ssm create-ops-item \
    --title "EC2 instance disk full" \
    --description "Log clean up may have failed which caused the disk to be full" \
    --priority 2 \
    --source ec2 \
    --operational-data '{"/aws/resources":{"Value":"[{\"arn\": \"arn:aws:dynamodb:us-west-2:12345678:table/OpsItems\"}]","Type":"SearchableString"}}' \
    --notifications Arn="arn:aws:sns:us-west-2:12345678:TestUser"
```

#### 1.1.4 ops-metadata (501)

```sh
awslocal ssm create-ops-metadata --resource-id 123
```

#### 1.1.5 patch-baseline (501)

```sh
awslocal ssm \
  create-patch-baseline \
    --name "Windows-Production-Baseline-AutoApproval" \
    --operating-system "WINDOWS" \
    --approval-rules "PatchRules=[{PatchFilterGroup={PatchFilters=[{Key=MSRC_SEVERITY,Values=[Critical,Important,Moderate]},{Key=CLASSIFICATION,Values=[SecurityUpdates,Updates,UpdateRollups,CriticalUpdates]}]},ApproveAfterDays=7}]" \
    --description "Baseline containing all updates approved for Windows Server production systems"
```

#### 1.1.6 resource-data-sync (501)

```sh
awslocal ssm \
  create-resource-data-sync \
    --sync-name "ssm-resource-data-sync" \
    --s3-destination "BucketName=ssm-bucket,Prefix=inventory,SyncFormat=JsonSerDe,Region=us-east-1"
```

#### 1.1.7 compliance-items (501)

```sh
awslocal ssm \
  put-compliance-items \
  --resource-id "i-1234567890abcdef0" \
  --resource-type "ManagedInstance" \
  --compliance-type "Custom:AVCheck" \
  --execution-summary "ExecutionTime=2019-02-18T16:00:00Z" \
  --items "Id=Version2.0,Title=ScanHost,Severity=CRITICAL,Status=COMPLIANT"
```

#### 1.1.8 inventory (501)

```sh
awslocal ssm \
  put-inventory \
  --instance-id "i-016648b75dd622dab" \
  --items '[{"TypeName": "Custom:RackInfo","SchemaVersion": "1.0","CaptureTime": "2019-01-22T10:01:01Z","Content":[{"RackLocation": "Bay B/Row C/Rack D/Shelf E"}]}]'
```

#### 1.1.9 resource-policy (501)

```sh
awslocal ssm \
  put-resource-policy \
  --resource-arn "arn:aws:dynamodb:us-west-2:12345678:table/OpsItems" \
  --policy "allow"
```

## 2. Using terraform

- [Resource: aws_ssm_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document)
- [Resource: aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)

### 2.1 Create a document and parameter

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 list the document and parameter

```sh
awslocal ssm list-documents
awslocal ssm describe-parameters
```

### 2.3 Delete the document and parameter

```sh
terraform destroy -auto-approve
```
