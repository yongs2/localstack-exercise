export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

SAMPLE_AUDIO_URL:=https://d1.awsstatic.com/tmt/create-audio-transcript-transcribe/transcribe-sample.5fc2109bb28268d10fbc677e64b7e59256783d3c.mp3

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

download:		## Download Sample audio file
	curl -s -o /tmp/transcribe-sample.mp3 -L ${SAMPLE_AUDIO_URL}
	awslocal s3 mb s3://foo
	awslocal s3 cp /tmp/transcribe-sample.mp3 s3://foo/transcribe-sample.mp3

create:			## Create a transcription job
	awslocal transcribe start-transcription-job \
		--transcription-job-name example \
		--media MediaFileUri=s3://foo/transcribe-sample.mp3 \
		--language-code en-IN

list:			## List all the transcription jobs
	awslocal transcribe list-transcription-jobs

bucket:			## Get S3 bucket URI
	$(eval BUCKET_URI=$(shell awslocal transcribe get-transcription-job --transcription-job example --query TranscriptionJob.Transcript.TranscriptFileUri --output text))

script: bucket	##  the transcript can be retrieved from the S3 bucket
	awslocal s3 cp ${BUCKET_URI} /tmp/result.json
	jq .results.transcripts[0].transcript /tmp/result.json

clean:			## Delete transcription job
	awslocal transcribe delete-transcription-job --transcription-job-name example
	awslocal s3 rb s3://foo --force

.PHONY: usage install download create list bucket script clean
