# [Elasticsearch Service](https://docs.localstack.cloud/user-guide/aws/elasticsearch/)

See [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)

## 1. Using AWS CLI

### 1.1 [Creates a new Elasticsearch domain]((https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html))

```sh
awslocal es create-elasticsearch-domain --domain-name my-domain
```

### 1.2 Get Domain Status

- Returns domain configuration information about the specified Elasticsearch domain, including the domain ID, domain endpoint, and domain ARN. (https://docs.aws.amazon.com/cli/latest/reference/es/describe-elasticsearch-domain.html)

```sh
# If the Processing status is true, it means that the cluster is not yet healthy
awslocal es describe-elasticsearch-domain --domain-name my-domain --query DomainStatus.Processing
```

### 1.3 Interact with the cluster

```sh
ENDPOINT=$(awslocal es describe-elasticsearch-domain --domain-name my-domain --query DomainStatus.Endpoint --output text)

# Interact with the cluster
curl http://${ENDPOINT}

# Check the cluster health endpoint
curl -s http://${ENDPOINT}/_cluster/health | jq .
```

### 1.4 list

```sh
# Returns the name of all Elasticsearch domains owned by the current user's account. (https://docs.aws.amazon.com/cli/latest/reference/es/list-domain-names.html)
awslocal es list-domain-names 
```

### 1.5 storage layout

```sh
tree -L 4 /var/lib/localstack/tmp/state
```

### 1.6 Delete the domain

```sh
# delete-elasticsearch-domain (https://docs.aws.amazon.com/cli/latest/reference/es/delete-elasticsearch-domain.html)
awslocal es delete-elasticsearch-domain --domain-name my-domain
```

## 2. Using terraform

- [Resource: aws_elasticsearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain)

### 2.1 Creates a new Elasticsearch domain

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Get Domain Status

```sh
awslocal es describe-elasticsearch-domain --domain-name my-domain --query DomainStatus.Processing
```

### 2.3 Interact with the cluster

```sh
ENDPOINT=$(terraform output -json | jq -r '.mydomain.value.endpoint')

curl http://${ENDPOINT}
curl -s http://${ENDPOINT}/_cluster/health | jq .
```

### 2.4 list

```sh
awslocal es list-domain-names 
```

### 2.5 storage layout

```sh
tree -L 4 /var/lib/localstack/tmp/state
```

### 2.6 Delete the domain

```sh
terraform destroy -auto-approve
```
