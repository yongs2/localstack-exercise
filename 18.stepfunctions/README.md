# [Step Functions](https://docs.localstack.cloud/user-guide/aws/stepfunctions/)

See [AWS Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)

## 1. Create a state machine

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

## 2. List all the state machines

```sh
# Lists the existing state machines (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/list-state-machines.html)
awslocal stepfunctions list-state-machines

SM_ARN=$(awslocal stepfunctions list-state-machines --query 'stateMachines[0].stateMachineArn' --output text)
echo "StateMahcineArn: ${SM_ARN}"
```

## 3. Retrieve the state machine

```sh
# Provides information about a state machine's definition, its IAM role Amazon Resource Name (ARN), and configuration (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/describe-state-machine.html)
awslocal stepfunctions describe-state-machine --state-machine-arn ${SM_ARN}
```

## 4. Execute the state machine

```sh
# Starts a state machine execution (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/start-execution.html)
awslocal stepfunctions start-execution --state-machine-arn ${SM_ARN}
```

## 5. Check the status of the execution

```sh
EX_ARN=$(awslocal stepfunctions list-executions --state-machine-arn ${SM_ARN} --query 'executions[0].executionArn' --output text)
echo "ExecutionArn: ${EX_ARN}"
# Provides all information about a state machine execution (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/describe-execution.html)
awslocal stepfunctions describe-execution --execution-arn ${EX_ARN}
```

## 6. Update the state machine definition

```sh
# Updates an existing state machine (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/update-state-machine.html)
awslocal stepfunctions update-state-machine \
    --state-machine-arn ${SM_ARN} \
    --definition file://statemachine.json \
    --role-arn "arn:aws:iam::000000000000:role/stepfunctions-role"
```

## 7. Delete the state machine

```sh
# Deletes a state machine (https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/delete-state-machine.html)
awslocal stepfunctions delete-state-machine --state-machine-arn ${SM_ARN}
```
