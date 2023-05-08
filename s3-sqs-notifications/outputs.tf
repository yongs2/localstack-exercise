# queue url
output "queue_url" {
  value = aws_sqs_queue.queue.url
}

# s3 id
output "s3bucket_id" {
  value = aws_s3_bucket.bucket.id
}
