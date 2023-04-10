# [OpenSearch Service](https://docs.localstack.cloud/user-guide/aws/opensearch/)

See [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)

## 1. [Creating an OpenSearch cluster](https://docs.aws.amazon.com/cli/latest/reference/opensearch/create-domain.html)

```sh
awslocal opensearch create-domain --domain-name my-domain
```

## 2. Get Domain Status

- Describes the domain configuration for the specified Amazon OpenSearch Service domain, including the domain ID, domain service endpoint, and domain ARN. (https://docs.aws.amazon.com/cli/latest/reference/opensearch/describe-domain.html)

```sh
# If the Processing status is true, it means that the cluster is not yet healthy
awslocal opensearch describe-domain --domain-name my-domain | jq ".DomainStatus.Processing"
```

## 3. Interact with the cluster

```sh
# Interact with the cluster
curl http://my-domain.us-east-1.opensearch.localhost.localstack.cloud:4566

# Check the cluster health endpoint
curl -s http://my-domain.us-east-1.opensearch.localhost.localstack.cloud:4566/_cluster/health | jq .
```

## 4. list

```sh
# Returns the names of all Amazon OpenSearch Service domains owned by the current user in the active Region. (https://docs.aws.amazon.com/cli/latest/reference/opensearch/list-domain-names.html)
awslocal opensearch list-domain-names 
```

## 5. storage layout

```sh
tree -L 4  /var/lib/localstack/tmp/state
```

## 6. Delete the domain

```sh
# Deletes an Amazon OpenSearch Service domain and all of its data (https://docs.aws.amazon.com/cli/latest/reference/opensearch/delete-domain.html)
awslocal opensearch delete-domain --domain-name my-domain
```
