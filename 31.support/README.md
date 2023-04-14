# [Support API](https://docs.localstack.cloud/references/coverage/coverage_support/)

See [AWS Support](https://docs.aws.amazon.com/awssupport/latest/user/getting-started.html)

## 1. CreateCase

```sh
# Creates a case in the Amazon Web Services Support Center (https://docs.aws.amazon.com/cli/latest/reference/support/create-case.html)
awslocal support \
  create-case \
    --category-code "using-aws" \
    --cc-email-addresses "myemail@example.com" \
    --communication-body "I want to learn more about an AWS service." \
    --issue-type "technical" \
    --language "en" \
    --service-code "general-info" \
    --severity-code "low" \
    --subject "Question about my account"
```

## 2. DescribeCases

```sh
# Returns a list of cases that you specify by passing one or more case IDs (https://docs.aws.amazon.com/cli/latest/reference/support/describe-cases.html)
awslocal support \
  describe-cases \
    --display-id "1234567890" \
    --after-time "2020-03-23T21:31:47.774Z" \
    --include-resolved-cases \
    --language "en" \
    --no-include-communications \
    --max-item 1

awslocal support \
  describe-cases \
    --case-id-list "case-12345678910-2020-KFEJCgiHJlA3IlEb"
```

## 3. DescribeTrustedAdvisorChecks

```sh
# Returns information about all available Trusted Advisor checks, including the name, ID, category, description, and metadata (https://docs.aws.amazon.com/cli/latest/reference/support/describe-trusted-advisor-checks.html)
awslocal support \
  describe-trusted-advisor-checks \
    --language "en"
```

## 4. RefreshTrustedAdvisorCheck

```sh
# Refreshes the Trusted Advisor check that you specify using the check ID (https://docs.aws.amazon.com/cli/latest/reference/support/refresh-trusted-advisor-check.html)
awslocal support \
  refresh-trusted-advisor-check \
    --check-id "1234567890"
```

## 5. ResolveCase

```sh
# Resolves a support case (https://docs.aws.amazon.com/cli/latest/reference/support/resolve-case.html)
awslocal support \
  resolve-case \
    --case-id "case-12345678910-2020-KFEJCgiHJlA3IlEb"
```
