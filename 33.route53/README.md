# [Route 53](https://docs.localstack.cloud/references/coverage/coverage_route53/)

See [Amazon Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)

## 1. Using AWS CLI

### 1.1 CreateHostedZone

```sh
# Creates a new public or private hosted zone (https://docs.aws.amazon.com/cli/latest/reference/route53/create-hosted-zone.html)
ZONE_NAME=example.com
awslocal route53 \
  create-hosted-zone \
    --name ${ZONE_NAME} \
    --caller-reference r1
```

### 1.2 ListHostedZones

```sh
# Retrieves a list of the public and private hosted zones that are associated with the current Amazon Web Services account (https://docs.aws.amazon.com/cli/latest/reference/route53/list-hosted-zones.html)
awslocal route53 list-hosted-zones

ZONE_ID=$(awslocal route53 \
  list-hosted-zones \
    --query 'HostedZones[?Name==`'${ZONE_NAME}'.`].Id' \
    --output text)
```

### 1.3 GetHostedZone

```sh
# Gets information about a specified hosted zone including the four name servers assigned to the hosted zone (https://docs.aws.amazon.com/cli/latest/reference/route53/get-hosted-zone.html)
awslocal route53 \
  get-hosted-zone \
    --id ${ZONE_ID}
```

### 1.4 DeleteHostedZone

```sh
# Deletes a hosted zone (https://docs.aws.amazon.com/cli/latest/reference/route53/delete-hosted-zone.html)
awslocal route53 \
  delete-hosted-zone \
    --id ${ZONE_ID}
```

## 2. Using terraform

- [Resource: aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)

### 2.1 Create a Route53 Hosted Zone

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform output
```

### 2.2 Delete a Route53 Hosted Zone

```sh
terraform destroy -auto-approve
```
