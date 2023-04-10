export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:	## Install dependencies
	@which awslocal || pip install awscli-local

create:		## create a domain
	awslocal redshift create-cluster \
		--cluster-identifier mysamplecluster \
		--master-username masteruser \
		--master-user-password secret1 \
		--node-type ds2.xlarge \
		--cluster-type single-node

check:		## Check the Redshift cluster
	@echo "# Check the Redshift cluster creation progress"
	awslocal redshift describe-clusters --cluster-identifier mysamplecluster

	@echo "# Get all the information about all cluster security groups"
	awslocal redshift describe-cluster-security-groups

	@echo "# Get all the general cluster properties"
	awslocal redshift describe-clusters

modify:		## Associate a cluster with a cluster security group
	awslocal redshift modify-cluster \
		--cluster-identifier mysamplecluster \
		--cluster-security-groups mysamplesecuritygroup

clean:	 	## Delete a cluster without specifying a final snapshot
	awslocal redshift delete-cluster \
		--cluster-identifier mysamplecluster \
		--skip-final-cluster-snapshot
	
.PHONY: usage install create check modify clean
