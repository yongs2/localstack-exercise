# [OpenSearch Service](https://docs.localstack.cloud/user-guide/aws/opensearch/)

See [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)

## 1. Using AWS CLI

### 1.1 [Creating an OpenSearch cluster](https://docs.aws.amazon.com/cli/latest/reference/opensearch/create-domain.html)

```sh
awslocal opensearch create-domain --domain-name my-domain
```

### 1.2 Get Domain Status

- Describes the domain configuration for the specified Amazon OpenSearch Service domain, including the domain ID, domain service endpoint, and domain ARN. (https://docs.aws.amazon.com/cli/latest/reference/opensearch/describe-domain.html)

```sh
# If the Processing status is true, it means that the cluster is not yet healthy
awslocal opensearch describe-domain --domain-name my-domain --query DomainStatus.Processing
```

### 1.3 Interact with the cluster

```sh
ENDPOINT=$(awslocal opensearch describe-domain --domain-name my-domain --query DomainStatus.Endpoint --output text)

# Interact with the cluster
curl http://${ENDPOINT}

# Check the cluster health endpoint
curl -s http://${ENDPOINT}/_cluster/health | jq .
```

### 1.4 list

```sh
# Returns the names of all Amazon OpenSearch Service domains owned by the current user in the active Region. (https://docs.aws.amazon.com/cli/latest/reference/opensearch/list-domain-names.html)
awslocal opensearch list-domain-names 
```

### 1.5 storage layout

```sh
tree -L 4  /var/lib/localstack/tmp/state
```

### 1.6 Delete the domain

```sh
# Deletes an Amazon OpenSearch Service domain and all of its data (https://docs.aws.amazon.com/cli/latest/reference/opensearch/delete-domain.html)
awslocal opensearch delete-domain --domain-name my-domain
```

## 2. Using terraform

- [Resource: aws_opensearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain)

### 2.1 Creating an OpenSearch cluster

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Get Domain Status

```sh
awslocal opensearch describe-domain --domain-name my-domain --query DomainStatus.Processing
```

### 2.3 Interact with the cluster

```sh
ENDPOINT=$(terraform output -json | jq -r '.mydomain.value.endpoint')

curl http://${ENDPOINT}
curl -s http://${ENDPOINT}/_cluster/health | jq .
```

### 2.4 list

```sh
awslocal opensearch list-domain-names 
```

### 2.5 storage layout

```sh
tree -L 4  /var/lib/localstack/tmp/state
```

### 2.6 Delete the domain

```sh
terraform destroy -auto-approve
```
