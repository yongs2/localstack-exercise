# [Redshift](https://docs.localstack.cloud/user-guide/aws/redshift/) : Pro

See [Amazon Redshift](https://docs.aws.amazon.com/redshift/latest/gsg/new-user-serverless.html)

## 1. Using AWS CLI

### 1.1 Create a cluster

```sh
# Creates a new cluster with the specified parameters (https://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html)
awslocal redshift \
    create-cluster \
    --cluster-identifier mysamplecluster \
    --master-username masteruser \
    --master-user-password secret1 \
    --node-type ds2.xlarge \
    --cluster-type single-node
```

### 1.2 Check the Redshift cluster

```sh
# Returns properties of provisioned clusters including general cluster properties, cluster database properties, maintenance and backup properties, and security and access properties (https://docs.aws.amazon.com/cli/latest/reference/redshift/describe-clusters.html)
awslocal redshift \
    describe-clusters \
    --cluster-identifier mysamplecluster

# Returns information about Amazon Redshift security groups (https://docs.aws.amazon.com/cli/latest/reference/redshift/describe-cluster-security-groups.html)
awslocal redshift describe-cluster-security-groups

# Get all the general cluster properties
awslocal redshift describe-clusters
```

### 1.3 Associate a cluster with a cluster security group

```sh
# Modifies the settings for a cluster (https://docs.aws.amazon.com/cli/latest/reference/redshift/modify-cluster.html)
awslocal redshift \
    modify-cluster \
    --cluster-identifier mysamplecluster \
    --cluster-security-groups mysamplesecuritygroup
```

### 1.4 Delete a cluster without specifying a final snapshot

```sh
# Deletes a previously provisioned cluster without its final snapshot being created (https://docs.aws.amazon.com/cli/latest/reference/redshift/delete-cluster.html)
awslocal redshift \
    delete-cluster \
    --cluster-identifier mysamplecluster \
    --skip-final-cluster-snapshot
```

## 2. Using terraform

- [Resource: aws_redshift_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster)

### 2.1 Create a cluster

- FIXME: Error: reading Redshift Cluster (mysamplecluster) logging status: InternalFailure: The describe_logging_status action has not been implemented

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Check the Redshift cluster

```sh
awslocal redshift describe-clusters --cluster-identifier mysamplecluster
awslocal redshift describe-cluster-security-groups
awslocal redshift describe-clusters
```

### 2.3 Associate a cluster with a cluster security group

```sh
awslocal redshift modify-cluster --cluster-identifier mysamplecluster --cluster-security-groups mysamplesecuritygroup
```

### 2.4 Delete a cluster

- FIXME: Error: reading Redshift Cluster (mysamplecluster) logging status: InternalFailure: The describe_logging_status action has not been implemented

```sh
terraform destroy -auto-approve
```
