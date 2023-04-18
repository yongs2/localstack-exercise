# awslocal cloudformation deploy --stack-name cfn-quickstart-stack --template-file "./cfn-quickstart-stack.yaml"
resource "aws_cloudformation_stack" "cfn" {
  name         = "cfn-quickstart-stack"
  capabilities = ["CAPABILITY_IAM"]
  parameters = {
    "BucketName" = "cfn-quickstart-bucket"
  }

  // template_body = file("./cfn-quickstart-stack.yaml")
  template_body = jsonencode({
    Resources = {
      localBucket = {
        Type = "AWS::S3::Bucket"
        Properties = {
          BucketName = "cfn-quickstart-bucket"
        }
      }
    }
  })
}

# awslocal cloudformation deploy --stack-name ec2-instance --template-file "./ec2-instance.yaml"
resource "aws_cloudformation_stack" "ec2" {
  name         = "ec2-instance"
  capabilities = ["CAPABILITY_IAM"]
  parameters = {
    "KeyName" = "cfn-quickstart-key"
  }

  // template_body = file("./ec2-instance.yaml")
  template_body = jsonencode({
    Resources = {
      MyEC2Instance = {
        Type = "AWS::EC2::Instance"
        Properties = {
          # Amazon Linux 2 AMI
          ImageId      = "ami-0c94855ba95c71c99"
          InstanceType = "t2.micro"
          KeyName      = "my-key-pair"
          SecurityGroupIds = [
            "sg-0123456789abcdef0"
          ]
          Tags = [
            {
              Key   = "Name"
              Value = "MyInstance"
            }
          ]
        }
      }
    }
  })
}
