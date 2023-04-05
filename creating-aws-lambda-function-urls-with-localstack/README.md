# [creating-aws-lambda-function-urls-with-localstack](https://hashnode.localstack.cloud/creating-aws-lambda-function-urls-with-localstack)

## create lambda function

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

## create lambda function zip

```sh
pip install -r requirements.txt -t .
apk add zip && zip -r function.zip .
```

## create lambda function

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

## create lambda function url

```sh
awslocal lambda create-function-url-config --function-name trending --auth-type NONE
FUNC_URL=$(awslocal lambda get-function-url-config --function-name trending --query FunctionUrl | sed 's/"//g')

curl -X GET ${FUNC_URL} | jq
```

## delete lambda function

```sh
awslocal lambda delete-function --function-name trending
```
