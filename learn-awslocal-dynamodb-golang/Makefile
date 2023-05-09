#!/usr/bin/make -f

export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION = us-east-1

# source path
PRJ_NAME=$(shell basename "$(PWD)")
PRJ_BASE=$(shell pwd)

TABLE_NAME := Students

usage:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	
dep:		## Get the dependencies
	@go get -v -d ./...

env:		## Get Environment variables
	@echo "PRJ_NAME     = ${PRJ_NAME}"
	@echo "PRJ_BASE     = ${PRJ_BASE}"
	@echo "AWS_ACCESS_KEY_ID	= ${AWS_ACCESS_KEY_ID}"
	@echo "AWS_SECRET_ACCESS_KEY	= ${AWS_SECRET_ACCESS_KEY}"
	@echo "AWS_DEFAULT_REGION	= ${AWS_DEFAULT_REGION}"
	@echo "AWS_ENDPOINT_URL	= ${AWS_ENDPOINT_URL}"

run: env dep	## running application
	go run main.go
	exit 0

build: dep	## Builds the project
	@go build ${LDFLAGS} -v -o ${PRJ_NAME} .

install: dep	## Install missing dependencies.
	@go install ${LDFLAGS}

list:		## list all tables and itemCount
	awslocal dynamodb list-tables
	awslocal dynamodb describe-table --table-name ${TABLE_NAME} --query 'Table.ItemCount'

clean:		## Remove previous builds
	awslocal dynamodb delete-table --table-name ${TABLE_NAME}
	@go clean

.PHONY: usage run install list clean
