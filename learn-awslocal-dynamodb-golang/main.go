package main

import (
	"log"
	"os"
	"strconv"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/dynamodb/expression"
)

type Item struct {
	StudentId int
	Subject   string
}

// export AWS_ACCESS_KEY_ID="test"
// export AWS_SECRET_ACCESS_KEY="test"
// export AWS_DEFAULT_REGION="us-east-1"
// export LOCALSTACK_ENDPOINT="http://localhost:4566"
func main() {
	svc := localstack_DynamoDB()
	createTable(svc)
	populateDb(svc)
	items := getItems(svc)
	log.Printf("items=[%v]", items)
}

func localstack_DynamoDB() *dynamodb.DynamoDB {
	sess, _ := session.NewSession(&aws.Config{
		Region:      aws.String(os.Getenv("AWS_DEFAULT_REGION")),
		Credentials: credentials.NewStaticCredentials(os.Getenv("AWS_ACCESS_KEY_ID"), os.Getenv("AWS_SECRET_ACCESS_KEY"), ""),
		Endpoint:    aws.String(os.Getenv("LOCALSTACK_ENDPOINT")),
	})

	svc := dynamodb.New(sess)
	return svc
}

func createTable(svc *dynamodb.DynamoDB) {
	tableName := "Students"

	input := &dynamodb.CreateTableInput{
		AttributeDefinitions: []*dynamodb.AttributeDefinition{
			{
				AttributeName: aws.String("StudentId"),
				AttributeType: aws.String("N"),
			},
			{
				AttributeName: aws.String("Subject"),
				AttributeType: aws.String("S"),
			},
		},

		KeySchema: []*dynamodb.KeySchemaElement{
			{
				AttributeName: aws.String("StudentId"),
				KeyType:       aws.String("HASH"),
			},
			{
				AttributeName: aws.String("Subject"),
				KeyType:       aws.String("RANGE"),
			},
		},

		ProvisionedThroughput: &dynamodb.ProvisionedThroughput{
			ReadCapacityUnits:  aws.Int64(10),
			WriteCapacityUnits: aws.Int64(10),
		},

		TableName: aws.String(tableName),
	}

	_, err := svc.CreateTable(input)
	if err != nil {
		log.Fatalf("Got error calling CreateTable: %s", err)
	}
}

func populateDb(svc *dynamodb.DynamoDB) {
	for i := 1; i < 100; i++ {
		item := Item{
			StudentId: i,
			Subject:   "Subject" + strconv.Itoa(i),
		}

		av, err := dynamodbattribute.MarshalMap(item)
		if err != nil {
			log.Fatalf("Got error marshalling new item: %s", err)
		}

		tableName := "Students"

		input := &dynamodb.PutItemInput{
			Item:      av,
			TableName: aws.String(tableName),
		}

		_, err = svc.PutItem(input)
		if err != nil {
			log.Fatalf("Got error calling PutItem: %s", err)
		}
	}
}

func getItems(svc *dynamodb.DynamoDB) []Item {
	tableName := "Students"

	proj := expression.NamesList(expression.Name("StudentId"), expression.Name("Subject"))

	expr, err := expression.NewBuilder().WithProjection(proj).Build()
	if err != nil {
		log.Fatalf("Got error building expression: %s", err)
	}

	params := &dynamodb.ScanInput{
		ExpressionAttributeNames:  expr.Names(),
		ExpressionAttributeValues: expr.Values(),
		ProjectionExpression:      expr.Projection(),
		TableName:                 aws.String(tableName),
	}

	items := []Item{}

	pageNum := 0
	err = svc.ScanPages(params,
		func(page *dynamodb.ScanOutput, lastPage bool) bool {
			pageNum++
			for _, i := range page.Items {
				studentId, err := strconv.Atoi(*i["StudentId"].N)
				if err != nil {
					log.Fatalln("Invalid Student ID")
				}

				item := Item{
					StudentId: studentId,
					Subject:   *i["Subject"].S,
				}

				items = append(items, item)
			}
			return pageNum <= 3
		})
	if err != nil {
		log.Fatalf("Query API call failed: %s", err)
	}

	return items
}
