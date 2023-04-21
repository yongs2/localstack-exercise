variable "s3Name" {
  default = "foo"
}

variable "tmpDir" {
  default = "/tmp"
}

variable "fileName" {
  default = "custom-vocabulary.txt"
}

# curl -o /tmp/custom-vocabulary.txt -L https://raw.githubusercontent.com/aws-samples/amazon-ivs-auto-captions-web-demo/main/configuration/data/custom-vocabulary.txt
resource "null_resource" "mp3_file" {
  provisioner "local-exec" {
    command = "curl -o ${var.tmpDir}/${var.fileName} -L https://raw.githubusercontent.com/aws-samples/amazon-ivs-auto-captions-web-demo/main/configuration/data/custom-vocabulary.txt"
  }
}

# awslocal s3 mb s3://foo
resource "aws_s3_bucket" "example" {
  bucket        = var.s3Name
  force_destroy = true
}

# awslocal s3 cp /tmp/custom-vocabulary.txt s3://foo/custom-vocabulary.txt
resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.example.id
  key    = var.fileName
  source = "${var.tmpDir}/${var.fileName}"
}

# awslocal transcribe create-vocabulary \
#   --language-code en-US \
#   --vocabulary-name example \
#   --vocabulary-file-uri s3://foo/custom-vocabulary.txt
resource "aws_transcribe_vocabulary" "example" {
  depends_on = [
    aws_s3_object.example
  ]

  vocabulary_name     = "example"
  language_code       = "en-US"
  vocabulary_file_uri = "s3://${aws_s3_bucket.example.id}/${aws_s3_object.example.key}"
}

# return
output "example" {
  value = aws_transcribe_vocabulary.example
}
