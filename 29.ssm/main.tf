variable "docName" {
  default = "example"
}

# awslocal ssm \
#   create-document \
# 		--content file://01_create.yml \
# 		--name ${DOC_NAME} \
# 		--document-type "Automation" \
# 		--document-format YAML
# awslocal ssm \
# 	add-tags-to-resource \
# 		--resource-type "Document" \
# 		--resource-id ${DOC_NAME} \
# 		--tags "Key=Environment,Value=Dev" "Key=Owner,Value=JohnDoe"
resource "aws_ssm_document" "example" {
  name            = var.docName
  document_type   = "Automation"
  document_format = "YAML"
  content         = <<EOF
schemaVersion: "2.2"
description: runShellScript with command strings stored as Parameter Store parameter
parameters:
  commands:
    type: StringList
    description: "(Required) The commands to run on the instance."
    default: "{{ ssm:myShellCommands }}"
mainSteps:
  - action: aws:runShellScript
    name: runShellScriptDefaultParams
    inputs:
      runCommand:
        - "{{ commands }}"
EOF

  tags = {
    Environment = "Dev"
    Owner       = "JohnDoe"
  }
}

# return document
output "document" {
  value = aws_ssm_document.example
}

variable "parameterName" {
  default = "/my/parameter"
}

# awslocal ssm \
# 	put-parameter \
# 		--name ${PARAM_NAME} \
# 		--value "my-value" \
# 		--type String
# awslocal ssm \
# 		add-tags-to-resource \
# 		--resource-type "Parameter" \
# 		--resource-id ${PARAM_NAME} \
# 		--tags "Key=Environment,Value=Dev" "Key=Owner,Value=JohnDoe"
resource "aws_ssm_parameter" "example" {
  name  = var.parameterName
  value = "my-value"
  type  = "String"

  tags = {
    Environment = "Dev"
    Owner       = "JohnDoe"
  }
}

# return resource-id of parameter
output "parameter_id" {
  value = aws_ssm_parameter.example.id
}
