export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

KEY_NAME:=mung-key
GRP_NAME:=default

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

lsimage:		## List AMI images
	awslocal ec2 describe-images --query 'Images[*].{ID:ImageId,Name:Name}'

crsg:			## Create Security Group
	awslocal ec2 create-security-group --group-name ${GRP_NAME} --description "My security group"
	awslocal ec2 authorize-security-group-ingress \
		--group-id ${GRP_NAME} \
		--protocol tcp \
		--port 8080

sg:				## Get Seurity Group ID
	$(eval SG_ID=$(shell awslocal ec2 \
		describe-security-groups \
		--group-names ${GRP_NAME} \
		--output json \
		--query 'SecurityGroups[0].GroupId' \
		--output text))

crkp:			## Create key pair
	awslocal ec2 create-key-pair --key-name ${KEY_NAME}
	awslocal ec2 describe-key-pairs --key-name ${KEY_NAME}

create: sg		## Creates a ec2 instance
	awslocal ec2 run-instances \
		--image-id ami-0c2b8ca1dad447f8a \
		--count 1 \
		--instance-type t2.micro \
		--key-name ${KEY_NAME} \
		--security-group-ids ${SG_ID}

list:			## list all ec2 instances
	awslocal ec2 describe-instances
	awslocal ec2 describe-key-pairs
	awslocal ec2 describe-security-groups

instid:			## Get instance ID
	$(eval INST_ID=$(shell awslocal ec2 \
		describe-instances \
		--query 'Reservations[].Instances[?KeyName==`'${KEY_NAME}'`].InstanceId' \
		--output text))

clean: instid	## Delete ec2 instance
	awslocal ec2 terminate-instances --instance-ids ${INST_ID}
	awslocal ec2 \
		describe-instances \
		--query 'Reservations[].Instances[?InstanceId==`'${INST_ID}'`].State.Name' \
		--output text
	awslocal ec2 \
		delete-key-pair \
		--key-name ${KEY_NAME}
	awslocal ec2 delete-security-group --group-name ${GRP_NAME}

.PHONY: usage install crsg crkp create list clean
