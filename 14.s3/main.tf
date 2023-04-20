variable "bucketName" {
  default = "sample-bucket"
}

# awslocal s3api create-bucket --bucket sample-bucket
resource "aws_s3_bucket" "sample_bucket" {
  bucket = var.bucketName

  tags = {
    Environment = "test"
  }
}

# return s3 bucket info
output "sample_bucket" {
  value = aws_s3_bucket.sample_bucket.id
}
