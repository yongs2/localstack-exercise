export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

CIDR_1="10.0.1.0/24"
IP_1=10.0.1.5
CIDR_2="10.0.2.0/24"
IP_2=10.0.2.6
GRP_NAME=MySecurityGroup
EP_NAME=my-inbound-endpoint

usage:			## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:		## Install dependencies
	@which awslocal || pip install awscli-local

crvpc1:			# Create a vpc1
	awslocal ec2 \
		create-vpc \
		--cidr-block ${CIDR_1} \
		--tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]

idvpc1:			# Get Id of vpc1
	$(eval VPC_ID_1=$(shell awslocal ec2 \
		describe-vpcs \
		--query 'Vpcs[?CidrBlock==`'${CIDR_1}'`].VpcId' \
		--output text))

crsn1: idvpc1	# create a subnet1
	awslocal ec2 \
		create-subnet \
		--vpc-id ${VPC_ID_1} \
		--cidr-block ${CIDR_1} \
		--tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]

idsn1: idvpc1	# Get Id of subnet1
	$(eval SUBNET_ID_1=$(shell awslocal ec2 \
		describe-subnets \
		--query 'Subnets[?VpcId==`'${VPC_ID_1}'`].SubnetId' \
		--output text))

crvpc2:			# Create a vpc2
	awslocal ec2 \
		create-vpc \
		--cidr-block ${CIDR_2} \
		--tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]

idvpc2:			# Get Id of vpc2
	$(eval VPC_ID_2=$(shell awslocal ec2 \
		describe-vpcs \
		--query 'Vpcs[?CidrBlock==`'${CIDR_2}'`].VpcId' \
		--output text))

crsn2: idvpc2	# create a subnet2
	awslocal ec2 \
		create-subnet \
		--vpc-id ${VPC_ID_2} \
		--cidr-block ${CIDR_2} \
		--tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]

idsn2: idvpc2	# Get Id of subnet2
	$(eval SUBNET_ID_2=$(shell awslocal ec2 \
		describe-subnets \
		--query 'Subnets[?VpcId==`'${VPC_ID_2}'`].SubnetId' \
		--output text))

sg1:			# Create Security Group
	awslocal ec2 \
		create-security-group \
		--group-name ${GRP_NAME} \
		--description "My security group"

idsg1:			# Get Id of Security Group
	$(eval SG_ID=$(shell awslocal ec2 \
		describe-security-groups \
		--query 'SecurityGroups[?GroupName==`'${GRP_NAME}'`].GroupId' \
		--output text))

create: crvpc1 crsn1 idsn1 crvpc2 crsn2 idsn2 sg1 idsg1		## Creates a Resolver endpoint
	awslocal route53resolver \
		create-resolver-endpoint \
		--name ${EP_NAME} \
		--creator-request-id 2020-01-01-18:47 \
		--security-group-ids ${SG_ID} \
		--direction INBOUND \
		--ip-addresses SubnetId=${SUBNET_ID_1},Ip=${IP_1} SubnetId=${SUBNET_ID_2},Ip=${IP_2}

list:			## Lists all the Resolver endpoints
	awslocal route53resolver list-resolver-endpoints
	awslocal ec2 describe-subnets
	awslocal ec2 describe-vpcs

id:				# Get resolver endpoint id
	$(eval REP_ID=$(shell awslocal route53resolver \
		list-resolver-endpoints \
		--query 'ResolverEndpoints[?Name==`'${EP_NAME}'`].Id' \
		--output text))

get: id			## Gets information about a specified hosted zone
	awslocal route53resolver \
		get-resolver-endpoint \
		--resolver-endpoint-id ${REP_ID}
	
clean: id idsg1 idsn1 idsn2 idvpc1 idvpc2		## Deletes a hosted zone
	awslocal route53resolver \
		delete-resolver-endpoint \
		--resolver-endpoint-id ${REP_ID} || true

	awslocal ec2 delete-security-group --group-id ${SG_ID} || true
	awslocal ec2 delete-subnet --subnet-id ${SUBNET_ID_2} || true
	awslocal ec2 delete-subnet --subnet-id ${SUBNET_ID_1} || true
	awslocal ec2 delete-vpc --vpc-id ${VPC_ID_2} || true
	awslocal ec2 delete-vpc --vpc-id ${VPC_ID_1} || true

.PHONY: usage install create list get clean
