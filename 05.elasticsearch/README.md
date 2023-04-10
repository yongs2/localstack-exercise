# [Elasticsearch Service](https://docs.localstack.cloud/user-guide/aws/elasticsearch/)

See [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)

## 1. [Creates a new Elasticsearch domain]((https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html))

```sh
awslocal es create-elasticsearch-domain --domain-name my-domain
```

## 2. Get Domain Status

- Returns domain configuration information about the specified Elasticsearch domain, including the domain ID, domain endpoint, and domain ARN. (https://docs.aws.amazon.com/cli/latest/reference/es/describe-elasticsearch-domain.html)

```sh
# If the Processing status is true, it means that the cluster is not yet healthy
awslocal es describe-elasticsearch-domain --domain-name my-domain | jq ".DomainStatus.Processing"
```

## 3. Interact with the cluster

```sh
# Interact with the cluster
curl http://my-domain.us-east-1.es.localhost.localstack.cloud:4566

# Check the cluster health endpoint
curl -s http://my-domain.us-east-1.es.localhost.localstack.cloud:4566/_cluster/health | jq .
```

## 4. list

```sh
# Returns the name of all Elasticsearch domains owned by the current user's account. (https://docs.aws.amazon.com/cli/latest/reference/es/list-domain-names.html)
awslocal es list-domain-names 
```

## 5. storage layout

```sh
tree -L 4  /var/lib/localstack/tmp/state
```

## 6. Delete the domain

```sh
# delete-elasticsearch-domain (https://docs.aws.amazon.com/cli/latest/reference/es/delete-elasticsearch-domain.html)
awslocal es delete-elasticsearch-domain --domain-name my-domain
```
