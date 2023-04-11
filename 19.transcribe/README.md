# [Transcribe](https://docs.localstack.cloud/user-guide/aws/transcribe/)

See [Amazon Transcribe](https://docs.aws.amazon.com/transcribe/latest/dg/what-is.html)

## 1. Download Sample audio file

```sh
# Refer to https://aws.amazon.com/ko/getting-started/hands-on/create-audio-transcript-transcribe/
curl -o /tmp/transcribe-sample.mp3 -L https://d1.awsstatic.com/tmt/create-audio-transcript-transcribe/transcribe-sample.5fc2109bb28268d10fbc677e64b7e59256783d3c.mp3
```

## 2. Create an S3 bucket and upload the audio file

```sh
awslocal s3 mb s3://foo
awslocal s3 cp /tmp/transcribe-sample.mp3 s3://foo/transcribe-sample.mp3
```

## 3. Create the transcription job

```sh
# Transcribes the audio from a media file (https://docs.aws.amazon.com/cli/latest/reference/transcribe/start-transcription-job.html)
awslocal transcribe start-transcription-job \
    --transcription-job-name example \
    --media MediaFileUri=s3://foo/transcribe-sample.mp3 \
    --language-code en-IN
```

## 4. list all transcription jobs

```sh
# Provides a list of transcription jobs that match the specified criteria (https://docs.aws.amazon.com/cli/latest/reference/transcribe/list-transcription-jobs.html)
awslocal transcribe list-transcription-jobs
```

## 5. Check the status of the transcription job

```sh
# Provides information about the specified transcription job (https://docs.aws.amazon.com/cli/latest/reference/transcribe/get-transcription-job.html)
awslocal transcribe get-transcription-job --transcription-job example
```

## 6. the transcript can be retrieved from the S3 bucket

```sh
awslocal s3 cp ${BUCKET_URI} /tmp/result.json
jq .results.transcripts[0].transcript /tmp/result.json
```

## 7. Delete the transcription job

```sh
# Deletes a transcription job (https://docs.aws.amazon.com/cli/latest/reference/transcribe/delete-transcription-job.html)
awslocal transcribe delete-transcription-job --transcription-job-name example

# Delete the S3 bucket
awslocal s3 rb s3://foo --force
```
