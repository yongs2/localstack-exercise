# awslocal iam create-user --user-name test
variable "username" {
  default = "test"
}

resource "aws_iam_user" "test" {
  name = var.username
}

# awslocal iam create-access-key --user-name test 
resource "aws_iam_access_key" "testkey" {
  user = aws_iam_user.test.name
}

# Enforcing IAM Policies
data "aws_iam_policy_document" "testpd" {
  statement {
    effect    = "Allow"
    actions   = ["s3:CreateBucket"]
    resources = ["*"]
  }
}
# awslocal iam create-policy --policy-name p1  --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":"s3:CreateBucket","Resource":"*"}]}'
resource "aws_iam_policy" "p1" {
  name        = "p1"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.testpd.json
}
# awslocal iam attach-user-policy --user-name test --policy-arn arn:aws:iam::000000000000:policy/p1
resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.test.name
  policy_arn = aws_iam_policy.p1.arn
}

output "iam" {
  description = "value of the iam"
  value       = aws_iam_user.test
}

output "p1" {
  description = "value of the iam user policy"
  value       = aws_iam_policy.p1
}

output "test-attach" {
  description = "value of the attach-user-policy"
  value       = aws_iam_user_policy_attachment.test-attach
}

