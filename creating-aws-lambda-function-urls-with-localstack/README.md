# [creating-aws-lambda-function-urls-with-localstack](https://hashnode.localstack.cloud/creating-aws-lambda-function-urls-with-localstack)

## 1. Creating AWS Lambda Function URLs with LocalStack

### 1.1 create lambda function

```sh
cat << EOF | tee lambda_function.py
import json
import requests
from bs4 import BeautifulSoup as bs

def trending():
    url = "https://github.com/trending"
    page = requests.get(url)
    soup = bs(page.text, 'html.parser')
    data = {}
    repo_list = soup.find_all('article', attrs={'class':'Box-row'})
    for repo in repo_list:
        full_repo_name = repo.find('h1').find('a').text.strip().split('/')
        developer_name = full_repo_name[0].strip()
        repo_name = full_repo_name[1].strip()
        data[developer_name] = repo_name
    return data

def lambda_handler(event, context):
    data = trending()
    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }
EOF

cat << EOF | tee requirements.txt
requests
bs4
EOF
```

### 1.2 create lambda function zip

```sh
pip install -r requirements.txt -t .
apk add zip && zip -r function.zip .
```

### 1.3 create lambda function

```sh
awslocal lambda create-function \
    --function-name trending \
    --runtime python3.9 \
    --timeout 10 \
    --zip-file fileb://function.zip \
    --handler lambda_function.lambda_handler \
    --role arn:aws:iam::000000000000:role/cool-stacklifter

awslocal lambda invoke --function-name trending output.log
```

### 1.4 create lambda function url

```sh
awslocal lambda create-function-url-config --function-name trending --auth-type NONE
FUNC_URL=$(awslocal lambda get-function-url-config --function-name trending --query FunctionUrl | sed 's/"//g')

curl -X GET ${FUNC_URL} | jq
```

### 1.5 delete lambda function

```sh
awslocal lambda delete-function --function-name trending
```

## 2. Deploying a Lambda Function URL via Terraform

### 2.1 create zip file

```sh
# create zip file, The zip file should not be too large
pip3 install -r requirements.txt -t .
apk add zip && zip -r function.zip . -x '.terraform/*' '.terraform*' 'terraform.tfstate*'
# delete python libs
find . -mindepth 1 -maxdepth 1 -type d -exec rm -r {} +
```

### 2.2 install tflocal

```sh
apk add python3
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python /tmp/get-pip.py
pip install terraform-local
```

### 2.3 create a new Lambda function

```tf
resource "aws_lambda_function" "trending" {
  filename         = "function.zip"
  function_name    = "trending"
  role             = "cool-stacklifter"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("function.zip")
  runtime          = "python3.9"
}
```

### 2.4 create a Lambda Function URL

```tf
resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.trending.arn
  authorization_type = "NONE"
}

output "function_url" {
  description = "Function URL."
  value       = aws_lambda_function_url.lambda_function_url.function_url
}
```

### 2.5 create a Lambda Function URL with Terraform

```sh
tflocal init
tflocal plan
tflocal apply -auto-approve

FUNC_URL=$(tflocal output -json | jq -r .function_url.value)
curl -X GET ${FUNC_URL} | jq
```

### 2.6 delete resources

```sh
tflocal destroy -auto-approve
```
