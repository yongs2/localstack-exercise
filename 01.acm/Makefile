export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

request:	## Request a certificate
	awslocal acm request-certificate \
        --domain-name www.example.com \
        --validation-method DNS \
        --options CertificateTransparencyLoggingPreference=DISABLED

list:		## List all certificates
	awslocal acm list-certificates --max-items 10

get_arn:	## get the certificate
	$(eval CERT_ARN=$(shell awslocal acm list-certificates --query CertificateSummaryList[0].CertificateArn | sed 's/"//g'))

view: get_arn	## view the certificate
	awslocal acm get-certificate --certificate-arn ${CERT_ARN}
	awslocal acm describe-certificate --certificate-arn ${CERT_ARN}

clean: get_arn 	## Remove the certificate
	awslocal acm delete-certificate --certificate-arn ${CERT_ARN}
	
.PHONY: usage install request list get_arn view clean
