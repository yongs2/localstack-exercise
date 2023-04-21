# [Transcribe](https://docs.localstack.cloud/user-guide/aws/transcribe/)

See [Amazon Transcribe](https://docs.aws.amazon.com/transcribe/latest/dg/what-is.html)

## 1. Using AWS CLI

### 1.1 Download Sample audio file

```sh
# Refer to https://aws.amazon.com/ko/getting-started/hands-on/create-audio-transcript-transcribe/
curl -o /tmp/transcribe-sample.mp3 -L https://d1.awsstatic.com/tmt/create-audio-transcript-transcribe/transcribe-sample.5fc2109bb28268d10fbc677e64b7e59256783d3c.mp3
```

### 1.2 Create an S3 bucket and upload the audio file

```sh
awslocal s3 mb s3://foo
awslocal s3 cp /tmp/transcribe-sample.mp3 s3://foo/transcribe-sample.mp3
```

### 1.3 Create the transcription job

```sh
# Transcribes the audio from a media file (https://docs.aws.amazon.com/cli/latest/reference/transcribe/start-transcription-job.html)
awslocal transcribe start-transcription-job \
    --transcription-job-name example \
    --media MediaFileUri=s3://foo/transcribe-sample.mp3 \
    --language-code en-US
```

### 1.4 list all transcription jobs

```sh
# Provides a list of transcription jobs that match the specified criteria (https://docs.aws.amazon.com/cli/latest/reference/transcribe/list-transcription-jobs.html)
awslocal transcribe list-transcription-jobs
```

### 1.5 Check the status of the transcription job

```sh
# Provides information about the specified transcription job (https://docs.aws.amazon.com/cli/latest/reference/transcribe/get-transcription-job.html)
awslocal transcribe get-transcription-job --transcription-job example
```

### 1.6 the transcript can be retrieved from the S3 bucket

```sh
awslocal s3 cp ${BUCKET_URI} /tmp/result.json
jq .results.transcripts[0].transcript /tmp/result.json
```

### 1.7 Delete the transcription job

```sh
# Deletes a transcription job (https://docs.aws.amazon.com/cli/latest/reference/transcribe/delete-transcription-job.html)
awslocal transcribe delete-transcription-job --transcription-job-name example

# Delete the S3 bucket
awslocal s3 rb s3://foo --force
```

### 1.8 Others

- call-analytics-category : NotImplementedError

```sh
awslocal transcribe \
    create-call-analytics-category \
    --category-name "test-category" \
    --rules "NonTalkTimeFilter={Threshold=10}"
awslocal transcribe list-call-analytics-categories

# An error occurred (InternalFailure) when calling the CreateCallAnalyticsCategory operation: The create_call_analytics_category action has not been implemented
```

- language-model : NotImplementedError

```sh
awslocal transcribe create-language-model \
  --language-code en-US \
  --base-model-name base-model-name \
  --model-name cli-clm-example \
  --input-data-config S3Uri="s3://DOC-EXAMPLE-BUCKET/Amazon-S3-Prefix-for-training-data",TuningDataS3Uri="s3://DOC-EXAMPLE-BUCKET/Amazon-S3-Prefix-for-tuning-data",DataAccessRoleArn="arn:aws:iam::AWS-account-number:role/IAM-role-with-permissions-to-create-a-custom-language-model"
awslocal transcribe list-language-models

# An error occurred (InternalFailure) when calling the CreateLanguageModel operation: The create_language_model action has not been implemented
```

- vocabulary : Implemented

```sh
awslocal transcribe create-vocabulary \
  --language-code en-US \
  --vocabulary-name cli-vocab-example \
  --vocabulary-file-uri s3://foo/the-text-file-for-the-custom-vocabulary.txt
awslocal transcribe list-vocabularies
awslocal transcribe get-vocabulary --vocabulary-name cli-vocab-example
awslocal transcribe delete-vocabulary --vocabulary-name cli-vocab-example
```

- vocabulary-filter : NotImplementedError

```sh
awslocal transcribe create-vocabulary-filter \
  --language-code en-US \
  --vocabulary-filter-file-uri s3://foo/vocabulary-filter.txt \
  --vocabulary-filter-name cli-vocabulary-filter-example
awslocal transcribe list-vocabulary-filters

# An error occurred (InternalFailure) when calling the CreateVocabularyFilter operation: The create_vocabulary_filter action has not been implemented
```

- tag-resource : NotImplementedError

```sh
RSRC_ARN=arn:aws:transcribe:us-west-2:111122223333:transcription-job/transcription-job-name
awslocal transcribe tag-resource --resource-arn ${RSRC_ARN} --tags "Key=tag1Key,Value=tag1Value"
awslocal transcribe list-tags-for-resource --resource-arn ${RSRC_ARN}
awslocal transcribe untag-resource --resource-arn ${RSRC_ARN} --tag-keys tag1Key

# An error occurred (InternalFailure) when calling the ListTagsForResource operation: The list_tags_for_resource action has not been implemented
```

## 2. Using terraform

- [Resource: aws_transcribe_vocabulary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transcribe_vocabulary)

### 2.1 Creates a new custom vocabulary

- FIXME: Error: listing tags for Transcribe Vocabulary (arn:aws:transcribe:us-east-1::vocabulary/example): operation error Transcribe: ListTagsForResource, https response error StatusCode: 501, RequestID: HG5FSLLNJNU3OUZJARSTVAHZL7F3J8B3XJHS40RVT7BGQC91XXFB, api error InternalFailure: The list_tags_for_resource action has not been implemented

```sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### 2.2 Check the custom vocubulary

```sh
awslocal transcribe list-vocabularies
awslocal transcribe get-vocabulary --vocabulary-name example
```

### 2.3 Delete the custom vocabulary

```sh
terraform destroy -auto-approve

awslocal transcribe delete-vocabulary --vocabulary-name example
awslocal transcribe list-vocabularies

awslocal s3 rb s3://foo --force
awslocal s3 ls
```
