variable "domainName" {
  default = "my-domain"
}

# awslocal opensearch create-domain --domain-name my-domain
resource "aws_opensearch_domain" "mydomain" {
  domain_name    = var.domainName
  engine_version = "Elasticsearch_7.10"

  cluster_config {
    instance_type  = "t2.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = {
    Environment = "local"
  }
}

output "mydomain" {
  description = "value of the open search"
  value       = aws_opensearch_domain.mydomain
}
