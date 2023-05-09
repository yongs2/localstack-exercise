# [Localstack with Terraform and Docker for running AWS locally](https://dev.to/mrwormhole/localstack-with-terraform-and-docker-for-running-aws-locally-3a6d)

- Refer [hotdog-localstack-PoC](https://github.com/MrWormHole/hotdog-localstack-PoC)

## Init

```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

## list Resources

```sh
awslocal lambda list-functions
awslocal dynamodb list-tables
awslocal kinesis list-streams
```

## Invoke Lambda function

- invoke it using the AWS CLI

```sh
# call lambda-dogcatcher with payload that has a quantity value of 2
awslocal lambda invoke --function-name=$(terraform output -raw dogCatcher) --payload '{"quantity": 2}' /tmp/dogCatcher.json
# Call PutRecord on kinesis' caughtDogs stream twice with a set quantity value
# Run lambda-dogprocessor because dog_processor_trigger is set to caught_dogs_stream in aws_kinesis_stream.
# The lambda-dogprocessor reads the KinesisEvent, executes PutItem on dynamodb, and then executes PutRecord on pubsub with the hotDogs stream from kinesis.
# Run lambda-hotdogdespatcher because hot_dog_despatcher_trigger is set to hot_dogs_stream in aws_kinesis_stream.
# The lambda-hotdogdespatcher reads the KinesisEvent and executes a PutRecord on pubsub with the eatenHotDogs stream from kinesis.
# Rub lambda-dogprcessor because dog_processor_trigger_2 is set to eaten_hot_dogs_stream in aws_kinesis_stream.

# Look up the data in the dogs table to see if there are two.
awslocal dynamodb scan --table-name dogs

awslocal kinesis describe-stream-summary --stream-name caughtDogs
awslocal kinesis describe-stream-summary --stream-name hotDogs
awslocal kinesis describe-stream-summary --stream-name eatenHotDogs
```

## Clean up

```sh
terraform destroy -auto-approve
rm -f /tmp/*.zip; rm -f /tmp/*.json;
rm -Rf /tmp/dogCatcher
rm -Rf /tmp/hotDogDespatcher
rm -Rf /tmp/dogProcessor
```
