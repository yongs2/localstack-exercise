# awslocal es create-elasticsearch-domain --domain-name my-domain
variable "domain" {
  default = "my-domain"
}

resource "aws_elasticsearch_domain" "mydomain" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
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
  description = "value of the es"
  value       = aws_elasticsearch_domain.mydomain
}
