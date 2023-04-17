# [SWF (Simple Workflow Service)](https://docs.localstack.cloud/references/coverage/coverage_swf/)

See [Amazon Simple Workflow Service](https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-welcome.html)

## 1. Setup

- [Refer test cases](https://github.com/localstack/localstack/blob/master/tests/integration/test_swf.py)

## 1.1 RegisterDomain

```sh
# register-domain
# Registers a new domain (https://docs.aws.amazon.com/cli/latest/reference/swf/register-domain.html)
awslocal swf \
  register-domain \
    --name default \
    --workflow-execution-retention-period-in-days 1 \
    --description "Default domain for localstack"
```

## 1.2 ListDomains

```sh
# Returns the list of domains registered in the account (https://docs.aws.amazon.com/cli/latest/reference/swf/list-domains.html)
awslocal swf \
  list-domains \
    --registration-status REGISTERED
```

## 1.3 DescribeDomain

```sh
# describe-domain
# Returns information about the specified domain, including description and status (https://docs.aws.amazon.com/cli/latest/reference/swf/describe-domain.html)
awslocal swf \
  describe-domain \
    --name default
```

## 2. Given workflow

### 2.1 RegisterWorkflowType

```sh
# register-workflow-type
# Registers a new workflow type and its configuration settings in the specified domain (https://docs.aws.amazon.com/cli/latest/reference/swf/register-workflow-type.html)
awslocal swf \
  register-workflow-type \
    --domain default \
    --name "MySimpleWorkflow" \
    --workflow-version "v1"
```

### 2.2 ListWorkflowTypes

```sh
# list-workflow-types
# Returns information about workflow types in the specified domain (https://docs.aws.amazon.com/cli/latest/reference/swf/list-workflow-types.html)
awslocal swf \
  list-workflow-types \
    --domain default \
    --registration-status REGISTERED
```

### 2.3 DescribeWorkflowType

```sh
# describe-workflow-type
# Returns information about the specified workflow type (https://docs.aws.amazon.com/cli/latest/reference/swf/describe-workflow-type.html)
awslocal swf \
  describe-workflow-type \
    --domain default \
    --workflow-type "name=MySimpleWorkflow,version=v1"
```

### 2.4 RegisterActivityType

```sh
# register-activity-type
# Registers a new activity type along with its configuration settings in the specified domain (https://docs.aws.amazon.com/cli/latest/reference/swf/register-activity-type.html)
awslocal swf \
  register-activity-type \
    --domain default \
    --name "MySimpleActivity" \
    --activity-version "v1" \
    --default-task-list "name=default"
```

### 2.5 ListActivityTypes

```sh
# list-activity-types
# Returns information about all activities registered in the specified domain that match the specified name and registration status (https://docs.aws.amazon.com/cli/latest/reference/swf/list-activity-types.html)
awslocal swf \
  list-activity-types \
    --domain default \
    --registration-status REGISTERED
```

### 2.6 DescribeActivityType

```sh
# describe-activity-type
# Returns information about the specified activity type (https://docs.aws.amazon.com/cli/latest/reference/swf/describe-activity-type.html)
awslocal swf \
  describe-activity-type \
    --domain default \
    --activity-type "name=MySimpleActivity,version=v1"
```

## 3. When workflow is started

### 3.1 StartWorkflowExecution

```sh
# start-workflow-execution
# Starts an execution of the workflow type in the specified domain using the provided workflowId and input data (https://docs.aws.amazon.com/cli/latest/reference/swf/start-workflow-execution.html)
WORKFLOW_ID="workflow-id-1"

RUN_ID=$(awslocal swf \
  start-workflow-execution \
    --domain default \
    --workflow-id ${WORKFLOW_ID} \
    --workflow-type "name=MySimpleWorkflow,version=v1" \
    --task-list "name=default" \
    --execution-start-to-close-timeout 60 \
    --task-start-to-close-timeout 60 \
    --child-policy TERMINATE \
    --query 'runId' \
    --output text)
```

### 3.2 GetWorkflowExecutionHistory

```sh
# get-workflow-execution-history
# Returns the history of the specified workflow execution (https://docs.aws.amazon.com/cli/latest/reference/swf/get-workflow-execution-history.html)
awslocal swf \
  get-workflow-execution-history \
    --domain default \
    --execution "workflowId=${WORKFLOW_ID},runId=${RUN_ID}"
```

### 3.3 DescribeWorkflowExecution

```sh
# describe-workflow-execution
# Returns information about the specified workflow execution (https://docs.aws.amazon.com/cli/latest/reference/swf/describe-workflow-execution.html)
awslocal swf \
  describe-workflow-execution \
    --domain default \
    --execution "workflowId=${WORKFLOW_ID},runId=${RUN_ID}"
```

## 4. Then workflow components execute

### 4.1 PollForDecisionTask

```sh
# poll-for-decision-task
# Used by deciders to get a DecisionTask from the specified decision taskList (https://docs.aws.amazon.com/cli/latest/reference/swf/poll-for-decision-task.html)
awslocal swf \
  poll-for-decision-task \
    --domain default \
    --task-list "name=default"
```

### 4.2 RespondDecisionTaskCompleted

- FIXME: task-token: Invalid token

```sh
# respond-decision-task-completed
# Used by deciders to tell the service that the DecisionTask identified by the taskToken has successfully completed (https://docs.aws.amazon.com/cli/latest/reference/swf/respond-decision-task-completed.html)
awslocal swf \
  respond-decision-task-completed \
    --task-token "test" \
    --decisions "decisionType=ScheduleActivityTask,activityType={name=MySimpleActivity,version=v1},activityId=1"
```

### 4.3 PollForActivityTask

```sh
# poll-for-activity-task
# Used by workers to get an ActivityTask from the specified activity taskList (https://docs.aws.amazon.com/cli/latest/reference/swf/poll-for-activity-task.html)
awslocal swf \
  poll-for-activity-task \
    --domain default \
    --task-list "name=default"
```

### 4.4 RespondActivityTaskCompleted

- FIXME: task-token: Invalid token

```sh
# respond-activity-task-completed
# Used by workers to tell the service that the ActivityTask identified by the taskToken completed successfully with a result (if provided) (https://docs.aws.amazon.com/cli/latest/reference/swf/respond-activity-task-completed.html)
awslocal swf \
  respond-activity-task-completed \
    --task-token "test" \
    --result "activity success"
```

## 5. Others

### 5.1 DeprecateWorkflowType

```sh
# deprecate-workflow-type
# Deprecates the specified workflow type (https://docs.aws.amazon.com/cli/latest/reference/swf/deprecate-workflow-type.html)
awslocal swf \
  deprecate-workflow-type \
    --domain default \
    --workflow-type "name=MySimpleWorkflow,version=v1"
```

### 5.2 UndeprecateWorkflowType

```sh
# undeprecate-workflow-type
# Undeprecates the specified workflow type (https://docs.aws.amazon.com/cli/latest/reference/swf/undeprecate-workflow-type.html)
awslocal swf \
  undeprecate-workflow-type \
    --domain default \
    --workflow-type "name=MySimpleWorkflow,version=v1"
```

### 5.3 DeprecateActivityType

```sh
# deprecate-activity-type
# Deprecates the specified activity type (https://docs.aws.amazon.com/cli/latest/reference/swf/deprecate-activity-type.html)
awslocal swf \
  deprecate-activity-type \
    --domain default \
    --activity-type "name=MySimpleActivity,version=v1"
```

### 5.4 UndeprecateActivityType

```sh
# undeprecate-activity-type
# Undeprecates the specified activity type (https://docs.aws.amazon.com/cli/latest/reference/swf/undeprecate-activity-type.html)
awslocal swf \
  undeprecate-activity-type \
    --domain default \
    --activity-type "name=MySimpleActivity,version=v1"
```

### 5.5 DeprecateDomain

```sh
# deprecate-domain
# Deprecates the specified domain (https://docs.aws.amazon.com/cli/latest/reference/swf/deprecate-domain.html)
awslocal swf \
  deprecate-domain \
    --name default
```

### 5.6 UndeprecateDomain

```sh
# undeprecate-domain
# Undeprecates the specified domain (https://docs.aws.amazon.com/cli/latest/reference/swf/undeprecate-domain.html)
awslocal swf \
  undeprecate-domain \
    --name default
```

### 5.7 CountPendingActivityTasks

```sh
# count-pending-activity-tasks
# Returns the estimated number of activity tasks in the specified task list (https://docs.aws.amazon.com/cli/latest/reference/swf/count-pending-activity-tasks.html)
awslocal swf \
  count-pending-activity-tasks \
    --domain default \
    --task-list "name=default"
```

### 5.8 CountPendingDecisionTasks

```sh
# count-pending-decision-tasks
# Returns the estimated number of decision tasks in the specified task list (https://docs.aws.amazon.com/cli/latest/reference/swf/count-pending-decision-tasks.html)
awslocal swf \
  count-pending-decision-tasks \
    --domain default \
    --task-list "name=default"
```

### 5.9 RespondActivityTaskFailed

- FIXME: task-token: Invalid token

```sh
# respond-activity-task-failed
# Used by workers to tell the service that the ActivityTask identified by the taskToken has failed with reason (if specified) and details (if specified) (https://docs.aws.amazon.com/cli/latest/reference/swf/respond-activity-task-failed.html)
awslocal swf \
  respond-activity-task-failed \
    --task-token "test" \
    --reason "activity failed" \
    --details "activity failed"
```

### 5.10 RecordActivityTaskHeartbeat

- FIXME: task-token: Invalid token

```sh
# record-activity-task-heartbeat
# Used by workers to report to the service that the ActivityTask represented by the specified taskToken is still making progress (https://docs.aws.amazon.com/cli/latest/reference/swf/record-activity-task-heartbeat.html)
awslocal swf \
  record-activity-task-heartbeat \
    --task-token "test" \
    --details "activity heartbeat"
```

### 5.11 ListOpenWorkflowExecutions

```sh
# list-open-workflow-executions
# Returns a list of open workflow executions in the specified domain that meet the filtering criteria (https://docs.aws.amazon.com/cli/latest/reference/swf/list-open-workflow-executions.html)
awslocal swf \
  list-open-workflow-executions \
    --domain default \
    --start-time-filter "oldestDate=2021-01-01T00:00:00Z,latestDate=2026-01-01T00:00:00Z"
```

### 5.12 ListClosedWorkflowExecutions

```sh
# list-closed-workflow-executions
# Returns a list of closed workflow executions in the specified domain that meet the filtering criteria (https://docs.aws.amazon.com/cli/latest/reference/swf/list-closed-workflow-executions.html)
awslocal swf \
  list-closed-workflow-executions \
    --domain default \
    --start-time-filter "oldestDate=2021-01-01T00:00:00Z,latestDate=2026-01-01T00:00:00Z"
```

### 5.13 SignalWorkflowExecution

- FIXME: An error occurred (UnknownResourceFault) when calling the TerminateWorkflowExecution operation: Unknown execution, workflowId = workflow-id-1

```sh
# signal-workflow-execution
# Records a WorkflowExecutionSignaled event in the workflow execution history and creates a decision task for the workflow execution identified by the given domain, runId, and workflowId (https://docs.aws.amazon.com/cli/latest/reference/swf/signal-workflow-execution.html)
awslocal swf \
  signal-workflow-execution \
    --domain default \
    --workflow-id "${WORKFLOW_ID}" \
    --signal-name "test" \
    --input "test"
    # --run-id "${RUN_ID}" \
```


        domain: DomainName,
        workflow_id: WorkflowId,
        signal_name: SignalName,

### 5.14 TerminateWorkflowExecution

- FIXME: An error occurred (UnknownResourceFault) when calling the TerminateWorkflowExecution operation: Unknown execution, workflowId = workflow-id-1

```sh
# terminate-workflow-execution
# Records a WorkflowExecutionTerminated event and forces closure of the workflow execution identified by the given domain, runId, and workflowId (https://docs.aws.amazon.com/cli/latest/reference/swf/terminate-workflow-execution.html)
awslocal swf \
  terminate-workflow-execution \
    --domain default \
    --workflow-id "${WORKFLOW_ID}" \
    --reason "test"
    # --run-id "${RUN_ID}" \
```
