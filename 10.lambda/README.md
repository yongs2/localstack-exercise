# [Lambda](https://docs.localstack.cloud/user-guide/aws/lambda/)

See [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

## 1. Creating Lambda layers locally

```sh
# create layer zip file
mkdir -p /tmp/python/
cat << EOF | tee /tmp/python/testlayer.py
def util():
  print("Output from Lambda layer util function")
EOF
(cd /tmp; zip -r testlayer.zip python)

# Creates an Lambda layer from a ZIP archive (https://docs.aws.amazon.com/cli/latest/reference/lambda/publish-layer-version.html)
awslocal lambda publish-layer-version \
    --layer-name layer1 \
    --zip-file fileb:///tmp/testlayer.zip

# Returns information about a version of an Lambda layer (https://docs.aws.amazon.com/cli/latest/reference/lambda/get-layer-version.html)
LAYER_ARN=$(awslocal lambda get-layer-version \
    --layer-name layer1 \
    --version-number 2 \
    --query LayerArn --output text)

# Lists Lambda layers and shows information about the latest version of each (https://docs.aws.amazon.com/cli/latest/reference/lambda/list-layers.html)
LAYER_VER_ARN=$(awslocal lambda list-layers --query 'Layers[?LayerName==`layer1`].LatestMatchingVersion.LayerVersionArn' --output text)
```

### 2. Create a simple Lambda function

```sh
# create function zip file
cat << EOF | tee /tmp/testlambda.py
def handler(*args, **kwargs):
  import testlayer; testlayer.util()
  print("Debug output from Lambda function")
EOF
(cd /tmp; zip testlambda.zip testlambda.py)

# Creates a Lambda function (https://docs.aws.amazon.com/cli/latest/reference/lambda/create-function.html)
awslocal lambda create-function \
  --function-name func1 \
  --runtime python3.8 \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler testlambda.handler \
  --timeout 30 \
  --zip-file fileb:///tmp/testlambda.zip \
  --layers ${LAYER_VER_ARN}

# Returns a list of Lambda functions (https://docs.aws.amazon.com/cli/latest/reference/lambda/list-functions.html)
awslocal lambda list-functions
```

## 3. Get logs

```sh
# Invokes a Lambda function (https://docs.aws.amazon.com/cli/latest/reference/lambda/invoke.html)
awslocal lambda invoke \
    --function-name func1 \
    out.log \
    --log-type Tail \
    --query 'LogResult' \
    --output text |  base64 -d
```

## 4. Update Function

```sh
# Modify the version-specific settings of a Lambda function (https://docs.aws.amazon.com/cli/latest/reference/lambda/update-function-configuration.html)
awslocal lambda update-function-configuration \
  --function-name func1 \
  --memory-size 256
```

## 5. Retrieve a Lambda function

```sh
# Returns information about the function or function version (https://docs.aws.amazon.com/cli/latest/reference/lambda/get-function.html)
awslocal lambda get-function --function-name func1
```

## 6. Clean Up

```sh
# Deletes a Lambda function (https://docs.aws.amazon.com/cli/latest/reference/lambda/delete-function.html)
awslocal lambda delete-function --function-name func1
awslocal lambda list-functions

# Delete layer
awslocal lambda delete-layer-version --layer-name layer1 --version-number 1
awslocal lambda list-layers
```
