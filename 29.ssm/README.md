# [Systems Manager (SSM)](https://docs.localstack.cloud/user-guide/aws/systems-manager/) : Pro

See [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)

## [ssm](https://docs.aws.amazon.com/cli/latest/reference/ssm/index.html) 의 create 명령을 기준으로 뷴류

| command                   | status | note |
|---------------------------|--------|------|
| create-activation         | 501    |      |
| create-association        | 501    |      |
| create-association-batch  | 501    |      |
| create-document           | ./document |  |
| create-maintenance-window | ./maintenance-window | |
| create-ops-item           | 501    |      |
| create-ops-metadata       | 501    |      |
| create-patch-baseline     | 501    |      |
| create-resource-data-sync | 501    |      |
| send-command              | ./command |   |

### Details

```sh
# activation (501)
awslocal ssm create-activation \
    --default-instance-name "HybridWebServers" \
    --iam-role "HybridWebServersRole" \
    --registration-limit 5

# association (501)
awslocal ssm create-association \
    --instance-id "i-0cb2b964d3e14fd9f" \
    --name "AWS-UpdateSSMAgent"

# ops-item (501)
awslocal ssm create-ops-item \
    --title "EC2 instance disk full" \
    --description "Log clean up may have failed which caused the disk to be full" \
    --priority 2 \
    --source ec2 \
    --operational-data '{"/aws/resources":{"Value":"[{\"arn\": \"arn:aws:dynamodb:us-west-2:12345678:table/OpsItems\"}]","Type":"SearchableString"}}' \
    --notifications Arn="arn:aws:sns:us-west-2:12345678:TestUser"

# ops-metadata (501)
awslocal ssm create-ops-metadata --resource-id 123

# patch-baseline (501)
awslocal ssm \
  create-patch-baseline \
    --name "Windows-Production-Baseline-AutoApproval" \
    --operating-system "WINDOWS" \
    --approval-rules "PatchRules=[{PatchFilterGroup={PatchFilters=[{Key=MSRC_SEVERITY,Values=[Critical,Important,Moderate]},{Key=CLASSIFICATION,Values=[SecurityUpdates,Updates,UpdateRollups,CriticalUpdates]}]},ApproveAfterDays=7}]" \
    --description "Baseline containing all updates approved for Windows Server production systems"

# resource-data-sync (501)
awslocal ssm \
  create-resource-data-sync \
    --sync-name "ssm-resource-data-sync" \
    --s3-destination "BucketName=ssm-bucket,Prefix=inventory,SyncFormat=JsonSerDe,Region=us-east-1"

awslocal ssm describe-parameters
```
