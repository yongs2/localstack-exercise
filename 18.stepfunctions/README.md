# [Step Functions](https://docs.localstack.cloud/user-guide/aws/stepfunctions/)

See [AWS Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)

## 1. Using AWS CLI

### 1.1 Create a state machine

```sh
# Creates a state machine (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/create-state-machine.html)
awslocal stepfunctions create-state-machine \
    --name "WaitMachine" \
    --definition '{
        "StartAt": "WaitExecution",
        "States": {
            "WaitExecution": {
                "Type": "Wait",
                "Seconds": 10,
                "End": true
            }
        }
    }' \
    --role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"
```

### 1.2 List all the state machines

```sh
# Lists the existing state machines (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/list-state-machines.html)
awslocal stepfunctions list-state-machines

SM_ARN=$(awslocal stepfunctions \
    list-state-machines \
    --query 'stateMachines[?name==`WaitMachine`].stateMachineArn' \
    --output text)
echo "StateMahcineArn: ${SM_ARN}"
```

### 1.3 Retrieve the state machine

```sh
# Provides information about a state machine's definition, its IAM role Amazon Resource Name (ARN), and configuration (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/describe-state-machine.html)
awslocal stepfunctions describe-state-machine --state-machine-arn ${SM_ARN}
```

### 1.4 Execute the state machine

```sh
# Starts a state machine execution (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/start-execution.html)
awslocal stepfunctions start-execution --state-machine-arn ${SM_ARN}
```

### 1.5 Check the status of the execution

```sh
EX_ARN=$(awslocal stepfunctions \
    list-executions \
    --state-machine-arn ${SM_ARN} \
    --query 'executions[0].executionArn' \
    --output text)
echo "ExecutionArn: ${EX_ARN}"
# Provides all information about a state machine execution (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/describe-execution.html)
awslocal stepfunctions describe-execution --execution-arn ${EX_ARN}
```

### 1.6 Update the state machine definition

```sh
# Updates an existing state machine (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/update-state-machine.html)
awslocal stepfunctions \
    update-state-machine \
    --state-machine-arn ${SM_ARN} \
    --definition file://statemachine.json \
    --role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"
```

### 1.7 Delete the state machine

```sh
# Deletes a state machine (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/delete-state-machine.html)
awslocal stepfunctions delete-state-machine --state-machine-arn ${SM_ARN}
```

## 2. Using terraform

- [Resource: aws_sfn_state_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine)

### 2.1 Create a state machine

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 List all the state machines

```sh
awslocal stepfunctions list-state-machines

SM_ARN=$(terraform output -raw state_machine_arn)
echo "StateMahcineArn: ${SM_ARN}"
```

### 2.3 Retrieve the state machine

```sh
awslocal stepfunctions describe-state-machine --state-machine-arn ${SM_ARN}
```

### 2.4 Execute the state machine

```sh
awslocal stepfunctions start-execution --state-machine-arn ${SM_ARN}
```

### 2.5 Check the status of the execution

```sh
EX_ARN=$(awslocal stepfunctions \
    list-executions \
    --state-machine-arn ${SM_ARN} \
    --query 'executions[0].executionArn' \
    --output text)
echo "ExecutionArn: ${EX_ARN}"
awslocal stepfunctions describe-execution --execution-arn ${EX_ARN}
```

### 2.6 Update the state machine definition

```sh
# Updates an existing state machine (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/update-state-machine.html)
awslocal stepfunctions \
    update-state-machine \
    --state-machine-arn ${SM_ARN} \
    --definition file://statemachine.json \
    --role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"
```

### 2.7 Delete the state machine

```sh
terraform destroy -auto-approve
```
