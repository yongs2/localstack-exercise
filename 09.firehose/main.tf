variable "domainName" {
  default = "es-local"
}

variable "streamName" {
  default = "kinesis-es-local-stream"
}

variable "deliveryStreamName" {
  default = "activity-to-elasticsearch-local"
}

variable "s3bucketName" {
  default = "kinesis-activity-backup-local"
}

# awslocal iam create-role --role-name Firehose-Reader-Role --assume-role-policy-document file://trust-policy.json
data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "firehose_test_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

# awslocal es create-elasticsearch-domain --domain-name es-local
resource "aws_elasticsearch_domain" "esLocal" {
  domain_name           = var.domainName
  elasticsearch_version = "7.10"

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

  tags = {
    Environment = "local"
  }
}

# return es domain arn
output "esLocal" {
  description = "value of the esLocal"
  value       = aws_elasticsearch_domain.esLocal.arn
}

# awslocal s3 mb s3://kinesis-activity-backup-local
resource "aws_s3_bucket" "s3bucketLocal" {
  bucket        = var.s3bucketName
  force_destroy = true

  tags = {
    Environment = "local"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.s3bucketLocal.id
  acl    = "private"
}

# return s3 bucket arn
output "s3bucketLocalArn" {
  description = "value of the s3bucketLocal"
  value       = aws_s3_bucket.s3bucketLocal.arn
}

# awslocal kinesis create-stream --stream-name kinesis-es-local-stream --shard-count 2
resource "aws_kinesis_stream" "kinesisEsLocalStream" {
  name             = var.streamName
  shard_count      = 2
  retention_period = 24

  tags = {
    Environment = "local"
  }
}

# return kinensis stream arn
output "kinesisEsLocalStreamArn" {
  description = "value of the kinesisEsLocalStreamArn"
  value       = aws_kinesis_stream.kinesisEsLocalStream.arn
}

# awslocal firehose create-delivery-stream \
#   --delivery-stream-name activity-to-elasticsearch-local \
#   --delivery-stream-type KinesisStreamAsSource \
#   --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/kinesis-es-local-stream,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" \
#   --elasticsearch-destination-configuration "RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,DomainARN=arn:aws:es:us-east-1:000000000000:domain/es-local,IndexName=activity,TypeName=activity,S3BackupMode=AllDocuments,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::kinesis-activity-backup-local}"
resource "aws_kinesis_firehose_delivery_stream" "kfds" {
  name        = var.deliveryStreamName
  destination = "elasticsearch"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesisEsLocalStream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  elasticsearch_configuration {
    domain_arn = aws_elasticsearch_domain.esLocal.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "activity"
    type_name  = "activity"

    s3_backup_mode = "AllDocuments"
  }

  s3_configuration {
    bucket_arn = aws_s3_bucket.s3bucketLocal.arn
    role_arn   = aws_iam_role.firehose_role.arn
  }
}
