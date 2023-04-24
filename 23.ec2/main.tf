variable "keyName" {
  default = "mung-key"
}

# awslocal ec2 create-security-group --group-name default --description "My security group"
# awslocal ec2 authorize-security-group-ingress \
#   --group-name default \
#   --protocol tcp \
#   --port 8080
resource "aws_security_group" "example" {
  name        = "default"
  description = "My security group"

  ingress {
    description = "default HTTP port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
}

# return the ID of the security group
output "security_group_id" {
  value = aws_security_group.example.id
}

# awslocal ec2 create-key-pair --key-name ${KEY_NAME}
resource "aws_key_pair" "example" {
  key_name   = var.keyName
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

# return the key pair
output "key_pair_arn" {
  value = aws_key_pair.example.arn
}

# awslocal ec2 run-instances \
#   --image-id ami-0c2b8ca1dad447f8a \
#   --count 1 \
#   --instance-type t2.micro \
#   --key-name ${KEY_NAME} \
#   --security-group-ids ${SG_ID}
resource "aws_instance" "example" {
  ami             = "ami-0c2b8ca1dad447f8a"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.example.key_name
  security_groups = ["${aws_security_group.example.name}"]
}

# return the public IP address of the instance
output "public_ip" {
  value = aws_instance.example.public_ip
}
