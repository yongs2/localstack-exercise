variable "smName" {
  default = "WaitMachine"
}

# role
data "aws_iam_policy_document" "sfn_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_sfn" {
  name               = "stepfunctions-role"
  assume_role_policy = data.aws_iam_policy_document.sfn_assume_role.json
}

# awslocal stepfunctions create-state-machine \
#     --name "WaitMachine" \
#     --definition '{
#         "StartAt": "WaitExecution",
#         "States": {
#             "WaitExecution": {
#                 "Type": "Wait",
#                 "Seconds": 10,
#                 "End": true
#             }
#         }
#     }' \
#     --role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"
resource "aws_sfn_state_machine" "example" {
  name     = var.smName
  role_arn = aws_iam_role.iam_for_sfn.arn


  definition = <<EOF
{
  "StartAt": "WaitExecution",
  "States": {
    "WaitExecution": {
      "Type": "Wait",
      "Seconds": 10,
      "End": true
    }
  }
}
EOF
}

# return state machine arn
output "state_machine_arn" {
  value = aws_sfn_state_machine.example.arn
}
